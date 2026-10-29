import 'package:expenzia/data/credit_database.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/credit_examples.dart';
import 'support/test_database.dart';

void main() {
  late TestDatabase fixture;
  late CreditDatabase database;
  setUp(() async {
    fixture = await TestDatabase.create();
    database = CreditDatabase(fixture.database);
  });
  tearDown(() => fixture.dispose());

  test('saved plans persist, edit without duplication, and delete', () async {
    final saved = (await database.save(exampleCredit())).single;
    await fixture.database.close();
    final restored = (await database.all()).single;
    expect(restored.id, saved.id);
    expect(restored.amountPaise, 85000);
    expect(restored.anchorDay, 31);
    final edited = (await database.save(
      exampleCredit(id: saved.id, name: 'Netflix Premium', amount: 99900),
    )).single;
    expect(edited.id, saved.id);
    expect(edited.recipient, 'Netflix Premium');
    expect(edited.amountPaise, 99900);
    expect(await database.delete(saved.id!), isEmpty);
  });

  test(
    'invalid plans fail and recipient strings remain bound SQL values',
    () async {
      await expectLater(
        database.save(exampleCredit(name: ' ')),
        throwsFormatException,
      );
      await expectLater(
        database.save(exampleCredit(amount: -1)),
        throwsFormatException,
      );
      const name = "Netflix'); DROP TABLE expenses; --";
      expect(
        (await database.save(exampleCredit(name: name))).single.recipient,
        name,
      );
      expect(await fixture.database.all(), isEmpty);
    },
  );
}
