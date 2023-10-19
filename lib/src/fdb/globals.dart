import 'dart:ffi';
import 'dart:io' show Platform, exit;

import 'package:ffi/ffi.dart';
import 'package:foundationdb/foundationdb.dart';
import 'package:system_info2/system_info2.dart';

final fdbc = _initLibrary();

void handleError(int errorCode) {
  if (errorCode != 0) {
    throw FDBException('FoundationDb: ${fdbc.fdb_get_error(errorCode).cast<Utf8>().toDartString()}', errorCode);
  }
}

bool isErrorMaybeCommitted(int errorCode) {
  return fdbc.fdb_error_predicate(FDBErrorPredicate.FDB_ERROR_PREDICATE_MAYBE_COMMITTED, errorCode) != 0;
}

bool isErrorRetryable(int errorCode) {
  return fdbc.fdb_error_predicate(FDBErrorPredicate.FDB_ERROR_PREDICATE_RETRYABLE, errorCode) != 0;
}

bool isErrorRetryableNotCommitted(int errorCode) {
  return fdbc.fdb_error_predicate(FDBErrorPredicate.FDB_ERROR_PREDICATE_RETRYABLE_NOT_COMMITTED, errorCode) != 0;
}

FDBC _initLibrary() {
  try {
    String sharedLib = switch (Platform.operatingSystem) {
      'linux' => 'libfdb_c.so',
      'macos' => 'libfdb_c.dylib',
      _ => throw Exception('Unsupported platform'),
    };
    if (SysInfo.kernelArchitecture != ProcessorArchitecture.x86_64) {
      throw Exception("FoundationDB is only supported on X86_64 and AMD64 architectures.");
    }
    return FDBC(DynamicLibrary.open(sharedLib));
  } catch (err) {
    print(err);
    exit(1);
  }
}
