import 'dart:ffi';

import 'package:ffi/ffi.dart';

import '../foundationdb.dart';

class Transaction {
  final Pointer<FDB_transaction> _txn;

  Transaction(this._txn);

  String? operator [](String key) => get(key);

  void operator []=(String key, String value) => set(key, value);

  void add(String key, int value) {
    _atomic(key, value, FDBMutationType.FDB_MUTATION_TYPE_ADD);
  }

  void addReadConflictKey(String key) {
    _addConflictKey(key, FDBConflictRangeType.FDB_CONFLICT_RANGE_TYPE_READ);
  }

  void addReadConflictRange(String begin, String end) {
    _addConflictRange(begin, end, FDBConflictRangeType.FDB_CONFLICT_RANGE_TYPE_READ);
  }

  void addWriteConflictKey(String key) {
    _addConflictKey(key, FDBConflictRangeType.FDB_CONFLICT_RANGE_TYPE_WRITE);
  }

  void addWriteConflictRange(String begin, String end) {
    _addConflictRange(begin, end, FDBConflictRangeType.FDB_CONFLICT_RANGE_TYPE_WRITE);
  }

  void appendIfFits(String key, int value) {
    _atomic(key, value, FDBMutationType.FDB_MUTATION_TYPE_APPEND_IF_FITS);
  }

  void bitAnd(String key, int value) {
    _atomic(key, value, FDBMutationType.FDB_MUTATION_TYPE_AND);
  }

  void bitOr(String key, int value) {
    _atomic(key, value, FDBMutationType.FDB_MUTATION_TYPE_OR);
  }

  void bitXor(String key, int value) {
    _atomic(key, value, FDBMutationType.FDB_MUTATION_TYPE_XOR);
  }

  void byteMax(String key, int value) {
    _atomic(key, value, FDBMutationType.FDB_MUTATION_TYPE_BYTE_MAX);
  }

  void byteMin(String key, int value) {
    _atomic(key, value, FDBMutationType.FDB_MUTATION_TYPE_BYTE_MIN);
  }

  void cancel() {
    fdbc.fdb_transaction_cancel(_txn);
  }

  void clear(String key) {
    final keyC = key.toNativeUtf8();
    try {
      fdbc.fdb_transaction_clear(
        _txn,
        keyC.cast(),
        keyC.length,
      );
    } finally {
      calloc.free(keyC);
    }
  }

  void clearRange(String begin, [String? end]) {
    end ??= 0xFF.toRadixString(16);
    final keyBegin = begin.toNativeUtf8();
    final keyEnd = end.toNativeUtf8();
    try {
      fdbc.fdb_transaction_clear_range(
        _txn,
        keyBegin.cast(),
        keyBegin.length,
        keyEnd.cast(),
        keyEnd.length,
      );
    } finally {
      calloc.free(keyBegin);
      calloc.free(keyEnd);
    }
  }

  void clearRangeStartWith(String prefix) {
    clearRange(prefix);
  }

  void commit() {
    final f = fdbc.fdb_transaction_commit(_txn);
    handleError(fdbc.fdb_future_block_until_ready(f));
    fdbc.fdb_future_destroy(f);
  }

  void compareAndClear(String key, int value) {
    _atomic(key, value, FDBMutationType.FDB_MUTATION_TYPE_COMPARE_AND_CLEAR);
  }

  List<String> getRangeSplitPoints(String beginKey, String endKey, int chunkSize) {
    final res = <String>[];
    final keyBeg = beginKey.toNativeUtf8();
    final keyEnd = endKey.toNativeUtf8();
    final keyArray = calloc<Pointer<key>>();
    final count = calloc<Int>();
    try {
      final f = fdbc.fdb_transaction_get_range_split_points(
        _txn,
        keyBeg.cast(),
        keyBeg.length,
        keyEnd.cast(),
        keyEnd.length,
        chunkSize,
      );
      handleError(fdbc.fdb_future_block_until_ready(f));
      handleError(fdbc.fdb_future_get_key_array(f, keyArray, count));
      for (var i = 0; i < count.value; i++) {
        final pStr = keyArray.value.elementAt(i).ref.key1.cast<Utf8>();
        final keyLength = keyArray.value.elementAt(i).ref.key_length;
        res.add(pStr.toDartString(length: keyLength));
      }
      return res;
    } finally {
      calloc.free(keyBeg);
      calloc.free(keyEnd);
      calloc.free(keyArray);
      calloc.free(count);
    }
  }

