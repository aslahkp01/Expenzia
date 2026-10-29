import 'package:flutter/material.dart';

import '../models/credit.dart';
import '../utils/amount_parser.dart';

class CreditFormController extends ChangeNotifier {
  CreditFormController(this.original) {
    recipient.text = original?.recipient ?? '';
    amount.text = original == null ? '' : amountInput(original!.amountPaise);
    type = original?.type ?? creditTypes.first;
    plan = original?.plan ?? CreditPlan.monthly;
    date = original?.dueDate ?? DateTime.now();
  }

  final Credit? original;
  final recipient = TextEditingController();
  final amount = TextEditingController();
  late String type;
  late CreditPlan plan;
  late DateTime date;

  void setType(String value) {
    type = value;
    notifyListeners();
  }

  void setPlan(CreditPlan value) {
    plan = value;
    notifyListeners();
  }

  void setDate(DateTime value) {
    date = value;
    notifyListeners();
  }

  Credit toCredit() {
    final day = DateTime(date.year, date.month, date.day);
    final changed = original?.dueDate != day || original?.plan != plan;
    return Credit(
      id: original?.id,
      recipient: recipient.text.trim(),
      amountPaise: parseAmountPaise(amount.text)!,
      type: type,
      dueDate: day,
      plan: plan,
      anchorDay: changed ? day.day : original!.anchorDay,
      anchorMonth: changed ? day.month : original!.anchorMonth,
      paidAt: changed ? null : original?.paidAt,
    );
  }

  void reset() {
    recipient.clear();
    amount.clear();
    type = creditTypes.first;
    plan = CreditPlan.monthly;
    date = DateTime.now();
    notifyListeners();
  }

  @override
  void dispose() {
    recipient.dispose();
    amount.dispose();
    super.dispose();
  }
}
