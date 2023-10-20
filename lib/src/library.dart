import 'dart:ffi';
import 'dart:io';

import 'package:system_info2/system_info2.dart';

import '../foundationdb.dart';

final fdbc = _initLibrary();

FdbC _initLibrary() {
  String sharedLib = switch (Platform.operatingSystem) {
    'linux' => 'libfdb_c.so',
    'macos' => 'libfdb_c.dylib',
    _ => throw Exception('Unsupported platform'),
  };
  if (SysInfo.kernelArchitecture != ProcessorArchitecture.x86_64) {
    throw Exception("FoundationDB is only supported on X86_64 and AMD64 architectures.");
  }
  return FdbC(DynamicLibrary.open(sharedLib));
}