  String? get(String key, [bool isSnapshot = false]) {
    String? res;
    final keyC = key.toNativeUtf8();
    final present = calloc<Int>();
    final value = calloc<Pointer<Uint8>>();
    final valueLength = calloc<Int>();
    try {
      final f = fdbc.fdb_transaction_get(
        _txn,
        keyC.cast(),
        keyC.length,
        isSnapshot ? 1 : 0,
      );
      handleError(fdbc.fdb_future_block_until_ready(f));
      handleError(fdbc.fdb_future_get_value(f, present, value, valueLength));
      if (present.value != 0) {
        res = value.value.cast<Utf8>().toDartString(length: valueLength.value);
      }
      fdbc.fdb_future_destroy(f);
      return res;
    } finally {
      calloc.free(keyC);
      calloc.free(present);
      calloc.free(value);
      calloc.free(valueLength);
    }
  }

  int getApproximateSize() {
    final size = calloc<Int64>();
    try {
      final f = fdbc.fdb_transaction_get_approximate_size(_txn);
      handleError(fdbc.fdb_future_block_until_ready(f));
      handleError(fdbc.fdb_future_get_int64(f, size));
      int res = size.value;
      fdbc.fdb_future_destroy(f);
      return res;
    } finally {
      calloc.free(size);
    }
  }

  int getCommittedVersion() {
    final version = calloc<Int64>();
    try {
      handleError(fdbc.fdb_transaction_get_committed_version(_txn, version));
      return version.value;
    } finally {
      calloc.free(version);
    }
  }

  int getEstimatedRangeSizeBytes(String begin, String end) {
    final size = calloc<Int64>();
    final keyBegin = begin.toNativeUtf8();
    final keyEnd = end.toNativeUtf8();
    try {
      final f = fdbc.fdb_transaction_get_estimated_range_size_bytes(
        _txn,
        keyBegin.cast(),
        keyBegin.length,
        keyEnd.cast(),
        keyEnd.length,
      );
      handleError(fdbc.fdb_future_block_until_ready(f));
      handleError(fdbc.fdb_future_get_int64(f, size));
      int res = size.value;
      fdbc.fdb_future_destroy(f);
      return res;
    } finally {
      calloc.free(keyBegin);
      calloc.free(keyEnd);
    }
  }

  String? getKey(KeySelector keySel, [bool isSnapshot = false]) {
    String? result;
    final keyC = keySel.key.toNativeUtf8();
    final key = calloc<Pointer<Uint8>>();
    final keyLength = calloc<Int>();
    try {
      final f = fdbc.fdb_transaction_get_key(
        _txn,
        keyC.cast(),
        keyC.length,
        keySel.orEqual,
        keySel.offset,
        isSnapshot ? 1 : 0,
      );
      handleError(fdbc.fdb_future_block_until_ready(f));
      handleError(fdbc.fdb_future_get_key(f, key, keyLength));
      print('length: ${keyLength.value}');
      print('char: ${key.value.value}');
      // system metadata
      if (key.value.value.isNotSystemKey) {
        result = key.value.cast<Utf8>().toDartString(length: keyLength.value);
      }
      fdbc.fdb_future_destroy(f);
      return result;
    } finally {
      calloc.free(keyC);
      calloc.free(key);
      calloc.free(keyLength);
    }
  }

  Iterable<(String, String)> getRange(
    KeySelector begin,
    KeySelector end, {
    int limit = 0,
    bool reverse = false,
    bool snapshot = false,
  }) {
    return TransactionIterable(_txn, begin, end, limit, reverse, snapshot);
  }

