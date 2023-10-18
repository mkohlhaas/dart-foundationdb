import 'dart:io';

import 'package:foundationdb/foundationdb.dart';

main() async {
  try {
    // 1. Set API version
    FDB.selectMaxApiVersion();

    // 2. Set network options
    // Network.setXXX();
    // ...

    // 3. Start network
    await Network.startNetwork();

    // 4. Open one or several(!) Databases
    Database db = FDB.openDatabase();
    print(db);

    // 5. Do your database stuff
    // db['key'] = 'value';
    // ...
    print('waiting...');
    await Future.delayed(Duration(seconds: 5));

    // 6. Stop Network
    Network.stopNetwork();
  } on FDBException catch (err, s) {
    print('There was an error!');
    print(s);
    print(err);
    print(err.errorCode);
  }
}
