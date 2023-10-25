import 'dart:ffi';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';

import '../foundationdb.dart';

Pointer<Uint8> bytesFromList(List<int> ints) {
  final Pointer<Uint8> ptr = calloc(ints.length);
  final Uint8List list = ptr.asTypedList(ints.length);
  list.setAll(0, ints);
  return ptr;
}

Uint8List convertStringToUint8List(String str) {
  final List<int> codeUnits = str.codeUnits;
  final Uint8List unit8List = Uint8List.fromList(codeUnits);
  return unit8List;
}

String convertUint8ListToString(Uint8List uint8list) => String.fromCharCodes(uint8list);

// we interpret atomic as int64
Pointer<Uint8> pack(int number) {
  final bd = ByteData(sizeOf<Uint64>());
  bd.setUint64(0, number, Endian.little);
  final res = calloc<Uint8>(sizeOf<Uint64>());
  res.asTypedList(sizeOf<Uint64>()).setAll(0, bd.buffer.asUint64List());
  return res;
}

extension Uint8ListStr on String {
  Uint8List get uint8List => convertStringToUint8List(this);
}

extension StrUint8List on Uint8List {
  String get string => convertUint8ListToString(this);
}

// e.g. strinc('hallo') -> 'hallp'
String strinc(String key) {
  Uint8List lst = key.uint8List;
  while (lst.last == systemkey) {
    lst.removeLast();
  }
  if (lst.isEmpty) throw ArgumentError("Key must contain at least one byte not equal to 0xFF.");
  lst.last = lst.last + 1;
  return lst.string;
}
