import 'package:foundationdb/foundationdb.dart';

main() {
  try {
    print(FDB.isApiVersionSelected());
    FDB.selectMaxApiVersion();
    print(FDB.isApiVersionSelected());
    Network.setTraceInitializeOnSetup();
    // var db = FDB.openDatabase();
    var db = FDB.openDatabaseConfig('sfa:qwrqer@127.0.0.1:4000');
    print(db);
    // FDB.openDatabase('');
    print(FDB.getMaxApiVersion());
    // FDB.selectApiVersion(234);
    print(FDB.selectedApiVersion());
    print(FDB.isApiVersionSelected());
  } on FDBException catch (err) {
    print('There was an error!');
    print(err);
    print(err.errorCode);
    // print(FDB.isApiVersionSelected());
    // print(isErrorRetryable(err.errorCode));
    // print(isErrorMaybeCommitted(err.errorCode));
    // print(isErrorRetryableNotCommitted(err.errorCode));
    // // if (err.errorCode == 2201) {
    //   print("I don't care!");
    // }
  }
}
