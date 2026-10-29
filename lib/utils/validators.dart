import '../models/expense.dart';
import 'amount_parser.dart';

String? validateRequired(String? value) =>
    value == null || value.trim().isEmpty ? 'This field is required' : null;

void validateExpense(Expense expense) {
  if (expense.title.trim().isEmpty || expense.category.trim().isEmpty) {
    throw const FormatException('Title and category are required.');
  }
  if (expense.amountPaise <= 0 || expense.amountPaise > maxAmountPaise) {
    throw const FormatException('The amount is outside the allowed range.');
  }
  if (expense.date.year < 2000 || expense.date.year > 2100) {
    throw const FormatException('Choose a date between 2000 and 2100.');
  }
}