  int getReadVersion() {
    final version = calloc<Int64>();
    try {
      final f = fdbc.fdb_transaction_get_approximate_size(_txn);
      handleError(fdbc.fdb_future_block_until_ready(f));
      handleError(fdbc.fdb_future_get_int64(f, version));
      int res = version.value;
      fdbc.fdb_future_destroy(f);
      return res;
    } finally {
      calloc.free(version);
    }
  }

  String getVersionstamp() {
    final key = calloc<Pointer<Uint8>>();
    final keyLength = calloc<Int>();
    try {
      final f = fdbc.fdb_transaction_get_versionstamp(_txn);
      handleError(fdbc.fdb_future_block_until_ready(f));
      handleError(fdbc.fdb_future_get_key(f, key, keyLength));
      String res = key.value.cast<Utf8>().toDartString(length: keyLength.value);
      fdbc.fdb_future_destroy(f);
      return res;
    } finally {
      calloc.free(key);
      calloc.free(keyLength);
    }
  }

  void max(String key, int value) {
    _atomic(key, value, FDBMutationType.FDB_MUTATION_TYPE_MAX);
  }

  void min(String key, int value) {
    _atomic(key, value, FDBMutationType.FDB_MUTATION_TYPE_MIN);
  }

  void onError(int errorCode) {
    final f = fdbc.fdb_transaction_on_error(_txn, errorCode);
    handleError(fdbc.fdb_future_block_until_ready(f));
    fdbc.fdb_future_destroy(f);
  }

  void reset() {
    fdbc.fdb_transaction_reset(_txn);
  }

  void set(String key, String value) {
    final keyC = key.toNativeUtf8();
    final valueC = value.toNativeUtf8();
    try {
      fdbc.fdb_transaction_set(
        _txn,
        keyC.cast(),
        keyC.length,
        valueC.cast(),
        valueC.length,
      );
    } finally {}
    calloc.free(keyC);
    calloc.free(valueC);
  }

  /// Allows this transaction to read and modify system keys (those that start with the byte 0xFF). Implies raw_access. */
  /// /* Parameter: Option takes no parameter
  void setAccessSystemKeys() {
    _setOption(301);
  }

  /// Attach given authorization token to the transaction such that subsequent tenant-aware requests are authorized */
  /// /* Parameter: (String) A JSON Web Token authorized to access data belonging to one or more tenants, indicated by 'tenants' claim of the token's payload.
  void setAuthorizationToken(String webToken) {
    _setStringOption(2000, webToken);
  }

  /// Automatically assign a random 16 byte idempotency id for this transaction. Prevents commits from failing with ``commit_unknown_result``. WARNING: If you are also using the multiversion client or transaction timeouts, if either cluster_version_changed or transaction_timed_out was thrown during a commit, then that commit may have already succeeded or may succeed in the future. This feature is in development and not ready for general use. */
  /// /* Parameter: Option takes no parameter
  void setAutomaticIdempotency() {
    _setOption(505);
  }

  /// Adds a tag to the transaction that can be used to apply manual or automatic targeted throttling. At most 5 tags can be set on a transaction. */
  /// /* Parameter: (String) String identifier used to associated this transaction with a throttling group. Must not exceed 16 characters.
  void setAutoThrottleTag(String id) {
    _setStringOption(801, id);
  }

  /// Allows this transaction to bypass storage quota enforcement. Should only be used for transactions that directly or indirectly decrease the size of the tenant group's data. */
  /// /* Parameter: Option takes no parameter
  void setBypassStorageQuota() {
    _setOption(304);
  }

  /// Allows ``get`` operations to read from sections of keyspace that have become unreadable because of versionstamp operations. These reads will view versionstamp operations as if they were set operations that did not fill in the versionstamp. */
  /// /* Parameter: Option takes no parameter
  void setBypassUnreadable() {
    _setOption(1100);
  }

  /// /
  /// /* Parameter: Option takes no parameter
  void setCausalReadDisable() {
    _setOption(21);
  }

