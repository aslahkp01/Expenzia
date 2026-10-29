import 'package:expenzia/models/expense.dart';
import 'package:expenzia/models/expense_summary.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('weekly and monthly averages exclude future and older periods', () {
    Expense entry(DateTime date, int amount) => Expense(
      title: 'Bill',
      amountPaise: amount,
      category: 'Bills',
      date: date,
    );
    final summary = ExpenseSummary([
      entry(DateTime(2026, 10, 29), 2900),
      entry(DateTime(2026, 10, 1), 2900),
      entry(DateTime(2026, 9, 30), 100),
      entry(DateTime(2026, 10, 30), 9999),
    ], now: DateTime(2026, 10, 29));
    expect(summary.totalPaise, 15899);
    expect(summary.weeklyPaise, 2900);
    expect(summary.dailyAveragePaise, 200);
  });

  test(
    'summary calculates income and net balance separately from expenses',
    () {
      final summary = ExpenseSummary([
        Expense(
          title: 'Salary',
          amountPaise: 50000,
          category: 'Salary',
          date: DateTime(2026, 10, 29),
          type: 'income',
        ),
        Expense(
          title: 'Groceries',
          amountPaise: 10000,
          category: 'Food',
          date: DateTime(2026, 10, 29),
          type: 'expense',
        ),
      ]);
      expect(summary.totalIncomePaise, 50000);
      expect(summary.totalExpensePaise, 10000);
      expect(summary.netBalancePaise, 40000);
    },
  );
}
