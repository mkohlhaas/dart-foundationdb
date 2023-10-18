import 'package:foundationdb/foundationdb.dart';
import 'dart:ffi';
import 'package:ffi/ffi.dart';

class Database {
  late Pointer<FDB_database> _database;

  Database(this._database);

  operator [](key) {}
  operator []=(key, value) {}
  add(key, param) {}
  bitAnd(key, param) {}
  bitOr(key, param) {}
  bitXor(key, param) {}
  clear(key) {}
  clearAndWatch(key) {}
  clearRange(begin, end) {}
  clearRangeStartWith(prefix) {}
  close() {}
  createTransaction() {}
  doReadTransaction() {}
  doTransaction() {}
  doTxn() {}
  get(key) {}
  getAndWatch(key) {}
  getKey(keyselector) {}
  getRange(begin, end, options) {}
  getRangeStartWith(prefix, options) {}
  keyEncoding() {}
  openTenant() {}
  rebootWorker() {}
  set(key, value) {}
  setAndWatch(key, value) {}

  /// Specify the datacenter ID that was passed to fdbserver processes running in the same datacenter as this client, for better location-aware load balancing. */
  /// /* Parameter: (String) Hexadecimal ID
  // 22
  setDatacenterId() {}

  /// Set the size of the client location cache. Raising this value can boost performance in very large databases where clients access data in a near-random pattern. Defaults to 100000. */
  /// /* Parameter: (Int) Max location cache entries
  // 10
  setLocationCacheSize() {}

  /// Specify the machine ID that was passed to fdbserver processes running on the same machine as this client, for better location-aware load balancing. */
  /// /* Parameter: (String) Hexadecimal ID
  // 21
  setMachineId() {}

  /// Set the maximum number of watches allowed to be outstanding on a database connection. Increasing this number could result in increased resource usage. Reducing this number will not cancel any outstanding watches. Defaults to 10000 and cannot be larger than 1000000. */
  /// /* Parameter: (Int) Max outstanding watches
  // 20
  setMaxWatches() {}

  /// Snapshot read operations will not see the results of writes done in the same transaction. This was the default behavior prior to API version 300. */
  /// /* Parameter: Option takes no parameter
  // 27
  setSnapshotRywDisable() {}

  /// Snapshot read operations will see the results of writes done in the same transaction. This is the default behavior. */
  /// /* Parameter: Option takes no parameter
  // 26
  setSnapshotRywEnable() {}

  /// Enables verification of causal read risky by checking whether clients are able to read stale data when they detect a recovery, and logging an error if so. */
  /// /* Parameter: (Int) integer between 0 and 100 expressing the probability a client will verify it can't read stale data
  // 900
  setTestCausalReadRisky() {}

  /// Set a random idempotency id for all transactions. See the transaction option description for more information. This feature is in development and not ready for general use. */
  /// /* Parameter: Option takes no parameter
  // 506
  setTransactionAutomaticIdempotency() {}

  /// Allows ``get`` operations to read from sections of keyspace that have become unreadable because of versionstamp operations. This sets the ``bypass_unreadable`` option of each transaction created by this database. See the transaction option description for more information. */
  /// /* Parameter: Option takes no parameter
  // 700
  setTransactionBypassUnreadable() {}

  /// The read version will be committed, and usually will be the latest committed, but might not be the latest committed in the event of a simultaneous fault and misbehaving clock. */
  /// /* Parameter: Option takes no parameter
  // 504
  setTransactionCausalReadRisky() {}

  /// Deprecated. Addresses returned by get_addresses_for_key include the port when enabled. As of api version 630, this option is enabled by default and setting this has no effect. */
  /// /* Parameter: Option takes no parameter
  // 505
  setTransactionIncludePortInAddress() {}

  /// Sets the maximum escaped length of key and value fields to be logged to the trace file via the LOG_TRANSACTION option. This sets the ``transaction_logging_max_field_length`` option of each transaction created by this database. See the transaction option description for more information. */
  /// /* Parameter: (Int) Maximum length of escaped key and value fields.
  // 405
  setTransactionLoggingMaxFieldLength() {}

  /// Set the maximum amount of backoff delay incurred in the call to ``onError`` if the error is retryable. This sets the ``max_retry_delay`` option of each transaction created by this database. See the transaction option description for more information. */
  /// /* Parameter: (Int) value in milliseconds of maximum delay
  // 502
  setTransactionMaxRetryDelay() {}

  /// Enables conflicting key reporting on all transactions, allowing them to retrieve the keys that are conflicting with other transactions. */
  /// /* Parameter: Option takes no parameter
  // 702
  setTransactionReportConflictingKeys() {}

  /// Set a maximum number of retries after which additional calls to ``onError`` will throw the most recently seen error code. This sets the ``retry_limit`` option of each transaction created by this database. See the transaction option description for more information. */
  /// /* Parameter: (Int) number of times to retry
  // 501
  setTransactionRetryLimit() {}

  /// Set the maximum transaction size in bytes. This sets the ``size_limit`` option on each transaction created by this database. See the transaction option description for more information. */
  /// /* Parameter: (Int) value in bytes
  // 503
  setTransactionSizeLimit() {}

  /// Set a timeout in milliseconds which, when elapsed, will cause each transaction automatically to be cancelled. This sets the ``timeout`` option of each transaction created by this database. See the transaction option description for more information. Using this option requires that the API version is 610 or higher. */
  /// /* Parameter: (Int) value in milliseconds of timeout
  // 500
  setTransactionTimeout() {}

  /// By default, operations that are performed on a transaction while it is being committed will not only fail themselves, but they will attempt to fail other in-flight operations (such as the commit) as well. This behavior is intended to help developers discover situations where operations could be unintentionally executed after the transaction has been reset. Setting this option removes that protection, causing only the offending operation to fail. */
  /// /* Parameter: Option takes no parameter
  // 701
  setTransactionUsedDuringCommitProtectionDisable() {}

  /// Use configuration database. */
  /// /* Parameter: Option takes no parameter
  // 800
  setUseConfigDatabase() {}

  transact() {}

  valueEncoding() {}
}