  /// The read version will be committed, and usually will be the latest committed, but might not be the latest committed in the event of a simultaneous fault and misbehaving clock. */
  /// /* Parameter: Option takes no parameter
  void setCausalReadRisky() {
    _setOption(20);
  }

  /// The transaction, if not self-conflicting, may be committed a second time after commit succeeds, in the event of a fault */
  /// /* Parameter: Option takes no parameter
  void setCausalWriteRisky() {
    _setOption(10);
  }

  /// /
  /// /* Parameter: Option takes no parameter This is a hidden parameter and should not be used directly by applications.
  void setCheckWritesEnable() {
    _setOption(50);
  }

  /// Committing this transaction will bypass the normal load balancing across commit proxies and go directly to the specifically nominated 'first commit proxy'. */
  /// /* Parameter: Option takes no parameter This is a hidden parameter and should not be used directly by applications.
  void setCommitOnFirstProxy() {
    _setOption(40);
  }

  /// /
  /// /* Parameter: Option takes no parameter This is a hidden parameter and should not be used directly by applications.
  void setDebugDump() {
    _setOption(400);
  }

  /// /
  /// /* Parameter: (String) Optional transaction name
  void setDebugRetryLogging(String txnName) {
    _setStringOption(401, txnName);
  }

  /// Sets a client provided identifier for the transaction that will be used in scenarios like tracing or profiling. Client trace logging or transaction profiling must be separately enabled. */
  /// /* Parameter: (String) String identifier to be used when tracing or profiling this transaction. The identifier must not exceed 100 characters.
  void setDebugTransactionIdentifier(String id) {
    _setStringOption(403, id);
  }

  /// /
  /// /* Parameter: Option takes no parameter
  void setDurabilityDatacenter() {
    _setOption(110);
  }

  /// Deprecated */
  /// /* Parameter: Option takes no parameter
  void setDurabilityDevNullIsWebScale() {
    _setOption(130);
  }

  /// /
  /// /* Parameter: Option takes no parameter
  void setDurabilityRisky() {
    _setOption(120);
  }

  /// Asks storage servers for how many bytes a clear key range contains. Otherwise uses the location cache to roughly estimate this. */
  /// /* Parameter: Option takes no parameter
  void setExpensiveClearCostEstimationEnable() {
    _setOption(1000);
  }

  /// No other transactions will be applied before this transaction within the same commit version. */
  /// /* Parameter: Option takes no parameter This is a hidden parameter and should not be used directly by applications.
  void setFirstInBatch() {
    _setOption(710);
  }

  /// Associate this transaction with this ID for the purpose of checking whether or not this transaction has already committed. Must be at least 16 bytes and less than 256 bytes. This feature is in development and not ready for general use. Unless the automatic_idempotency option is set after this option, the client will not automatically attempt to remove this id from the cluster after a successful commit. */
  /// /* Parameter: (String) Unique ID This is a hidden parameter and should not be used directly by applications.
  void setIdempotencyId(String id) {
    _setStringOption(504, id);
  }

  /// Addresses returned by get_addresses_for_key include the port when enabled. As of api version 630, this option is enabled by default and setting this has no effect. */
  /// /* Parameter: Option takes no parameter
  void setIncludePortInAddress() {
    _setOption(23);
  }

  /// This is a write-only transaction which sets the initial configuration. This option is designed for use by database system tools only. */
  /// /* Parameter: Option takes no parameter
  void setInitializeNewDatabase() {
    _setOption(300);
  }

  /// The transaction can read and write to locked databases, and is responsible for checking that it took the lock. */
  /// /* Parameter: Option takes no parameter
  void setLockAware() {
    _setOption(700);
  }

  /// Enables tracing for this transaction and logs results to the client trace logs. The DEBUG_TRANSACTION_IDENTIFIER option must be set before using this option, and client trace logging must be enabled to get log output. */
  /// /* Parameter: Option takes no parameter
  void setLogTransaction() {
    _setOption(404);
  }

