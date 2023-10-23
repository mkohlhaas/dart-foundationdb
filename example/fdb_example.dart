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
    final beg = 'h'.firstGreaterOrEqual;
    final end = 'i'.lastLessOrEqual;
    for (final (key, value) in tr.getRange(beg, end)) {
      print('$key: $value');
    }
    tr.commit();

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
