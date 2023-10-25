import 'package:foundationdb/foundationdb.dart';

main() async {
  try {
    selectMaxApiVersion();
    setBuggifyDisable();
    await startNetwork();
    withDatabase((Database db) {
      db.withTransaction((Transaction txn) {
        txn['hello'] = 'world';
        txn['hallo'] = 'world';
        txn['my1'] = 'world1';
        txn['my2'] = 'world2';
        txn['my3'] = 'world3';
        txn['my4'] = 'world4';
        // final beg = 'hallo'.firstGreaterOrEqual;
        // final end = 'hello'.lastLessOrEqual;
        final beg = 'h'.firstGreaterOrEqual;
        final end = 'i'.lastLessOrEqual;
        for (final (key, value) in txn.getRange(beg, end)) {
          print('$key: $value');
        }
      });
    });
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
