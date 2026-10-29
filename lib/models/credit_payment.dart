import 'credit.dart';
import 'expense.dart';

class CreditPayment {
  const CreditPayment({required this.credits, required this.expenses});
  final List<Credit> credits;
  final List<Expense> expenses;
}
