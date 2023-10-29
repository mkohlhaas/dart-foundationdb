import 'dart:convert';
import 'dart:typed_data';

import 'package:uuid/uuid.dart';

typedef Tuple = List;

extension PackBool on bool {
  Uint8List pack() {
    if (this) {
      return Uint8List.fromList([0x27]);
    } else {
      return Uint8List.fromList([0x26]);
    }
  }
}

extension PackDouble on double {
  Uint8List pack() {
    final res = <int>[0x21];
    final bdata = ByteData(8);
    bdata.setFloat64(0, this);
    final r = Uint8List.fromList(bdata.buffer.asUint8List(0, 8));
    if (this < 0) {
      for (var i = 0; i < r.length; i++) {
        r[i] = ~r[i];
      }
    } else {
      r[0] ^= 0x80;
    }
    res.addAll(r);
    return Uint8List.fromList(res);
  }
}

extension PackInt on int {
  Uint8List pack() {
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
  Uint8List pack([bool isNested = false]) {
    if (isNested) {
      return Uint8List.fromList([0x00, 0xFF]);
    } else {
      return Uint8List.fromList([0x00]);
    }
  }
}

extension PackString on String {
  Uint8List pack() {
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

extension PackTuple on Tuple {
  Uint8List pack([bool isNested = true]) {
    final res = <int>[0x05];
    for (final item in this) {
      switch (item) {
        case _ when item == null:
          res.addAll(null.pack(isNested));
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
        default:
          throw ArgumentError('Unknown packable item type for: $item');
      }
    }
    res.add(0x00);
    return Uint8List.fromList(res);
  }
}

extension PackUint8List on Uint8List {
  Uint8List pack() {
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
}

extension PackUuidValue on UuidValue {
  Uint8List pack() {
    final res = <int>[0x30];
    res.addAll(toBytes());
    return Uint8List.fromList(res);
  }
}
