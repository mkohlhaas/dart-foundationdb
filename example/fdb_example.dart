import 'package:foundationdb/foundationdb.dart' as fdb;

main() async {
  try {
    // 1. Set API version
    fdb.FDB.selectMaxApiVersion();

    // 2. Set network options
    // Network.setXXX();
    // ...

    // 3. Start network
    await fdb.Network.startNetwork();

    // 4. Open one or several(!) Databases
    fdb.Database db = fdb.FDB.openDatabase();
    print(db);

    // 5. Do your database stuff
    // db['key'] = 'value';
    // ...
    print('waiting...');
    await Future.delayed(Duration(seconds: 5));

    // 6. Stop Network
    fdb.Network.stopNetwork();
  } on fdb.FDBException catch (err, s) {
    print('There was an error!');
    print(s);
    print(err);
    print(err.errorCode);
  }
}