  /// Set the maximum amount of backoff delay incurred in the call to ``onError`` if the error is retryable. Defaults to 1000 ms. Valid parameter values are ``[0, INT_MAX]``. If the maximum retry delay is less than the current retry delay of the transaction, then the current retry delay will be clamped to the maximum retry delay. Prior to API version 610, like all other transaction options, the maximum retry delay must be reset after a call to ``onError``. If the API version is 610 or greater, the retry limit is not reset after an ``onError`` call. Note that at all API versions, it is safe and legal to set the maximum retry delay each time the transaction begins, so most code written assuming the older behavior can be upgraded to the newer behavior without requiring any modification, and the caller is not required to implement special logic in retry loops to only conditionally set this option. */
  /// /* Parameter: (Int) value in milliseconds of maximum delay
  void setMaxRetryDelay(int maxDelay) {
    _setIntOption(502, maxDelay);
  }

  /// The next write performed on this transaction will not generate a write conflict range. As a result, other transactions which read the key(s) being modified by the next write will not conflict with this transaction. Care needs to be taken when using this option on a transaction that is shared between multiple threads. When setting this option, write conflict ranges will be disabled on the next write operation, regardless of what thread it is on. */
  /// /* Parameter: Option takes no parameter
  void setNextWriteNoWriteConflictRange() {
    _setOption(30);
  }

  /// Specifies that this transaction should be treated as low priority and that default priority transactions will be processed first. Batch priority transactions will also be throttled at load levels smaller than for other types of transactions and may be fully cut off in the event of machine failures. Useful for doing batch work simultaneously with latency-sensitive work */
  /// /* Parameter: Option takes no parameter
  void setPriorityBatch() {
    _setOption(201);
  }

  /// Specifies that this transaction should be treated as highest priority and that lower priority transactions should block behind this one. Use is discouraged outside of low-level tools */
  /// /* Parameter: Option takes no parameter
  void setPrioritySystemImmediate() {
    _setOption(200);
  }

  /// Allows this transaction to access the raw key-space when tenant mode is on. */
  /// /* Parameter: Option takes no parameter
  void setRawAccess() {
    _setOption(303);
  }

  /// Deprecated */
  /// /* Parameter: Option takes no parameter
  void setReadAheadDisable() {
    _setOption(52);
  }

  /// The transaction can read from locked databases. */
  /// /* Parameter: Option takes no parameter
  void setReadLockAware() {
    _setOption(702);
  }

  /// Use high read priority for subsequent read requests in this transaction. */
  /// /* Parameter: Option takes no parameter
  void setReadPriorityHigh() {
    _setOption(511);
  }

  /// Use low read priority for subsequent read requests in this transaction. */
  /// /* Parameter: Option takes no parameter
  void setReadPriorityLow() {
    _setOption(510);
  }

  /// Use normal read priority for subsequent read requests in this transaction.  This is the default read priority. */
  /// /* Parameter: Option takes no parameter
  void setReadPriorityNormal() {
    _setOption(509);
  }

  /// Storage server should not cache disk blocks needed for subsequent read requests in this transaction.  This can be used to avoid cache pollution for reads not expected to be repeated. */
  /// /* Parameter: Option takes no parameter
  void setReadServerSideCacheDisable() {
    _setOption(508);
  }

  /// Storage server should cache disk blocks needed for subsequent read requests in this transaction.  This is the default behavior. */
  /// /* Parameter: Option takes no parameter
  void setReadServerSideCacheEnable() {
    _setOption(507);
  }

  /// Allows this transaction to read system keys (those that start with the byte 0xFF). Implies raw_access. */
  /// /* Parameter: Option takes no parameter
  void setReadSystemKeys() {
    _setOption(302);
  }

  void setReadVersion(int version) {
    fdbc.fdb_transaction_set_read_version(_txn, version);
  }

  /// Reads performed by a transaction will not see any prior mutations that occured in that transaction, instead seeing the value which was in the database at the transaction's read version. This option may provide a small performance benefit for the client, but also disables a number of client-side optimizations which are beneficial for transactions which tend to read and write the same keys within a single transaction. It is an error to set this option after performing any reads or writes on the transaction. */
  /// /* Parameter: Option takes no parameter
  void setReadYourWritesDisable() {
    _setOption(51);
  }

