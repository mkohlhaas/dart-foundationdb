import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:foundationdb/src/key.dart';

import '../foundationdb.dart';

class Transaction {
  // Database? database;
  Database? snapshotDatabase;
  late final Pointer<FDB_transaction> _transaction;

  final int _isSnapshot;

  Transaction(this._transaction, [this._isSnapshot = 0]);

  getKey(KeySelector keySel) {
    final keySelKeyC = keySel.key.toNativeUtf8();
    try {
      var pFuture = fdbc.fdb_transaction_get_key(
        _transaction,
        keySelKeyC.cast(),
        keySelKeyC.length,
        keySel.orEqual,
        keySel.offset,
        _isSnapshot,
      );
    } finally {
      calloc.free(keySelKeyC);
    }
  }

  // TODO
  // get(key) {}
  // set(key, value) {}
  // operator [](key) {}
  // operator []=(key, value) {}

  // add(key, param) {}
  // addReadConflictKey(key) {}
  // addReadConflictRange(begin, end) {}
  // addWriteConflictKey(key) {}
  // addWriteConflictRange(begin, end) {}
  // bitAnd(key, param) {}
  // bitOr(key, param) {}
  // bitXor(key, param) {}
  // byteMax(key, param) {}
  // byteMin(key, param) {}
  // cancel() {}
  // clear(key) {}
  // clearRange(begin, end) {}
  // clearRangeStartWith(prefix) {}
  // commit() {}
  // compareAndClear(key, param) {}
  // getApproximateSize() {}
  // getCommittedVersion() {}
  // getEstimatedRangeSizeBytes(beginKey, endKey) {}
  // getRange(begin, end, options) {}
  // getRangeSplitPoints(beginKey, endKey, chunkSize) {}
  // getRangeStartWith(prefix, options) {}
  // getReadVersion() {}
  // getVersionstamp() {}
  // max(key, param) {}
  // min(key, param) {}
  // onError(exception) {}
  // reset() {}
  // setAccessSystemKeys() {}
  // setCausalReadRisky() {}
  // setCausalWriteRisky() {}
  // setDebugTransactionIdentifier(idString) {}
  // setLogTransaction() {}
  // setMaxRetryDelay() {}
  // setNextWriteNoWriteConflictRange() {}
  // setPriorityBatch() {}
  // setPrioritySystemImmediate() {}
  // setReadAheadDisable() {}
  // setReadSystemKeys() {}
  // setReadVersion(version) {}
  // setReadYourWritesDisable() {}
  // setRetryLimit() {}
  // setSizeLimit() {}
  // setSnapshotRywDisable() {}
  // setSnapshotRywEnable() {}
  // setTimeout() {}
  // setTransactionLoggingMaxFieldLength(sizeLimit) {}
  // setVersionstampedKey(key, param) {}
  // setVersionstampedValue(key, param) {}
  // snapshotGet(key) {}
  // // snapshot[](key)  {}
  // snapshotGetKey(keySelector) {}
  // snapshotGetRange(begin, end, options) {}
  // snapshotGetRangeStartWith(prefix, options) {}
  // snapshotGetReadVersion() {}
  // transact() {}
  // watch(key) {}
}
