enum CreditPlan {
  oneTime('One-Time'),
  monthly('Monthly'),
  yearly('Yearly');

  const CreditPlan(this.label);
  final String label;
}

const creditTypes = ['Subscriptions', 'Bills', 'Personal', 'Other'];

class Credit {
  const Credit({
    this.id,
    required this.recipient,
    required this.amountPaise,
    required this.type,
    required this.dueDate,
    required this.plan,
    required this.anchorDay,
    required this.anchorMonth,
    this.paidAt,
  });

  final int? id;
  final String recipient;
  final int amountPaise;
  final String type;
  final DateTime dueDate;
  final CreditPlan plan;
  final int anchorDay;
  final int anchorMonth;
  final DateTime? paidAt;
  bool get isPaid => plan == CreditPlan.oneTime && paidAt != null;

  Map<String, Object?> toMap() => {
    if (id != null) 'id': id,
    'recipient': recipient.trim(),
    'amount_paise': amountPaise,
    'type': type,
    'due_date': DateTime(
      dueDate.year,
      dueDate.month,
      dueDate.day,
    ).toIso8601String(),
    'plan': plan.name,
    'anchor_day': anchorDay,
    'anchor_month': anchorMonth,
    'paid_at': paidAt?.toIso8601String(),
  };

  factory Credit.fromMap(Map<String, Object?> row) => Credit(
    id: row['id'] as int,
    recipient: row['recipient'] as String,
    amountPaise: row['amount_paise'] as int,
    type: row['type'] as String,
    dueDate: DateTime.parse(row['due_date'] as String),
    plan: CreditPlan.values.byName(row['plan'] as String),
    anchorDay: row['anchor_day'] as int,
    anchorMonth: row['anchor_month'] as int,
    paidAt: row['paid_at'] == null
        ? null
        : DateTime.parse(row['paid_at'] as String),
  );
}
