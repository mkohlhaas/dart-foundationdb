import 'dart:typed_data';

import 'package:foundationdb/foundationdb.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

void main() {
  group('Encoding/Decoding:', () {
    group('Packing:', () {
      group('Tuples:', () {
        group('Basic Types:', () {
          test('Null', () {
            expect(null.pack(), Uint8List.fromList([0]));
          });
          test('Byte List', () {
            expect(Uint8List.fromList([102, 111, 111]).pack(), Uint8List.fromList([0x01, 102, 111, 111, 0x00]));
          });
          test('Byte List with 0x00', () {
            expect(
              Uint8List.fromList([102, 111, 111, 0x00, 98, 97, 114]).pack(),
              Uint8List.fromList([0x01, 102, 111, 111, 0x00, 0xff, 98, 97, 114, 0x00]),
            );
          });
          test('Unicode String', () {
            expect('foo'.pack(), Uint8List.fromList([0x02, 102, 111, 111, 0x00]));
          });
          test('Unicode String with 0x00', () {
            expect('foo\u0000bar'.pack(), Uint8List.fromList([0x02, 102, 111, 111, 0x00, 0xff, 98, 97, 114, 0x00]));
          });
          group('Integer:', () {
            group('Zero:', () {
              test('0', () {
                expect(0.pack(), Uint8List.fromList([0x14]));
              });
            });
            group('Positive:', () {
              test('1', () {
                expect(1.pack(), Uint8List.fromList([0x1c, 0, 0, 0, 0, 0, 0, 0, 1]));
              });
              test('2', () {
                expect(2.pack(), Uint8List.fromList([0x1c, 0, 0, 0, 0, 0, 0, 0, 2]));
              });
              test('5551212', () {
                expect(5551212.pack(), Uint8List.fromList([28, 0, 0, 0, 0, 0, 84, 180, 108]));
              });
            });
            group('Negative:', () {
              test('-1', () {
                expect((-1).pack(), Uint8List.fromList([0x0c, 255, 255, 255, 255, 255, 255, 255, 255]));
              });
              test('-2', () {
                expect((-2).pack(), Uint8List.fromList([0x0c, 255, 255, 255, 255, 255, 255, 255, 254]));
              });
              test('-5551212', () {
                expect((-5551212).pack(), Uint8List.fromList([12, 255, 255, 255, 255, 255, 171, 75, 148]));
              });
            });
          });
          group('Double:', () {
            group('Positive:', () {
              test('5551212.0', () {
                expect((5551212.0).pack(), Uint8List.fromList([33, 193, 85, 45, 27, 0, 0, 0, 0]));
              });
              test('10.0', () {
                expect((10.0).pack(), Uint8List.fromList([33, 192, 36, 0, 0, 0, 0, 0, 0]));
              });
              test('20.0', () {
                expect((20.0).pack(), Uint8List.fromList([33, 192, 52, 0, 0, 0, 0, 0, 0]));
              });
            });
            group('Negative:', () {
              test('-5551212.0', () {
                expect((-5551212.0).pack(), Uint8List.fromList([33, 62, 170, 210, 228, 255, 255, 255, 255]));
              });
              test('-10.0', () {
                expect((-10.0).pack(), Uint8List.fromList([33, 63, 219, 255, 255, 255, 255, 255, 255]));
              });
              test('-20.0', () {
                expect((-20.0).pack(), Uint8List.fromList([33, 63, 203, 255, 255, 255, 255, 255, 255]));
              });
            });
          });
          group('Bool:', () {
            test('False', () {
              expect(false.pack(), Uint8List.fromList([0x26]));
            });
            test('Bool: True', () {
              expect(true.pack(), Uint8List.fromList([0x27]));
            });
          });
          group('UUID:', () {
            test('110ec58a-a0f2-4ac4-8393-c866d813b8d1', () {
              final uuid = UuidValue.fromString('110ec58a-a0f2-4ac4-8393-c866d813b8d1');
              expect(uuid.pack(), Uint8List.fromList([48, 17, 14, 197, 138, 160, 242, 74, 196, 131, 147, 200, 102, 216, 19, 184, 209]));
            });
          });
          group('Nesting:', () {
            test('Null:', () {
              expect([null].pack(), Uint8List.fromList([5, 0, 255, 0]));
            });
            test('Null and Empty List', () {
              expect(
                  [
                    Uint8List.fromList([102, 111, 111, 0x00, 98, 97, 114]),
                    null,
                    []
                  ].pack(),
                  Uint8List.fromList([0x05, 0x01, 102, 111, 111, 0x00, 0xff, 98, 97, 114, 0x00, 0x00, 0xff, 0x05, 0x00, 0x00]));
            });
          });
        });
      });
    });
    group('Unpacking:', () {
      group('Tuples:', () {
        group('Basic Types:', () {
          test('asdf', () {
            expect(Uint8List.fromList([5, 0, 255, 0]).unpack(acc: []), [null]);
          });
          test('Byte List', () {
            expect(Uint8List.fromList([0x01, 102, 111, 111, 0x00]).unpack(acc: []), [
              Uint8List.fromList([102, 111, 111])
            ]);
          });
          test('Byte List with 0x00', () {
            expect(
              Uint8List.fromList([0x01, 102, 111, 111, 0x00, 0xff, 98, 97, 114, 0x00]).unpack(acc: []),
              [
                Uint8List.fromList([102, 111, 111, 0x00, 98, 97, 114])
              ],
            );
          });
          test('Unicode String', () {
            expect(Uint8List.fromList([0x02, 102, 111, 111, 0x00]).unpack(acc: []), ['foo']);
          });
          test('Unicode String with 0x00', () {
            expect(Uint8List.fromList([0x02, 102, 111, 111, 0x00, 0xff, 98, 97, 114, 0x00]).unpack(acc: []), ['foo\u0000bar']);
          });
          group('Integer:', () {
            group('Zero:', () {
              test('0', () {
                expect(Uint8List.fromList([0x14]).unpack(acc: []), [0]);
              });
            });
            group('Positive:', () {
              test('Integer positive', () {
                expect(Uint8List.fromList([0x1c, 0, 0, 0, 0, 0, 0, 0, 1]).unpack(acc: []), [1]);
              });
              test('Integer positive', () {
                expect(Uint8List.fromList([0x1c, 0, 0, 0, 0, 0, 0, 0, 2]).unpack(acc: []), [2]);
              });
              test('5551212', () {
                expect(Uint8List.fromList([28, 0, 0, 0, 0, 0, 84, 180, 108]).unpack(acc: []), [5551212]);
              });
            });
            group('Negative:', () {
              test('-1', () {
                expect(Uint8List.fromList([0x0c, 255, 255, 255, 255, 255, 255, 255, 255]).unpack(acc: []), [-1]);
              });
              test('-2', () {
                expect(Uint8List.fromList([0x0c, 255, 255, 255, 255, 255, 255, 255, 254]).unpack(acc: []), [-2]);
              });
              test('-5551212', () {
                expect(Uint8List.fromList([12, 255, 255, 255, 255, 255, 171, 75, 148]).unpack(acc: []), [-5551212]);
              });
            });
          });
          group('Double:', () {
            group('Positive:', () {
              test('5551212.0', () {
                expect(Uint8List.fromList([33, 193, 85, 45, 27, 0, 0, 0, 0]).unpack(acc: []), [5551212.0]);
              });
              test('10.0', () {
                expect(Uint8List.fromList([33, 192, 36, 0, 0, 0, 0, 0, 0]).unpack(acc: []), [10.0]);
              });
              test('20.0', () {
                expect(Uint8List.fromList([33, 192, 52, 0, 0, 0, 0, 0, 0]).unpack(acc: []), [20.0]);
              });
            });
            group('Negative:', () {
              test('-5551212.0', () {
                expect(Uint8List.fromList([33, 62, 170, 210, 228, 255, 255, 255, 255]).unpack(acc: []), [-5551212.0]);
              });
              test('-10.0', () {
                expect(Uint8List.fromList([33, 63, 219, 255, 255, 255, 255, 255, 255]).unpack(acc: []), [-10.0]);
              });
              test('-20.0', () {
                expect(Uint8List.fromList([33, 63, 203, 255, 255, 255, 255, 255, 255]).unpack(acc: []), [-20.0]);
              });
            });
          });
          group('Bool:', () {
            test('False', () {
              expect(Uint8List.fromList([0x26]).unpack(acc: []), [false]);
            });
            test('True', () {
              expect(Uint8List.fromList([0x27]).unpack(acc: []), [true]);
            });
          });
          group('UUID:', () {
            test('110ec58a-a0f2-4ac4-8393-c866d813b8d1', () {
              expect(Uint8List.fromList([48, 17, 14, 197, 138, 160, 242, 74, 196, 131, 147, 200, 102, 216, 19, 184, 209]).unpack(acc: []),
                  [UuidValue.fromString('110ec58a-a0f2-4ac4-8393-c866d813b8d1')]);
            });
          });
          group('Nesting:', () {
            test('Null and Empty List', () {
              expect(Uint8List.fromList([0x05, 0x01, 102, 111, 111, 0x00, 0xff, 98, 97, 114, 0x00, 0x00, 0xff, 0x05, 0x00, 0x00]).unpack(acc: []), [
                Uint8List.fromList([102, 111, 111, 0x00, 98, 97, 114]),
                null,
                []
              ]);
            });
          });
        });
      });
    });
  });
}
