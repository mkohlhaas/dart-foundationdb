import 'dart:convert';
import 'dart:typed_data';

import 'package:uuid/uuid.dart';
// import 'package:uuid/uuid_value.dart';

// implementation of tuple as a generic list
typedef Tuple = List<dynamic>;

extension PackBool on bool {
  Uint8List pack([bool nested = false]) {
    if (this) {
      return Uint8List.fromList([0x27]);
    } else {
      return Uint8List.fromList([0x26]);
    }
  }
}

extension PackDouble on double {
  Uint8List pack([bool nested = false]) {
    final res = <int>[0x21];
    final bdata = ByteData(8);
    bdata.setFloat64(0, this);
    final r = Uint8List.fromList(bdata.buffer.asUint8List(0, 8));
    if (this < 0) {
      for (var i = 0; i < r.length; i++) {
        r[i] = ~r[i];
      }
    }
    res.addAll(r);
    return Uint8List.fromList(res);
  }
}

extension PackTuple on Tuple {
  Uint8List pack([bool nested = true]) {
    final res = <int>[0x05];
    for (final item in this) {
      switch (item) {
        case _ when item == null:
          res.addAll(null.pack(nested));
        case _ when item is bool:
          res.addAll(item.pack());
        case _ when item is int:
          res.addAll(item.pack());
        case _ when item is double:
          res.addAll(item.pack());
        case _ when item is String:
          res.addAll(item.pack());
        case _ when item is UuidValue:
          res.addAll(item.pack());
        case _ when item is Uint8List:
          res.addAll(item.pack());
        case _ when item is List:
          res.addAll(item.pack());
      }
    }
    res.add(0x00);
    return Uint8List.fromList(res);
  }
}

extension PackInt on int {
  Uint8List pack([bool nested = false]) {
    var res = <int>[];
    var bdata = ByteData(8);
    switch (this) {
      case _ when this == 0:
        return Uint8List.fromList([0x14]);
      case _ when this < 0:
        res = <int>[0x0c];
      case _ when this > 0:
        res = <int>[0x1c];
    }
    bdata.setInt64(0, this);
    res.addAll(Uint8List.fromList(bdata.buffer.asUint8List(0, 8)));
    return Uint8List.fromList(res);
  }
}

extension PackNull on Null {
  Uint8List pack([bool nested = false]) {
    if (nested) {
      return Uint8List.fromList([0x00, 0xFF]);
    } else {
      return Uint8List.fromList([0x00]);
    }
  }
}

extension PackString on String {
  Uint8List pack([bool nested = false]) {
    final res = <int>[0x02];
    for (final item in (utf8.encode(this))) {
      if (item == 0x00) {
        res.addAll([0x00, 0xFF]);
      } else {
        res.add(item);
      }
    }
    res.add(0x00);
    return Uint8List.fromList(res);
  }
}

extension PackUint8List on Uint8List {
  Uint8List pack([bool nested = false]) {
    final res = <int>[0x01];
    for (final item in this) {
      if (item == 0x00) {
        res.addAll([0x00, 0xFF]);
      } else {
        res.add(item);
      }
    }
    res.add(0x00);
    return Uint8List.fromList(res);
  }

  Tuple unpack([bool nested = false]) {
    int len = 0;
    // ignore: prefer_typing_uninitialized_variables
    Tuple result = [];
    dynamic res;
    Uint8List cpLst = Uint8List.sublistView(this);
    while (cpLst.isNotEmpty) {
      int opcode = cpLst[0];
      cpLst = Uint8List.sublistView(cpLst, 1);
      (res, len) = switch (opcode) {
        0x00 => cpLst.unpackNull(),
        0x01 => cpLst.unpackUint8List(),
        0x02 => cpLst.unpackString(),
        0x05 => cpLst.unpackNestedTuple(true),
        0x0c || 0x1c => cpLst.unpackInteger(),
        0x14 => cpLst.unpackZeroInteger(),
        0x21 => cpLst.unpackDouble(),
        0x26 => cpLst.unpackFalse(),
        0x27 => cpLst.unpackTrue(),
        0x30 => cpLst.unpackUuidValue(),
        _ => throw ArgumentError('Found unproper unpacking opcode: $opcode'),
      };
      result.add(res);
      cpLst = Uint8List.sublistView(cpLst, len);
      print('${cpLst.length}: $len');
      if (cpLst.isNotEmpty) {
        throw ArgumentError('There are still things to unpack in the buffer.');
      }
    }
    return result;
  }

  // ignore: prefer_void_to_null
  (Null, int) unpackNull([bool nested = false]) {
    if (nested) {
      if (this[0] != 0xff) {
        throw ArgumentError('Unpacking a nested Null must be terminated by 0xff.');
      }
      return (null, 1);
    } else {
      return (null, 0);
    }
  }

  (bool, int) unpackTrue([bool nested = false]) {
    return (true, 0);
  }

  (bool, int) unpackFalse([bool nested = false]) {
    return (false, 0);
  }

  (int, int) unpackZeroInteger([bool nested = false]) {
    return (0, 0);
  }

  (int, int) unpackInteger([bool nested = false]) {
    ByteData bdata = buffer.asByteData(offsetInBytes, 8);
    return (bdata.getInt64(0), 8);
  }

  // (int, int) unpackPositiveInteger([bool nested = false]) {
  //   ByteData bdata = buffer.asByteData(offsetInBytes, 8);
  //   return (bdata.getInt64(0), 8);
  // }

  // (int, int) unpackNegativeInteger([bool nested = false]) {
  //   ByteData bdata = buffer.asByteData(offsetInBytes, 8);
  //   return (bdata.getInt64(0), 8);
  // }

  (double, int) unpackDouble([bool nested = false]) {
    ByteData bdata = buffer.asByteData(offsetInBytes, 8);
    return (bdata.getFloat64(0), 8);
  }

  (String, int) unpackString([bool nested = false]) {
    final result = <int>[];
    int idx = 0;
    while (true) {
      if (this[idx] == 0x00 && length - idx - 1 > 0 && this[idx + 1] == 0xff) {
        result.add(this[idx]); // add 0x00
        idx++; // skip 0x00
        idx++; // skip 0xff
      } else if (this[idx] == 0x00) {
        return (utf8.decode(result), idx + 1); // we reached the end
      } else {
        result.add(this[idx]);
        idx++; // skip current item
      }
    }
  }

  (Uint8List, int) unpackUint8List([bool nested = false]) {
    final result = <int>[];
    int idx = 0;
    while (true) {
      if (this[idx] == 0x00 && length - idx - 1 > 0 && this[idx + 1] == 0xff) {
        result.add(this[idx]); // add 0x00
        idx++; // skip 0x00
        idx++; // skip 0xff
      } else if (this[idx] == 0x00) {
        return (Uint8List.fromList(result), idx + 1); // we reached the end
      } else {
        result.add(this[idx]);
        idx++; // skip current item
      }
    }
  }

  (UuidValue, int) unpackUuidValue([bool nested = false]) {
    return (UuidValue.fromByteList(buffer.asUint8List(1, 16)), 16);
  }

  (Tuple, int) unpackNestedTuple([bool nested = false]) {
    return ([], 0);
  }
}

extension PackUuidValue on UuidValue {
  Uint8List pack([bool nested = false]) {
    final res = <int>[0x30];
    res.addAll(toBytes());
    return Uint8List.fromList(res);
  }
}
