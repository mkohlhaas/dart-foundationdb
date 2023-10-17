import 'package:foundationdb/foundationdb.dart';

class FDB {
  static int? _selectedApiVersion;

  static int? selectedApiVersion() {
    return _selectedApiVersion;
  }

  static int getMaxApiVersion() {
    return fdbc.fdb_get_max_api_version();
  }

  static bool isApiVersionSelected() {
    return _selectedApiVersion != null;
  }

  static openDatabase() {}
  static openDatabaseConfig() {}
  static openDatabaseDefault() {}

  static void selectApiVersion(int version) {
    try {
      handleError(fdbc.fdb_select_api_version_impl(version, version));
      _selectedApiVersion = version;
    } catch (_) {
      rethrow;
    }
  }

  static void selectMaxApiVersion() {
    selectApiVersion(getMaxApiVersion());
  }
}
