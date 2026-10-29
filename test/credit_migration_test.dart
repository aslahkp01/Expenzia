import 'package:expenzia/data/credit_database.dart';
import 'package:expenzia/data/profile_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'support/credit_examples.dart';
import 'support/test_database.dart';

void main() {
  test(
    'schema v1 upgrades without losing expenses or profile settings',
    () async {
      final fixture = await TestDatabase.create();
      try {
        final legacy = await databaseFactoryFfi.openDatabase(
          fixture.database.databasePath!,
          options: OpenDatabaseOptions(
            version: 1,
            onCreate: (db, version) async {
              await db.execute('''CREATE TABLE expenses (
              id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL,
              amount_paise INTEGER NOT NULL, category TEXT NOT NULL,
              date TEXT NOT NULL, description TEXT NOT NULL DEFAULT '')''');
              await db.execute('''CREATE TABLE settings (
              key TEXT PRIMARY KEY, value TEXT NOT NULL)''');
            },
          ),
        );
        await legacy.insert('expenses', exampleExpense().toMap());
        await legacy.insert('settings', {
          'key': 'profile_name',
          'value': 'Aslah',
        });
        await legacy.close();
        expect((await fixture.database.all()).single.amountPaise, 12345);
        expect(await ProfileDatabase(fixture.database).loadName(), 'Aslah');
        final credits = CreditDatabase(fixture.database);
        expect(await credits.all(), isEmpty);
        expect((await credits.save(exampleCredit())).length, 1);
        expect(await (await fixture.database.connection).getVersion(), 2);
      } finally {
        await fixture.dispose();
      }
    },
  );
}
