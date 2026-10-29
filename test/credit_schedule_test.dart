import 'package:expenzia/models/credit.dart';
import 'package:expenzia/utils/credit_schedule.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/credit_examples.dart';

void main() {
  test('monthly plans retain the original day across short months', () {
    final january = exampleCredit();
    expect(nextCreditDate(january), DateTime(2026, 2, 28));
    final february = Credit.fromMap({
      ...january.toMap(),
      'id': 1,
      'due_date': DateTime(2026, 2, 28).toIso8601String(),
    });
    expect(nextCreditDate(february), DateTime(2026, 3, 31));
    expect(
      nextCreditDate(exampleCredit(dueDate: DateTime(2026, 12, 31))),
      DateTime(2027, 1, 31),
    );
  });

  test('yearly leap-day plans return to February 29 in leap years', () {
    var credit = exampleCredit(
      plan: CreditPlan.yearly,
      dueDate: DateTime(2024, 2, 29),
    );
    for (var year = 2025; year <= 2028; year++) {
      final next = nextCreditDate(credit)!;
      expect(next, DateTime(year, 2, year == 2028 ? 29 : 28));
      credit = Credit.fromMap({
        ...credit.toMap(),
        'id': 1,
        'due_date': next.toIso8601String(),
      });
    }
    expect(nextCreditDate(exampleCredit(plan: CreditPlan.oneTime)), isNull);
  });
}