  /// The transaction can retrieve keys that are conflicting with other transactions. */
  /// /* Parameter: Option takes no parameter
  void setReportConflictingKeys() {
    _setOption(712);
  }

  /// Set a maximum number of retries after which additional calls to ``onError`` will throw the most recently seen error code. Valid parameter values are ``[-1, INT_MAX]``. If set to -1, will disable the retry limit. Prior to API version 610, like all other transaction options, the retry limit must be reset after a call to ``onError``. If the API version is 610 or greater, the retry limit is not reset after an ``onError`` call. Note that at all API versions, it is safe and legal to set the retry limit each time the transaction begins, so most code written assuming the older behavior can be upgraded to the newer behavior without requiring any modification, and the caller is not required to implement special logic in retry loops to only conditionally set this option. */
  /// /* Parameter: (Int) number of times to retry
  void setRetryLimit(int numberOfRetries) {
    _setIntOption(501, numberOfRetries);
  }

  /// Sets an identifier for server tracing of this transaction. When committed, this identifier triggers logging when each part of the transaction authority encounters it, which is helpful in diagnosing slowness in misbehaving clusters. The identifier is randomly generated. When there is also a debug_transaction_identifier, both IDs are logged together. */
  /// /* Parameter: Option takes no parameter
  void setServerRequestTracing() {
    _setOption(406);
  }

  /// Set the transaction size limit in bytes. The size is calculated by combining the sizes of all keys and values written or mutated, all key ranges cleared, and all read and write conflict ranges. (In other words, it includes the total size of all data included in the request to the cluster to commit the transaction.) Large transactions can cause performance problems on FoundationDB clusters, so setting this limit to a smaller value than the default can help prevent the client from accidentally degrading the cluster's performance. This value must be at least 32 and cannot be set to higher than 10,000,000, the default transaction size limit. */
  /// /* Parameter: (Int) value in bytes
  void setSizeLimit(int size) {
    _setIntOption(503, size);
  }

  /// Specifically instruct this transaction to NOT use cached GRV. Primarily used for the read version cache's background updater to avoid attempting to read a cached entry in specific situations. */
  /// /* Parameter: Option takes no parameter This is a hidden parameter and should not be used directly by applications.
  void setSkipGrvCache() {
    _setOption(1102);
  }

  /// Snapshot read operations will not see the results of writes done in the same transaction. This was the default behavior prior to API version 300. */
  /// /* Parameter: Option takes no parameter
  void setSnapshotRywDisable() {
    _setOption(601);
  }

  /// Snapshot read operations will see the results of writes done in the same transaction. This is the default behavior. */
  /// /* Parameter: Option takes no parameter
  void setSnapshotRywEnable() {
    _setOption(600);
  }

  /// Adds a parent to the Span of this transaction. Used for transaction tracing. A span can be identified with any 16 bytes */
  /// /* Parameter: (Bytes) A byte string of length 16 used to associate the span of this transaction with a parent
  void setSpanParent(String option) {
    _setStringOption(900, option);
  }

  /// By default, users are not allowed to write to special keys. Enable this option will implicitly enable all options required to achieve the configuration change. */
  /// /* Parameter: Option takes no parameter
  void setSpecialKeySpaceEnableWrites() {
    _setOption(714);
  }

  /// By default, the special key space will only allow users to read from exactly one module (a subspace in the special key space). Use this option to allow reading from zero or more modules. Users who set this option should be prepared for new modules, which may have different behaviors than the modules they're currently reading. For example, a new module might block or return an error. */
  /// /* Parameter: Option takes no parameter
  void setSpecialKeySpaceRelaxed() {
    _setOption(713);
  }

  /// Adds a tag to the transaction that can be used to apply manual targeted throttling. At most 5 tags can be set on a transaction. */
  /// /* Parameter: (String) String identifier used to associated this transaction with a throttling group. Must not exceed 16 characters.
  void setTag(String id) {
    _setStringOption(800, id);
  }

