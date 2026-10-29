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
    var monthExpenses = 0;
    for (final item in expenses) {
      if (item.isIncome) {
        totalIncomePaise += item.amountPaise;
      } else {
        totalExpensePaise += item.amountPaise;
        totalPaise += item.amountPaise;
        if (!item.date.isBefore(tomorrow)) continue;
        if (!item.date.isBefore(monthStart)) {
          monthExpenses += item.amountPaise;
        }
        if (!item.date.isBefore(weekStart)) {
          weeklyPaise += item.amountPaise;
        }
      }
    }
    netBalancePaise = totalIncomePaise - totalExpensePaise;
    dailyAveragePaise = (monthExpenses + today.day ~/ 2) ~/ today.day;
  }

  int totalPaise = 0;
  int totalExpensePaise = 0;
  int totalIncomePaise = 0;
  int netBalancePaise = 0;
  int weeklyPaise = 0;
  int dailyAveragePaise = 0;
}
