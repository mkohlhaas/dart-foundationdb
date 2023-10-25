class Tuple {}

// TODO:
// TDD: write tests first
// https://dart.dev/guides/testing
// https://docs.flutter.dev/cookbook/testing/unit/introduction

// https://github.com/josephg/fdb-tuple/tree/master/lib
// ByteData for encoding/decoding

// from go binding
// const nilCode = 0x00
// const bytesCode = 0x01
// const stringCode = 0x02
// const nestedCode = 0x05
// const intZeroCode = 0x14
// const posIntEnd = 0x1d
// const negIntStart = 0x0b
// const floatCode = 0x20
// const doubleCode = 0x21
// const falseCode = 0x26
// const trueCode = 0x27
// const uuidCode = 0x30
// const versionstampCode = 0x33

// (un-)pack functions:
//
// for (var item in ['String', nullString, 2341, 45.4]) {
//   switch (item) {
//     case _ when item is double:
//       print(item);
//     case _ when item == null:
//       print(item);
//     case _ when item is int:
//       print(item);
//     case _ when item is bool:
//       print(item);
//     case _ when item is String:
//       print(item);
//   }
// }

