import 'dart:ffi';

import 'package:ffi/ffi.dart';

import 'dart:typed_data';

Pointer<Uint8> pack(int number) {
  final bd = ByteData(sizeOf<Uint64>());
  bd.setUint64(0, number, Endian.little);
  final res = calloc<Uint8>(sizeOf<Uint64>());
  res.asTypedList(sizeOf<Uint64>()).setAll(0, bd.buffer.asUint64List());
  return res;
}
