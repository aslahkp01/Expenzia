import 'package:expenzia/data/expense_database.dart';
import 'package:expenzia/data/profile_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'support/test_database.dart';

void main() {
  late TestDatabase fixture;
  setUp(() async => fixture = await TestDatabase.create());
  tearDown(() => fixture.dispose());

  test('SQLite persists records and profile names across reopening', () async {
    final saved = await fixture.database.save(exampleExpense());
    final id = saved.single.id;
    await ProfileDatabase(fixture.database).saveName('Aslah');
    await ProfileDatabase(fixture.database).savePhotoPath('/path/to/photo.png');
    await fixture.database.close();
    final reopened = ExpenseDatabase(
      factory: databaseFactoryFfi,
      databasePath: fixture.database.databasePath,
    );
    try {
      final entry = (await reopened.all()).single;
      expect(entry.id, id);
      expect(entry.amountPaise, 12345);
      expect(entry.category, 'Food');
      expect(entry.description, 'With friends');
      expect(entry.date, DateTime(2026, 10, 29));
      expect(await ProfileDatabase(reopened).loadName(), 'Aslah');
      expect(
        await ProfileDatabase(reopened).loadPhotoPath(),
        '/path/to/photo.png',
      );
    } finally {
      await reopened.close();
    }
  });

  test('editing preserves identity; deletion and clearing persist', () async {
    final first = (await fixture.database.save(exampleExpense())).single;
    final edited = await fixture.database.save(
      exampleExpense(id: first.id, amount: 999, title: 'Dinner'),
    );
    expect(edited.single.id, first.id);
    expect(edited.single.title, 'Dinner');
    expect(edited.single.amountPaise, 999);
    expect(await fixture.database.delete(first.id!), isEmpty);
    await fixture.database.save(exampleExpense());
    expect(await fixture.database.clear(), isEmpty);
    await fixture.database.close();
    expect(await fixture.database.all(), isEmpty);
  });

  test(
    'user strings cannot become SQL and invalid rows are rejected',
    () async {
      const title = "Lunch'); DROP TABLE expenses; --";
      expect(
        (await fixture.database.save(
          exampleExpense(title: title),
        )).single.title,
        title,
      );
      await expectLater(
        fixture.database.save(exampleExpense(amount: 0)),
        throwsFormatException,
      );
      await expectLater(
        fixture.database.save(exampleExpense(title: '  ')),
        throwsFormatException,
      );
      final db = await fixture.database.connection;
      final invalid = exampleExpense().toMap()..['amount_paise'] = -1;
      await expectLater(
        db.insert('expenses', invalid),
        throwsA(isA<DatabaseException>()),
      );
      expect((await fixture.database.all()).length, 1);
    },
  );

  test(
    'updating or deleting missing records does not alter other records',
    () async {
      await fixture.database.save(exampleExpense());
      await expectLater(
        fixture.database.save(exampleExpense(id: 999)),
        throwsStateError,
      );
      await expectLater(fixture.database.delete(999), throwsStateError);
      expect((await fixture.database.all()).length, 1);
    },
  );
}
