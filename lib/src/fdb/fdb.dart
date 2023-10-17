// - final fdbc = FDBC(DynamicLibrary.open('libfdb_c.so'));
// - from https://github.com/apple/foundationdb/blob/main/bindings/ruby/lib/fdbimpl.rb
//   Use this package to find architecture: x86_64, ARM64, ...
//   - https://pub.dev/packages/system_info2
//
//     import 'dart:io' show Platform;
//     var so = switch(Platform.operatingSystem) {
//         case 'linux': 'libfdb_c.so';
//         case 'macos': 'libfdb_c.dylib';
//         case 'windows': 'fdb_c.dll';
//       }
class FDB {
  int? selectedApiVersion;

  static selectApiVersion(int version) {}
  static getApiVersion() {}
  static isApiVersionSelected() {}
  static getMaxApiVersion() {}
  static openDatabase() {}
  static openDatabaseDefault() {}
  static openDatabaseConfig() {}
}