  /// Set a timeout in milliseconds which, when elapsed, will cause the transaction automatically to be cancelled. Valid parameter values are ``[0, INT_MAX]``. If set to 0, will disable all timeouts. All pending and any future uses of the transaction will throw an exception. The transaction can be used again after it is reset. Prior to API version 610, like all other transaction options, the timeout must be reset after a call to ``onError``. If the API version is 610 or greater, the timeout is not reset after an ``onError`` call. This allows the user to specify a longer timeout on specific transactions than the default timeout specified through the ``transaction_timeout`` database option without the shorter database timeout cancelling transactions that encounter a retryable error. Note that at all API versions, it is safe and legal to set the timeout each time the transaction begins, so most code written assuming the older behavior can be upgraded to the newer behavior without requiring any modification, and the caller is not required to implement special logic in retry loops to only conditionally set this option. */
  /// /* Parameter: (Int) value in milliseconds of timeout
  void setTimeout(int timeout) {
    _setIntOption(500, timeout);
  }

  /// Deprecated */
  /// /* Parameter: (String) String identifier to be used in the logs when tracing this transaction. The identifier must not exceed 100 characters.
  void setTransactionLoggingEnable(String id) {
    _setStringOption(402, id);
  }

  /// Sets the maximum escaped length of key and value fields to be logged to the trace file via the LOG_TRANSACTION option, after which the field will be truncated. A negative value disables truncation. */
  /// /* Parameter: (Int) Maximum length of escaped key and value fields.
  void setTransactionLoggingMaxFieldLength(int maxLength) {
    _setIntOption(405, maxLength);
  }

  /// By default, operations that are performed on a transaction while it is being committed will not only fail themselves, but they will attempt to fail other in-flight operations (such as the commit) as well. This behavior is intended to help developers discover situations where operations could be unintentionally executed after the transaction has been reset. Setting this option removes that protection, causing only the offending operation to fail. */
  /// /* Parameter: Option takes no parameter
  void setUsedDuringCommitProtectionDisable() {
    _setOption(701);
  }

  /// Allows this transaction to use cached GRV from the database context. Defaults to off. Upon first usage, starts a background updater to periodically update the cache to avoid stale read versions. The disable_client_bypass option must also be set. */
  /// /* Parameter: Option takes no parameter
  void setUseGrvCache() {
    _setOption(1101);
  }

  /// This option should only be used by tools which change the database configuration. */
  /// /* Parameter: Option takes no parameter
  void setUseProvisionalProxies() {
    _setOption(711);
  }

  void setVersionstampedKey(String key, int value) {
    _atomic(key, value, FDBMutationType.FDB_MUTATION_TYPE_SET_VERSIONSTAMPED_KEY);
  }

  void setVersionstampedValue(String key, int value) {
    _atomic(key, value, FDBMutationType.FDB_MUTATION_TYPE_SET_VERSIONSTAMPED_VALUE);
  }

  void watch(String key) {
    final keyC = key.toNativeUtf8();
    try {
      final f = fdbc.fdb_transaction_watch(
        _txn,
        keyC.cast(),
        keyC.length,
      );
      handleError(fdbc.fdb_future_block_until_ready(f));
      fdbc.fdb_future_destroy(f);
    } finally {
      calloc.free(keyC);
    }
  }

  void _addConflictKey(String key, int type) {
    _addConflictRange(key, key + 0.toRadixString(16), type);
  }

  void _addConflictRange(String begin, String end, int type) {
    final keyBegin = begin.toNativeUtf8();
    final keyEnd = end.toNativeUtf8();
    try {
      handleError(fdbc.fdb_transaction_add_conflict_range(
        _txn,
        keyBegin.cast(),
        keyBegin.length,
        keyEnd.cast(),
        keyEnd.length,
        type,
      ));
    } finally {
      calloc.free(keyBegin);
      calloc.free(keyEnd);
    }
  }

  void _atomic(String key, int value, int op) {
    final keyC = key.toNativeUtf8();
    final packedValue = pack(value);
    try {
      fdbc.fdb_transaction_atomic_op(
        _txn,
        keyC.cast(),
        keyC.length,
        packedValue,
        sizeOf<Uint64>(),
        op,
      );
    } finally {
      calloc.free(keyC);
      calloc.free(packedValue);
    }
  }

