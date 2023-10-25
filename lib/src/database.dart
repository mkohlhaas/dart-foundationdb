import 'dart:ffi';

import 'package:ffi/ffi.dart';

import '../foundationdb.dart';

// if clusterFile is the empty string then the default cluster file will be used
Database openDatabase([String clusterFile = '']) {
  return _open(clusterFile, fdbc.fdb_create_database);
}

Database openDatabaseConfig(String connectionString) {
  return _open(connectionString, fdbc.fdb_create_database_from_connection_string);
}

Database _open(String connect, DbCreateFun createDbFun) {
  final connectC = connect.toNativeUtf8().cast<Char>();
  final ppDatabase = calloc<Pointer<FDB_database>>();
  try {
    handleError(createDbFun(
      connectC,
      ppDatabase,
    ));
    return Database(ppDatabase.value);
  } finally {
    calloc.free(connectC);
    calloc.free(ppDatabase);
  }
}

typedef DbCreateFun = int Function(Pointer<Char>, Pointer<Pointer<FDB_database>>);

void withDatabase(void Function(Database db) f, [String clusterFile = '']) {
  final db = openDatabase(clusterFile);
  f(db);
  db.close();
}

class Database {
  final Pointer<FDB_database> _database;

  Database(this._database);

  void close() {
    fdbc.fdb_database_destroy(_database);
  }

  Transaction createTransaction() {
    final ppTransaction = calloc<Pointer<FDB_transaction>>();
    try {
      handleError(fdbc.fdb_database_create_transaction(_database, ppTransaction));
      return Transaction(ppTransaction.value);
    } finally {
      calloc.free(ppTransaction);
    }
  }

  // retries?
  void withTransaction(void Function(Transaction txn) f) {
    final txn = createTransaction();
    f(txn);
    txn.commit();
  }

  bool rebootWorker(String address, bool checkFile, int suspendDuration) {
    final addressC = address.toNativeUtf8();
    final isSent = calloc<Int64>();
    try {
      final f = fdbc.fdb_database_reboot_worker(
        _database,
        addressC.cast(),
        address.length,
        checkFile ? 1 : 0,
        suspendDuration,
      );
      handleError(fdbc.fdb_future_block_until_ready(f));
      handleError(fdbc.fdb_future_get_int64(f, isSent));
      int res = isSent.value;
      fdbc.fdb_future_destroy(f);
      return res == 0 ? false : true;
    } finally {
      calloc.free(addressC);
      calloc.free(isSent);
    }
  }

  /// Specify the datacenter ID that was passed to fdbserver processes running in the same datacenter as this client, for better location-aware load balancing.
  setDatacenterId(String id) {
    _setStringOption(22, id);
  }

  /// Set the size of the client location cache. Raising this value can boost performance in very large databases where clients access data in a near-random pattern. Defaults to 100000.
  setLocationCacheSize(int cacheSize) {
    _setIntOption(10, cacheSize);
  }

  /// Specify the machine ID that was passed to fdbserver processes running on the same machine as this client, for better location-aware load balancing.
  setMachineId(String id) {
    _setStringOption(21, id);
  }

  /// Set the maximum number of watches allowed to be outstanding on a database connection.
  setMaxWatches(int outstandingWatches) {
    _setIntOption(20, outstandingWatches);
  }

  /// Snapshot read operations will not see the results of writes done in the same transaction.
  setSnapshotRywDisable() {
    _setOption(27);
  }

  /// Snapshot read operations will see the results of writes done in the same transaction.
  setSnapshotRywEnable() {
    _setOption(26);
  }

  /// Enables verification of causal read risky by checking whether clients are able to read stale data when they detect a recovery, and logging an error if so.
  setTestCausalReadRisky(int probability) {
    _setIntOption(900, probability);
  }

  /// Set a random idempotency id for all transactions.
  setTransactionAutomaticIdempotency() {
    _setOption(506);
  }

  /// Allows ``get`` operations to read from sections of keyspace that have become unreadable because of versionstamp operations.
  setTransactionBypassUnreadable() {
    _setOption(700);
  }

  /// The read version will be committed, and usually will be the latest committed, but might not be the latest committed in the event of a simultaneous fault and misbehaving clock.
  setTransactionCausalReadRisky() {
    _setOption(504);
  }

  /// Deprecated.
  setTransactionIncludePortInAddress() {
    _setOption(505);
  }

  /// Sets the maximum escaped length of key and value fields to be logged to the trace file via the LOG_TRANSACTION option.
  setTransactionLoggingMaxFieldLength(int maxLength) {
    _setIntOption(405, maxLength);
  }

  /// Set the maximum amount of backoff delay incurred in the call to ``onError`` if the error is retryable.
  setTransactionMaxRetryDelay(int maxDelay) {
    _setIntOption(502, maxDelay);
  }

  /// Enables conflicting key reporting on all transactions, allowing them to retrieve the keys that are conflicting with other transactions.
  setTransactionReportConflictingKeys() {
    _setOption(702);
  }

  /// Set a maximum number of retries after which additional calls to ``onError`` will throw the most recently seen error code.
  setTransactionRetryLimit(int numberOfRetries) {
    _setIntOption(501, numberOfRetries);
  }

  /// Set the maximum transaction size in bytes.
  setTransactionSizeLimit(int numberOfBytes) {
    _setIntOption(503, numberOfBytes);
  }

  /// Set a timeout in milliseconds which, when elapsed, will cause each transaction automatically to be cancelled.
  setTransactionTimeout(int timeout) {
    _setIntOption(500, timeout);
  }

  /// By default, operations that are performed on a transaction while it is being committed will not only fail themselves, but they will attempt to fail other in-flight operations (such as the commit) as well.
  setTransactionUsedDuringCommitProtectionDisable() {
    _setOption(701);
  }

  /// Use configuration database.
  setUseConfigDatabase() {
    _setOption(800);
  }

  void _setIntOption(int option, int value) {
    final valueC = calloc<Int64>().cast<Uint8>();
    try {
      handleError(fdbc.fdb_database_set_option(
        _database,
        option,
        valueC,
        sizeOf<Int64>(),
      ));
    } finally {
      calloc.free(valueC);
    }
  }

  void _setOption(int option) {
    handleError(fdbc.fdb_database_set_option(
      _database,
      option,
      nullptr,
      0,
    ));
  }

  void _setStringOption(int option, String value) {
    final valueC = value.toNativeUtf8();
    try {
      handleError(fdbc.fdb_database_set_option(
        _database,
        option,
        valueC.cast(),
        value.length,
      ));
    } finally {
      calloc.free(valueC);
    }
  }
}
