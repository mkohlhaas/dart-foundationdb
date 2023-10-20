import '../foundationdb.dart';

int? _selectedApiVersion;

bool isApiVersionSelected() {
  return _selectedApiVersion != null;
}

int maxApiVersion() {
  return fdbc.fdb_get_max_api_version();
}

void selectApiVersion(int version) {
  handleError(fdbc.fdb_select_api_version_impl(version, version));
  _selectedApiVersion = version;
}

int? selectedApiVersion() {
  return _selectedApiVersion;
}

int? selectMaxApiVersion() {
  selectApiVersion(maxApiVersion());
  return selectedApiVersion();
}
