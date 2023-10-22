// ignore_for_file: unused_element

import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';

Pointer<Uint8> _bytesFromList(List<int> ints) {
  final Pointer<Uint8> ptr = calloc(ints.length);
  final Uint8List list = ptr.asTypedList(ints.length);
  list.setAll(0, ints);
  return ptr;
}

extension AsKeyValue on String {
  Uint8List get askey {
    return utf8.encoder.convert(this);
  }

  Uint8List get asval {
    return utf8.encoder.convert(this);
  }

  bool get isSystemKey => askey.first == 255;
}

typedef FdbKey = Uint8List;
typedef FdbValue = Uint8List;

extension FdbKeySelector on String {
  KeySelector get lastLessThan => KeySelector(this, 0, 0);
  KeySelector get lastLessOrEqual => KeySelector(this, 1, 0);
  KeySelector get firstGreaterOrEqual => KeySelector(this, 0, 1);
  KeySelector get firstGreaterThan => KeySelector(this, 1, 1);
}

class KeySelector {
  String key;
  int orEqual;
  int offset;

  KeySelector(this.key, this.orEqual, this.offset);

  factory KeySelector.lastLessThan(String key) => key.lastLessThan;
  factory KeySelector.lastLessOrEqual(String key) => key.lastLessOrEqual;
  factory KeySelector.firstGreaterOrEqual(String key) => key.firstGreaterOrEqual;
  factory KeySelector.firstGreaterThan(String key) => key.firstGreaterThan;

  operator +(int val) => KeySelector(key, orEqual, offset + val);
  operator -(int val) => KeySelector(key, orEqual, offset - val);
}
