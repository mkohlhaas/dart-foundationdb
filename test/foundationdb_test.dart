import 'dart:typed_data';

import 'package:foundationdb/foundationdb.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

void main() {
  group('Encoding/Decoding Tuples:', () {
    group('Encoding Basic Types:', () {
      test('Null', () {
        expect(null.pack(), Uint8List.fromList([0]));
      });
      test('Byte List', () {
        expect(Uint8List.fromList([102, 111, 111]).pack(), Uint8List.fromList([0x01, 102, 111, 111, 0x00]));
      });
      test('Byte List with 0x00', () {
        expect(
            Uint8List.fromList([102, 111, 111, 0x00, 98, 97, 114]).pack(), Uint8List.fromList([0x01, 102, 111, 111, 0x00, 0xff, 98, 97, 114, 0x00]));
      });
      test('Unicode String', () {
        expect('foo'.pack(), Uint8List.fromList([0x02, 102, 111, 111, 0x00]));
      });
      test('Unicode String with 0x00', () {
        expect('foo\u0000bar'.pack(), Uint8List.fromList([0x02, 102, 111, 111, 0x00, 0xff, 98, 97, 114, 0x00]));
      });
      test('Integer zero (0)', () {
        expect(0.pack(), Uint8List.fromList([0x14]));
      });
      test('Integer positive', () {
        expect(1.pack(), Uint8List.fromList([0x1c, 0, 0, 0, 0, 0, 0, 0, 1]));
      });
      test('Integer positive', () {
        expect(2.pack(), Uint8List.fromList([0x1c, 0, 0, 0, 0, 0, 0, 0, 2]));
      });
      test('Integer negative', () {
        expect((-1).pack(), Uint8List.fromList([0x0c, 255, 255, 255, 255, 255, 255, 255, 255]));
      });
      test('Integer negative', () {
        expect((-2).pack(), Uint8List.fromList([0x0c, 255, 255, 255, 255, 255, 255, 255, 254]));
      });
      test('Integer negative', () {
        expect(5551212.pack(), Uint8List.fromList([28, 0, 0, 0, 0, 0, 84, 180, 108]));
      });
      test('Integer negative', () {
        expect((-5551212).pack(), Uint8List.fromList([12, 255, 255, 255, 255, 255, 171, 75, 148]));
      });
      test('Double', () {
        expect((10.0).pack(), Uint8List.fromList([33, 64, 36, 0, 0, 0, 0, 0, 0]));
      });
      test('Bool: False', () {
        expect(false.pack(), Uint8List.fromList([0x26]));
      });
      test('Bool: True', () {
        expect(true.pack(), Uint8List.fromList([0x27]));
      });
      test('UUID', () {
        final uuid = UuidValue.fromString('110ec58a-a0f2-4ac4-8393-c866d813b8d1');
        expect(uuid.pack(), Uint8List.fromList([48, 17, 14, 197, 138, 160, 242, 74, 196, 131, 147, 200, 102, 216, 19, 184, 209]));
      });
    });

    group('Decoding Uint8Lists into Tuples:', () {
      test('Null', () {
        expect(Uint8List.fromList([0]).unpack(), [null]);
      });
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
      test('Integer 0', () {
        expect(Uint8List.fromList([0x14]).unpack(), [0]);
      });
      test('Integer positive', () {
        expect(Uint8List.fromList([0x1c, 0, 0, 0, 0, 0, 0, 0, 1]).unpack(), [1]);
      });
      test('Integer positive', () {
        expect(Uint8List.fromList([0x1c, 0, 0, 0, 0, 0, 0, 0, 2]).unpack(), [2]);
      });
      test('Integer negative', () {
        expect(Uint8List.fromList([0x0c, 255, 255, 255, 255, 255, 255, 255, 255]).unpack(), [-1]);
      });
      test('Integer negative', () {
        expect(Uint8List.fromList([0x0c, 255, 255, 255, 255, 255, 255, 255, 254]).unpack(), [-2]);
      });
      test('Integer negative', () {
        expect(Uint8List.fromList([28, 0, 0, 0, 0, 0, 84, 180, 108]).unpack(), [5551212]);
      });
      test('Integer negative', () {
        expect(Uint8List.fromList([12, 255, 255, 255, 255, 255, 171, 75, 148]).unpack(), [-5551212]);
      });
      test('Double', () {
        expect(Uint8List.fromList([33, 64, 36, 0, 0, 0, 0, 0, 0]).unpack(), [10.0]);
      });
      test('False', () {
        expect(Uint8List.fromList([0x26]).unpack(), [false]);
      });
      test('True', () {
        expect(Uint8List.fromList([0x27]).unpack(), [true]);
      });
      test('UUID', () {
        expect(Uint8List.fromList([48, 17, 14, 197, 138, 160, 242, 74, 196, 131, 147, 200, 102, 216, 19, 184, 209]).unpack(),
            [UuidValue.fromString('110ec58a-a0f2-4ac4-8393-c866d813b8d1')]);
      });
      test('Nested', () {
        expect(Uint8List.fromList([0x05, 0x01, 102, 111, 111, 0x00, 0xff, 98, 97, 114, 0x00, 0x00, 0xff, 0x05, 0x00, 0x00]).unpack(), [
          Uint8List.fromList([102, 111, 111, 0x00, 98, 97, 114]),
          null,
          []
        ]);
      });
    });

    group('Encoding Tuples:', () {
      test('Nested', () {
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
}
