import 'package:expenzia/models/credit.dart';

Credit exampleCredit({
  int? id,
  String name = 'Netflix',
  int amount = 85000,
  CreditPlan plan = CreditPlan.monthly,
  DateTime? dueDate,
}) {
  final due = dueDate ?? DateTime(2026, 1, 31);
  return Credit(
    id: id,
    recipient: name,
    amountPaise: amount,
    type: 'Subscriptions',
    dueDate: due,
    plan: plan,
    anchorDay: due.day,
    anchorMonth: due.month,
  );
}
