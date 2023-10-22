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

    // 5. Do your database stuff
    print('doing some db stuff...');
    var tr = db.createTransaction();
    var key = 'hello';
    tr.set(key, 'from Dart 01');
    tr.commit();
    tr = db.createTransaction();
    print('$key ${tr.get(key, false)}');

    var key1 = 'hallo';
    tr = db.createTransaction();
    tr[key1] = 'from Dart';
    print('$key1 ${tr[key1]}');
    tr.commit();

    tr = db.createTransaction();
    print(tr['zĵasdâfuĵ']);
    KeySelector ks = 'ĵuiz'.firstGreaterThan;
    print(tr.getKey(ks));
    print(ks.key);

    // 6. Stop Network
  } on FDBException catch (err, s) {
    print('There was an FDB error!');
    print(err);
    print(err.errorCode);
    print(s);
  } catch (e, s) {
    print(e);
    print(s);
  } finally {
    stopNetwork();
  }
}
