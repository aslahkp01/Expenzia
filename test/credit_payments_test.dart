import 'package:expenzia/data/credit_database.dart';
import 'package:expenzia/data/credit_payments.dart';
import 'package:expenzia/models/credit.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/credit_examples.dart';
import 'support/test_database.dart';

void main() {
  late TestDatabase fixture;
  late CreditDatabase database;
  late CreditPayments payments;
  setUp(() async {
    fixture = await TestDatabase.create();
    database = CreditDatabase(fixture.database);
    payments = CreditPayments(database);
  });
  tearDown(() => fixture.dispose());

  test('one-time payment adds an expense exactly once', () async {
    final plan = (await database.save(
      exampleCredit(plan: CreditPlan.oneTime),
    )).single;
    final result = await payments.pay(plan, now: DateTime(2026, 1, 30));
    expect(result.credits.single.isPaid, isTrue);
    expect(result.expenses.single.amountPaise, 85000);
    expect(result.expenses.single.category, 'Subscriptions');
    expect(result.expenses.single.date, DateTime(2026, 1, 30));
    await expectLater(payments.pay(plan), throwsStateError);
    await database.delete(plan.id!);
    expect((await fixture.database.all()).length, 1);
  });

  test(
    'monthly payment advances one cycle and rejects concurrent stale claims',
    () async {
      final plan = (await database.save(exampleCredit())).single;
      final outcomes = await Future.wait([
        payments.pay(plan).then((_) => true, onError: (_) => false),
        payments.pay(plan).then((_) => true, onError: (_) => false),
      ]);
      expect(outcomes.where((success) => success).length, 1);
      expect((await fixture.database.all()).length, 1);
      final next = (await database.all()).single;
      expect(next.dueDate, DateTime(2026, 2, 28));
      expect(next.isPaid, isFalse);
      final result = await payments.pay(next);
      expect(result.credits.single.dueDate, DateTime(2026, 3, 31));
      expect(result.expenses.length, 2);
    },
  );

  test('failure after inserting the expense rolls back both records', () async {
    final plan = (await database.save(exampleCredit())).single;
    final db = await fixture.database.connection;
    await db.execute(
      '''CREATE TRIGGER fail_credit_update
      BEFORE UPDATE ON credits BEGIN SELECT RAISE(ABORT, 'test failure'); END''',
    );
    await expectLater(payments.pay(plan), throwsA(isA<Exception>()));
    expect(await fixture.database.all(), isEmpty);
    expect((await database.all()).single.dueDate, plan.dueDate);
    expect((await database.all()).single.paidAt, isNull);
  });

  test('a stale amount cannot be paid using an earlier confirmation', () async {
    final plan = (await database.save(exampleCredit())).single;
    await database.save(exampleCredit(id: plan.id, amount: 99900));
    await expectLater(payments.pay(plan), throwsStateError);
    expect(await fixture.database.all(), isEmpty);
  });
}
