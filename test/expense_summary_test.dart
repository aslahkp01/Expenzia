import 'package:expenzia/models/expense_summary.dart';
import 'package:expenzia/models/expense.dart';
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
}
