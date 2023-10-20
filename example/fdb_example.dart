import 'dart:io';

import 'package:foundationdb/foundationdb.dart';

main() async {
  try {
    // 1. Set API version
    print(selectMaxApiVersion());

    // 2. Set network options, e.g.
    // setBuggifySectionActivatedProbability();

    // 3. Start network and wait till it's started
    await startNetwork();

    // 4. Open one or several(!) Databases
    Database db = openDatabase();
    print(db);

    // 5. Do your database stuff
    // db['key'] = 'value';
    // ...
    print('doing some db stuff...');
    sleep(Duration(seconds: 1));

    // 6. Stop Network
    stopNetwork();
  } on FDBException catch (err, s) {
    print('There was an FDB error!');
    print(err);
    print(err.errorCode);
    print(s);
  } catch (e) {
    print(e);
  }
}
