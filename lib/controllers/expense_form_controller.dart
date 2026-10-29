import 'package:flutter/material.dart';

import '../models/expense.dart';
import '../utils/amount_parser.dart';

class ExpenseFormController extends ChangeNotifier {
  ExpenseFormController(Expense? expense)
    : id = expense?.id,
      title = TextEditingController(text: expense?.title ?? ''),
      amount = TextEditingController(
        text: expense == null ? '' : amountInput(expense.amountPaise),
      ),
      description = TextEditingController(text: expense?.description ?? ''),
      category = expense?.category,
      date = expense?.date ?? DateTime.now(),
      type = expense?.type ?? 'expense';

  final int? id;
  final TextEditingController title;
  final TextEditingController amount;
  final TextEditingController description;
  String? category;
  DateTime date;
  String type;

  bool get isIncome => type == 'income';

  void setType(String value) {
    if (type == value) return;
    type = value;
    category = null;
    notifyListeners();
  }

  void setCategory(String? value) {
    category = value;
    notifyListeners();
  }

  void setDate(DateTime value) {
    date = value;
    notifyListeners();
  }

  Expense toExpense() => Expense(
    id: id,
    title: title.text.trim(),
    amountPaise: parseAmountPaise(amount.text)!,
    category: category!,
    date: date,
    description: description.text.trim(),
    type: type,
  );

  @override
  void dispose() {
    title.dispose();
    amount.dispose();
    description.dispose();
    super.dispose();
  }
}
