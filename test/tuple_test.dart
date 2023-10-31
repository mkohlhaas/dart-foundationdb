import 'dart:typed_data';

// ignore: deprecated_member_use, depend_on_referenced_packages
import "package:collection/equality.dart";
import 'package:foundationdb/foundationdb.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/v1.dart';

void main() {
  group('Encoding/Decoding:', () {
    group('Packing:', () {
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
              expect(5551212.pack(), Uint8List.fromList([0x1c, 0, 0, 0, 0, 0, 84, 180, 108]));
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
              expect((-5551212).pack(), Uint8List.fromList([0x0c, 255, 255, 255, 255, 255, 171, 75, 148]));
            });
          });
        });
        group('Double:', () {
          group('Positive:', () {
            test('5551212.0', () {
              expect((5551212.0).pack(), Uint8List.fromList([0x21, 193, 85, 45, 27, 0, 0, 0, 0]));
            });
            test('10.0', () {
              expect((10.0).pack(), Uint8List.fromList([0x21, 192, 36, 0, 0, 0, 0, 0, 0]));
            });
            test('20.0', () {
              expect((20.0).pack(), Uint8List.fromList([0x21, 192, 52, 0, 0, 0, 0, 0, 0]));
            });
          });
          group('Negative:', () {
            test('-5551212.0', () {
              expect((-5551212.0).pack(), Uint8List.fromList([0x21, 62, 170, 210, 228, 255, 255, 255, 255]));
            });
            test('-10.0', () {
              expect((-10.0).pack(), Uint8List.fromList([0x21, 63, 219, 255, 255, 255, 255, 255, 255]));
            });
            test('-20.0', () {
              expect((-20.0).pack(), Uint8List.fromList([0x21, 63, 203, 255, 255, 255, 255, 255, 255]));
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
            expect(uuid.pack(),
                Uint8List.fromList([0x30, 17, 14, 197, 138, 160, 242, 74, 196, 131, 147, 200, 102, 216, 19, 184, 209]));
          });
        });
        group('Tuples:', () {
          test('Null:', () {
            expect([null].pack(), Uint8List.fromList([0x05, 0, 255, 0]));
          });
          test('Null and Empty List', () {
            expect(
                [
                  Uint8List.fromList([102, 111, 111, 0x00, 98, 97, 114]),
                  null,
                  []
                ].pack(),
                Uint8List.fromList(
                    [0x05, 0x01, 102, 111, 111, 0x00, 0xff, 98, 97, 114, 0x00, 0x00, 0xff, 0x05, 0x00, 0x00]));
          });
        });
      });
    });
    group('Unpacking:', () {
      group('Basic Types:', () {
        test('Byte List', () {
          expect(Uint8List.fromList([0x01, 102, 111, 111, 0x00]).unpack(), [
            Uint8List.fromList([102, 111, 111])
          ]);
        });
        test('Byte List with 0x00', () {
          expect(
            Uint8List.fromList([0x01, 102, 111, 111, 0x00, 0xff, 98, 97, 114, 0x00]).unpack(),
            [
              Uint8List.fromList([102, 111, 111, 0x00, 98, 97, 114])
            ],
          );
        });
        test('Unicode String', () {
          expect(Uint8List.fromList([0x02, 102, 111, 111, 0x00]).unpack(), ['foo']);
        });
        test('Unicode String with 0x00', () {
          expect(Uint8List.fromList([0x02, 102, 111, 111, 0x00, 0xff, 98, 97, 114, 0x00]).unpack(), ['foo\u0000bar']);
        });
        group('Integer:', () {
          group('Zero:', () {
            test('0', () {
              expect(Uint8List.fromList([0x14]).unpack(), [0]);
            });
          });
          group('Positive:', () {
            test('Integer positive', () {
              expect(Uint8List.fromList([0x1c, 0, 0, 0, 0, 0, 0, 0, 1]).unpack(), [1]);
            });
            test('Integer positive', () {
              expect(Uint8List.fromList([0x1c, 0, 0, 0, 0, 0, 0, 0, 2]).unpack(), [2]);
            });
            test('5551212', () {
              expect(Uint8List.fromList([0x1c, 0, 0, 0, 0, 0, 84, 180, 108]).unpack(), [5551212]);
            });
          });
          group('Negative:', () {
            test('-1', () {
              expect(Uint8List.fromList([0x0c, 255, 255, 255, 255, 255, 255, 255, 255]).unpack(), [-1]);
            });
            test('-2', () {
              expect(Uint8List.fromList([0x0c, 255, 255, 255, 255, 255, 255, 255, 254]).unpack(), [-2]);
            });
            test('-5551212', () {
              expect(Uint8List.fromList([0x0c, 255, 255, 255, 255, 255, 171, 75, 148]).unpack(), [-5551212]);
            });
          });
        });
        group('Double:', () {
          group('Positive:', () {
            test('5551212.0', () {
              expect(Uint8List.fromList([0x21, 193, 85, 45, 27, 0, 0, 0, 0]).unpack(), [5551212.0]);
            });
            test('10.0', () {
              expect(Uint8List.fromList([0x21, 192, 36, 0, 0, 0, 0, 0, 0]).unpack(), [10.0]);
            });
            test('20.0', () {
              expect(Uint8List.fromList([0x21, 192, 52, 0, 0, 0, 0, 0, 0]).unpack(), [20.0]);
            });
          });
          group('Negative:', () {
            test('-5551212.0', () {
              expect(Uint8List.fromList([0x21, 62, 170, 210, 228, 255, 255, 255, 255]).unpack(), [-5551212.0]);
            });
            test('-10.0', () {
              expect(Uint8List.fromList([0x21, 63, 219, 255, 255, 255, 255, 255, 255]).unpack(), [-10.0]);
            });
            test('-20.0', () {
              expect(Uint8List.fromList([0x21, 63, 203, 255, 255, 255, 255, 255, 255]).unpack(), [-20.0]);
            });
          });
        });
        group('Bool:', () {
          test('False', () {
            expect(Uint8List.fromList([0x26]).unpack(), [false]);
          });
          test('True', () {
            expect(Uint8List.fromList([0x27]).unpack(), [true]);
          });
        });
        group('UUID:', () {
          test('110ec58a-a0f2-4ac4-8393-c866d813b8d1', () {
            expect(
                Uint8List.fromList([0x30, 17, 14, 197, 138, 160, 242, 74, 196, 131, 147, 200, 102, 216, 19, 184, 209])
                    .unpack(),
                [UuidValue.fromString('110ec58a-a0f2-4ac4-8393-c866d813b8d1')]);
          });
        });
        group('Tuples:', () {
          test('Null:', () {
            expect(Uint8List.fromList([0x05, 0, 255, 0]).unpack(), [null]);
          });
          test('Null and Empty List:', () {
            expect(
                Uint8List.fromList(
                    [0x05, 0x01, 102, 111, 111, 0x00, 0xff, 98, 97, 114, 0x00, 0x00, 0xff, 0x05, 0x00, 0x00]).unpack(),
                [
                  Uint8List.fromList([102, 111, 111, 0x00, 98, 97, 114]),
                  null,
                  []
                ]);
          });
        });
      });
    });
    group('Inverse', () {
      test('of [null]', () {
        Tuple toTest = [null];
        testInverseProperty(toTest);
      });
      test('of [false]', () {
        Tuple toTest = [false];
        testInverseProperty(toTest);
      });
      test('of [true]', () {
        Tuple toTest = [true];
        testInverseProperty(toTest);
      });
      test('of Byte List', () {
        Tuple toTest = [
          Uint8List.fromList([102, 111, 111])
        ];
        testInverseProperty(toTest);
      });
      test('Byte List with 0x00', () {
        Tuple toTest = [
          Uint8List.fromList([102, 111, 111, 0x00, 98, 97, 114])
        ];
        testInverseProperty(toTest);
      });
      test('Unicode String', () {
        Tuple toTest = ['foo'];
        testInverseProperty(toTest);
      });
      test('Unicode String with 0x00', () {
        Tuple toTest = ['foo\u0000bar'];
        testInverseProperty(toTest);
      });
      group('Integer:', () {
        group('Zero:', () {
          test('[0]', () {
            Tuple toTest = [0];
            testInverseProperty(toTest);
          });
        });
        group('Positive:', () {
          test('[1]', () {
            Tuple toTest = [1];
            testInverseProperty(toTest);
          });
          test('[2]', () {
            Tuple toTest = [2];
            testInverseProperty(toTest);
          });
          test('[5551212]', () {
            Tuple toTest = [5551212];
            testInverseProperty(toTest);
          });
        });
        group('Negative:', () {
          test('[-1]', () {
            Tuple toTest = [-1];
            testInverseProperty(toTest);
          });
          test('[-2]', () {
            Tuple toTest = [-2];
            testInverseProperty(toTest);
          });
          test('[-5551212]', () {
            Tuple toTest = [-5551212];
            testInverseProperty(toTest);
          });
        });
      });
      group('Double:', () {
        group('Positive:', () {
          test('[5551212.0]', () {
            Tuple toTest = [5551212.0];
            testInverseProperty(toTest);
          });
          test('[10.0]', () {
            Tuple toTest = [10.0];
            testInverseProperty(toTest);
          });
          test('[20.0]', () {
            Tuple toTest = [20.0];
            testInverseProperty(toTest);
          });
        });
        group('Negative:', () {
          test('[-5551212.0]', () {
            Tuple toTest = [-5551212.0];
            testInverseProperty(toTest);
          });
          test('[-10.0]', () {
            Tuple toTest = [-10.0];
            testInverseProperty(toTest);
          });
          test('[-20.0]', () {
            Tuple toTest = [-20.0];
            testInverseProperty(toTest);
          });
        });
      });
      group('Bool:', () {
        test('[false]', () {
          Tuple toTest = [false];
          testInverseProperty(toTest);
        });
        test('Bool: [true]', () {
          Tuple toTest = [true];
          testInverseProperty(toTest);
        });
      });
      group('UUIDValue:', () {
        test('Uuid Value', () {
          Tuple toTest = [UuidValue.fromString(UuidV1().generate())];
          testInverseProperty(toTest);
        });
      });
      group('Tuples:', () {
        test('[null]:', () {
          var toTest = [null];
          testInverseProperty(toTest);
        });
        test('Null and Empty List', () {
          Tuple toTest = [
            Uint8List.fromList([102, 111, 111, 0x00, 98, 97, 114]),
            null,
            []
          ];
          testInverseProperty(toTest);
        });
        test('All mixed up:', () {
          Tuple toTest = [
            null,
            [],
            Uint8List.fromList([102, 111, 111, 0x00, 98, 97, 114]),
            'Hallo',
            0,
            -245,
            -4534.234,
            UuidValue.fromString(UuidV1().generate()),
            3242.234,
            234432,
            true,
            false
          ];
          testInverseProperty(toTest);
        });
      });
    });
  });
}

void testInverseProperty(Tuple toTest) {
  final dce = DeepCollectionEquality();
  Tuple toTestPackedAndUnpacked = toTest.pack().unpack();
  bool isEqual = dce.equals(toTest, toTestPackedAndUnpacked);
  expect(isEqual, true);
}
