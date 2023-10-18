import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';

import 'package:foundationdb/foundationdb.dart';

class FDB {
  static int? _selectedApiVersion;

  static int? selectedApiVersion() {
    return _selectedApiVersion;
  }

  static int maxApiVersion() {
    return fdbc.fdb_get_max_api_version();
  }

  static bool isApiVersionSelected() {
    return _selectedApiVersion != null;
  }

  // if clusterFile is the empty string then the default cluster file will be used
  static Database openDatabase([String clusterFile = '']) {
    final clusterFileC = clusterFile.toNativeUtf8();
    final ppDatabase = calloc<Pointer<FDB_database>>();
    try {
      handleError(fdbc.fdb_create_database(
        clusterFileC.cast(),
        ppDatabase,
      ));
      return Database(ppDatabase.value);
    } catch (_) {
      rethrow;
    } finally {
      calloc.free(clusterFileC);
      calloc.free(ppDatabase);
    }
  }

  static Database openDatabaseConfig(String connectionString) {
    final connectionStringC = connectionString.toNativeUtf8();
    final ppDatabase = calloc<Pointer<FDB_database>>();
    try {
      handleError(fdbc.fdb_create_database_from_connection_string(
        connectionStringC.cast(),
        ppDatabase,
      ));
      return Database(ppDatabase.value);
    } catch (_) {
      rethrow;
    } finally {
      calloc.free(connectionStringC);
      calloc.free(ppDatabase);
    }
  }

  static void selectApiVersion(int version) {
    try {
      handleError(fdbc.fdb_select_api_version_impl(version, version));
      _selectedApiVersion = version;
    } catch (_) {
      rethrow;
    }
  }

  static void selectMaxApiVersion() {
    selectApiVersion(maxApiVersion());
  }
}
