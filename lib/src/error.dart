import 'package:ffi/ffi.dart';

import '../foundationdb.dart';

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

class FDBException implements Exception {
  final String message;
  final int errorCode;

  FDBException(this.message, this.errorCode);

  @override
  String toString() => message;
}
