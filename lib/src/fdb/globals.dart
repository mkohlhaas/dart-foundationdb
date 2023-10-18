import 'dart:ffi';
import 'dart:io' show Platform, exit;

import 'package:ffi/ffi.dart';
import 'package:foundationdb/foundationdb.dart';
import 'package:system_info2/system_info2.dart';

final fdbc = _initFFI();

void handleError(int errorCode) {
  if (errorCode != 0) {
    throw FDBException(
        'FoundationDb: ${fdbc.fdb_get_error(errorCode).cast<Utf8>().toDartString()}',
        errorCode);
  }
}

bool isErrorMaybeCommitted(int errorCode) {
  int pred = FDBErrorPredicate.FDB_ERROR_PREDICATE_MAYBE_COMMITTED;
  return fdbc.fdb_error_predicate(pred, errorCode) != 0;
}

bool isErrorRetryable(int errorCode) {
  int pred = FDBErrorPredicate.FDB_ERROR_PREDICATE_RETRYABLE;
  return fdbc.fdb_error_predicate(pred, errorCode) != 0;
}

bool isErrorRetryableNotCommitted(int errorCode) {
  int pred = FDBErrorPredicate.FDB_ERROR_PREDICATE_RETRYABLE_NOT_COMMITTED;
  return fdbc.fdb_error_predicate(pred, errorCode) != 0;
}

FDBC _initFFI() {
  try {
    String platform = Platform.operatingSystem;
    String sharedLib = switch (platform) {
      'linux' => 'libfdb_c.so',
      'macos' => 'libfdb_c.dylib',
      _ => throw Exception('Unsupported platform'),
    };
    if (SysInfo.kernelArchitecture != ProcessorArchitecture.x86_64) {
      throw Exception("FoundationDB is only supported on X86_64 and AMD64 platforms.");
    }
    return FDBC(DynamicLibrary.open(sharedLib));
  } catch (err) {
    print(err);
    exit(1);
  }
}
