import 'package:sqflite/sqflite.dart';

import '../utils/amount_parser.dart';

class CreditSchema {
  static Future<void> create(Database db) async {
    await db.execute('''
      CREATE TABLE credits (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        recipient TEXT NOT NULL CHECK(length(trim(recipient)) > 0),
        amount_paise INTEGER NOT NULL CHECK(
          typeof(amount_paise) = 'integer'
          AND amount_paise > 0 AND amount_paise <= $maxAmountPaise
        ),
        type TEXT NOT NULL CHECK(type IN
          ('Subscriptions', 'Bills', 'Personal', 'Other')),
        due_date TEXT NOT NULL,
        plan TEXT NOT NULL CHECK(plan IN ('oneTime', 'monthly', 'yearly')),
        anchor_day INTEGER NOT NULL CHECK(anchor_day BETWEEN 1 AND 31),
        anchor_month INTEGER NOT NULL CHECK(anchor_month BETWEEN 1 AND 12),
        paid_at TEXT
      )
    ''');
    await db.execute('CREATE INDEX credits_due_index ON credits(due_date)');
  }
}
