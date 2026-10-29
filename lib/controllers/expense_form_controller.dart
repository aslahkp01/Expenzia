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
      date = expense?.date ?? DateTime.now();

  final int? id;
  final TextEditingController title;
  final TextEditingController amount;
  final TextEditingController description;
  String? category;
  DateTime date;

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
  );

  @override
  void dispose() {
    title.dispose();
    amount.dispose();
    description.dispose();
    super.dispose();
  }
}
