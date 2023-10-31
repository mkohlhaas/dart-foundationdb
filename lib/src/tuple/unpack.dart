import 'dart:convert';
import 'dart:typed_data';

import 'package:uuid/uuid.dart';

import '../../foundationdb.dart';

class UnpackEndMarker implements Exception {
  final String message;

  UnpackEndMarker(this.message);

  @override
  String toString() => message;
}

extension UnpackUint8List on Uint8List {
  ByteData bufAsByteData([int length = 8]) {
    return buffer.asByteData(offsetInBytes, length);
  }

  Uint8List skipBy(int numberOfBytes) {
    return Uint8List.sublistView(this, numberOfBytes);
  }

  Tuple unpack() {
    Tuple tuple;
    (tuple, _) = _unpack([], true);
    return tuple;
  }

  (dynamic, Uint8List) unpackByteList(Function(List<int>) f, [bool isNested = false]) {
    final result = <int>[];
    int idx = 0;
    while (true) {
      if (this[idx] == 0x00 && length - idx - 1 > 0 && this[idx + 1] == 0xff) {
        result.add(this[idx]); // add 0x00
        idx += 2; // goto next item
      } else if (this[idx] == 0x00) {
        return (f(result), skipBy(idx + 1)); // we reached the end
      } else {
        result.add(this[idx]);
        idx++; // goto next item
      }
    }
  }

  (double, Uint8List) unpackDouble() {
    ByteData bdata = bufAsByteData();
    if (this[0] & 0x80 == 0) {
      // double is negative
      for (var i = 0; i < 8; i++) {
        this[i] = ~this[i];
      }
    } else {
      // double is positive
      this[0] ^= 0x80;
    }
    return (bdata.getFloat64(0), skipBy(8));
  }

  (bool, Uint8List) unpackFalse() {
    return (false, this);
  }

  (int, Uint8List) unpackInteger() {
    ByteData bdata = bufAsByteData();
    return (bdata.getInt64(0), skipBy(8));
  }

  (int, int) unpackIntegerNegative() {
    ByteData bdata = bufAsByteData();
    for (var i = 0; i < 8; i++) {
      this[i] = ~this[i];
    }
    return (bdata.getInt64(0), 8);
  }

  (Tuple, int) unpackNestedTuple([bool isNested = false]) {
    return ([], 0);
  }

  // ignore: prefer_void_to_null
  (Null, Uint8List) unpackNullOrEndNestedTuple() {
    if (lengthInBytes > 0) {
      if (this[0] == 0xff) {
        return (null, skipBy(1));
      }
    }
    throw UnpackEndMarker('Hit end marker.');
  }

  (String, Uint8List) unpackString() {
    dynamic res;
    Uint8List lst;
    (res, lst) = unpackByteList(utf8.decode);
    return (res as String, lst);
  }

  (bool, Uint8List) unpackTrue() {
    return (true, this);
  }

  (Uint8List, Uint8List) unpackUint8List() {
    dynamic res;
    Uint8List lst;
    (res, lst) = unpackByteList(Uint8List.fromList);
    return (res as Uint8List, lst);
  }

  (UuidValue, Uint8List) unpackUuidValue() {
    return (UuidValue.fromByteList(buffer.asUint8List(offsetInBytes, 16)), skipBy(16));
  }

  (int, Uint8List) unpackZeroInteger() {
    return (0, this);
  }

  (Tuple, Uint8List) _unpack(Tuple acc, [bool isRoot = false]) {
    dynamic res;
    Uint8List cpLst = Uint8List.sublistView(this);
    try {
      while (cpLst.isNotEmpty) {
        int opcode = cpLst[0];
        cpLst = Uint8List.sublistView(cpLst, 1); // skip opcode
        if (isRoot) {
          isRoot = false;
          if (opcode == 0x05) {
            continue;
          }
        }
        (res, cpLst) = switch (opcode) {
          0x00 => cpLst.unpackNullOrEndNestedTuple(),
          0x01 => cpLst.unpackUint8List(),
          0x02 => cpLst.unpackString(),
          0x05 => cpLst._unpack([]), // nested tuple
          0x0C => cpLst.unpackInteger(),
          0x1C => cpLst.unpackInteger(),
          0x14 => cpLst.unpackZeroInteger(),
          0x21 => cpLst.unpackDouble(),
          0x26 => cpLst.unpackFalse(),
          0x27 => cpLst.unpackTrue(),
          0x30 => cpLst.unpackUuidValue(),
          _ => throw ArgumentError('Found unknown opcode: $opcode'),
        };
        acc.add(res);
      }
      return (acc, cpLst);
    } on UnpackEndMarker {
      return (acc, cpLst);
    }
  }
}