  void _setIntOption(int option, int value) {
    final valueC = calloc<Int64>().cast<Uint8>();
    try {
      handleError(fdbc.fdb_transaction_set_option(
        _txn,
        option,
        valueC,
        sizeOf<Int64>(),
      ));
    } finally {
      calloc.free(valueC);
    }
  }

  void _setOption(int option) {
    handleError(fdbc.fdb_transaction_set_option(
      _txn,
      option,
      nullptr,
      0,
    ));
  }

  void _setStringOption(int option, String value) {
    final valueC = value.toNativeUtf8();
    try {
      handleError(fdbc.fdb_transaction_set_option(
        _txn,
        option,
        valueC.cast(),
        value.length,
      ));
    } finally {
      calloc.free(valueC);
    }
  }
}

class TransactionIterable extends Iterable<(String, String)> {
  final Pointer<FDB_transaction> _txn;
  final KeySelector _begin;
  final KeySelector _end;
  final int _limit;
  final bool _reverse;
  final bool _snapshot;

  TransactionIterable(this._txn, this._begin, this._end, this._limit, this._reverse, this._snapshot);

  @override
  Iterator<(String, String)> get iterator => TransactionIterator(_txn, _begin, _end, _limit, _reverse, _snapshot);
}

class TransactionIterator implements Iterator<(String, String)> {
  final Pointer<FDB_transaction> _txn;
  KeySelector _begin;
  KeySelector _end;
  final _kvPairs = <(String, String)>[];
  bool _more = true;
  int _iteration = 1;
  final int _limit;
  final bool _reverse;
  final bool _snapshot;

  TransactionIterator(this._txn, this._begin, this._end, this._limit, this._reverse, this._snapshot);

  @override
  (String, String) get current => _kvPairs.removeAt(0);

  (bool, List<(String, String)>) _getRange(
    bool snapshot,
    bool reverse,
  ) {
    final begKey = _begin.key.toNativeUtf8();
    final endKey = _end.key.toNativeUtf8();
    final kv = calloc<Pointer<keyvalue>>();
    final count = calloc<Int>();
    final more = calloc<Int>();
    try {
      final f = fdbc.fdb_transaction_get_range(
        _txn,
        begKey.cast(),
        begKey.length,
        _begin.orEqual,
        _begin.offset,
        endKey.cast(),
        endKey.length,
        _end.orEqual,
        _end.offset,
        _limit, // limit
        0, // target_bytes
        FDBStreamingMode.FDB_STREAMING_MODE_ITERATOR,
        _iteration++,
        _snapshot ? 1 : 0,
        _reverse ? 1 : 0,
      );
      handleError(fdbc.fdb_future_block_until_ready(f));
      handleError(fdbc.fdb_future_get_keyvalue_array(f, kv, count, more));
      var lst = <(String, String)>[];
      for (var i = 0; i < count.value; i++) {
        if (kv.value.ref.key.value.isNotSystemKey) {
          final ref = kv.value.elementAt(i).ref;
          String key = ref.key.cast<Utf8>().toDartString(length: ref.key_length);
          String value = ref.value.cast<Utf8>().toDartString(length: ref.value_length);
          if (_reverse) {
            _end = key.lastLessOrEqual;
          } else {
            _begin = key.firstGreaterThan;
          }
          lst.add((key, value));
        }
      }
      fdbc.fdb_future_destroy(f);
      return (more.value == 0 ? false : true, lst);
    } finally {
      calloc.free(begKey);
      calloc.free(endKey);
      calloc.free(kv);
      calloc.free(count);
      calloc.free(more);
    }
  }

  @override
  bool moveNext() {
    if (_kvPairs.isEmpty && _more) {
      final (more, pairs) = _getRange(false, false);
      _kvPairs.addAll(pairs);
      _more = more;
    }
    return _kvPairs.isNotEmpty;
  }
}
