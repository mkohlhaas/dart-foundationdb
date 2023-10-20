import '../foundationdb.dart';

class Transaction {
  Database? database;
  Database? snapshotDatabase;

  operator [](key) {}
  operator []=(key, value) {}
  add(key, param) {}
  addReadConflictKey(key) {}
  addReadConflictRange(begin, end) {}
  addWriteConflictKey(key) {}
  addWriteConflictRange(begin, end) {}
  bitAnd(key, param) {}
  bitOr(key, param) {}
  bitXor(key, param) {}
  byteMax(key, param) {}
  byteMin(key, param) {}
  cancel() {}
  clear(key) {}
  clearRange(begin, end) {}
  clearRangeStartWith(prefix) {}
  commit() {}
  compareAndClear(key, param) {}
  get(key) {}
  getApproximateSize() {}
  getCommittedVersion() {}
  getEstimatedRangeSizeBytes(beginKey, endKey) {}
  getKey(keySelector) {}
  getRange(begin, end, options) {}
  getRangeSplitPoints(beginKey, endKey, chunkSize) {}
  getRangeStartWith(prefix, options) {}
  getReadVersion() {}
  getVersionstamp() {}
  max(key, param) {}
  min(key, param) {}
  onError(exception) {}
  reset() {}
  set(key, value) {}
  setAccessSystemKeys() {}
  setCausalReadRisky() {}
  setCausalWriteRisky() {}
  setDebugTransactionIdentifier(idString) {}
  setLogTransaction() {}
  setMaxRetryDelay() {}
  setNextWriteNoWriteConflictRange() {}
  setPriorityBatch() {}
  setPrioritySystemImmediate() {}
  setReadAheadDisable() {}
  setReadSystemKeys() {}
  setReadVersion(version) {}
  setReadYourWritesDisable() {}
  setRetryLimit() {}
  setSizeLimit() {}
  setSnapshotRywDisable() {}
  setSnapshotRywEnable() {}
  setTimeout() {}
  setTransactionLoggingMaxFieldLength(sizeLimit) {}
  setVersionstampedKey(key, param) {}
  setVersionstampedValue(key, param) {}
  snapshotGet(key) {}
  // snapshot[](key)  {}
  snapshotGetKey(keySelector) {}
  snapshotGetRange(begin, end, options) {}
  snapshotGetRangeStartWith(prefix, options) {}
  snapshotGetReadVersion() {}
  transact() {}
  watch(key) {}
}
