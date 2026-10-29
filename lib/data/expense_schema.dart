import 'package:sqflite/sqflite.dart';

import '../utils/amount_parser.dart';
import 'credit_schema.dart';

class ExpenseSchema {
  static const version = 2;
  static const table = 'expenses';

  static Future<void> create(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL CHECK(length(trim(title)) > 0),
        amount_paise INTEGER NOT NULL CHECK(
          typeof(amount_paise) = 'integer'
          AND amount_paise > 0 AND amount_paise <= $maxAmountPaise
        ),
        category TEXT NOT NULL CHECK(length(trim(category)) > 0),
        date TEXT NOT NULL,
        description TEXT NOT NULL DEFAULT '',
        type TEXT NOT NULL DEFAULT 'expense'
      )
    ''');
    await db.execute('''
      CREATE INDEX expenses_date_index ON $table(date DESC, id DESC)
    ''');
    await db.execute('''
      CREATE TABLE settings (key TEXT PRIMARY KEY, value TEXT NOT NULL)
    ''');
    await CreditSchema.create(db);
  }

  static Future<void> upgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    if (oldVersion < 2) {
      await CreditSchema.create(db);
      await db.execute(
        "ALTER TABLE $table ADD COLUMN type TEXT NOT NULL DEFAULT 'expense'",
      );
    }
  }
}
