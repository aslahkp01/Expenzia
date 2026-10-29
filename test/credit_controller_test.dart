import 'package:expenzia/controllers/credit_controller.dart';
import 'package:expenzia/controllers/expense_controller.dart';
import 'package:expenzia/data/credit_database.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/credit_examples.dart';
import 'support/test_database.dart';

void main() {
  test(
    'duplicate submissions are blocked and payment refreshes expense totals',
    () async {
      final fixture = await TestDatabase.create();
      final expenses = ExpenseController(fixture.database);
      final credits = CreditController(
        CreditDatabase(fixture.database),
        expenses,
      );
      try {
        await expenses.load();
        await credits.load();
        final saving = credits.save(exampleCredit());
        expect(await credits.save(exampleCredit()), isFalse);
        expect(await saving, isTrue);
        expect(credits.credits.length, 1);
        expect(expenses.totalPaise, 0);
        final plan = credits.credits.single;
        final paying = credits.pay(plan);
        expect(await credits.pay(plan), isFalse);
        expect(await paying, isTrue);
        expect(expenses.totalPaise, 85000);
        expect(credits.credits.single.dueDate, DateTime(2026, 2, 28));
        expect(await credits.pay(plan), isFalse);
        expect(credits.error, isNotNull);
        expect(expenses.totalPaise, 85000);
      } finally {
        credits.dispose();
        expenses.dispose();
        await fixture.dispose();
      }
    },
  );
}
