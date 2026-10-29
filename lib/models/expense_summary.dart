import 'expense.dart';

class ExpenseSummary {
  ExpenseSummary(List<Expense> expenses, {DateTime? now}) {
    final current = now ?? DateTime.now();
    final today = DateTime(current.year, current.month, current.day);
    final tomorrow = DateTime(today.year, today.month, today.day + 1);
    final monthStart = DateTime(today.year, today.month);
    final weekStart = DateTime(
      today.year,
      today.month,
      today.day - today.weekday + 1,
    );
    var monthTotal = 0;
    for (final expense in expenses) {
      totalPaise += expense.amountPaise;
      if (!expense.date.isBefore(tomorrow)) continue;
      if (!expense.date.isBefore(monthStart)) {
        monthTotal += expense.amountPaise;
      }
      if (!expense.date.isBefore(weekStart)) {
        weeklyPaise += expense.amountPaise;
      }
    }
    dailyAveragePaise = (monthTotal + today.day ~/ 2) ~/ today.day;
  }

  int totalPaise = 0;
  int weeklyPaise = 0;
  int dailyAveragePaise = 0;
}
