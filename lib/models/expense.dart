class Expense {
  const Expense({
    this.id,
    required this.title,
    required this.amountPaise,
    required this.category,
    required this.date,
    this.description = '',
    this.type = 'expense',
  });

  final int? id;
  final String title;
  final int amountPaise;
  final String category;
  final DateTime date;
  final String description;
  final String type;

  bool get isIncome => type == 'income';

  Map<String, Object?> toMap() {
    final day = DateTime(date.year, date.month, date.day);
    return {
      if (id != null) 'id': id,
      'title': title.trim(),
      'amount_paise': amountPaise,
      'category': category.trim(),
      'date': day.toIso8601String(),
      'description': description.trim(),
      'type': type,
    };
  }

  factory Expense.fromMap(Map<String, Object?> row) => Expense(
    id: row['id'] as int,
    title: row['title'] as String,
    amountPaise: row['amount_paise'] as int,
    category: row['category'] as String,
    date: DateTime.parse(row['date'] as String),
    description: row['description'] as String,
    type: (row['type'] as String?) ?? 'expense',
  );
}
