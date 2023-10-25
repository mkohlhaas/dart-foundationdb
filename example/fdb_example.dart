import 'package:foundationdb/foundationdb.dart';

main() async {
  try {
    selectMaxApiVersion();
    setBuggifyDisable();
    await startNetwork();
    withDatabase((Database db) {
      db.withTransaction((Transaction txn) {
        for (var i = 0; i <= 500; i++) {
          // txn.clear('hello${i.toString().padLeft(3, '0')}');
          txn['hello${i.toString().padLeft(3, '0')}'] = 'world${i.toString().padLeft(3, '0')}';
        }
        final beg = 'hello'.first;
        final end = 'my1'.last;
        for (final (key, value) in txn.getRange(beg, end)) {
          print('$key: $value');
        }
        print('');
        for (final (key, value) in txn.getRange(beg, end, limit: 20, reverse: true, snapshot: true)) {
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
