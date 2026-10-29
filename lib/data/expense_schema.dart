import 'package:sqflite/sqflite.dart';

import '../utils/amount_parser.dart';

class ExpenseSchema {
  static const version = 1;
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
        description TEXT NOT NULL DEFAULT ''
      )
    ''');
    await db.execute('''
      CREATE INDEX expenses_date_index ON $table(date DESC, id DESC)
    ''');
    await db.execute('''
      CREATE TABLE settings (key TEXT PRIMARY KEY, value TEXT NOT NULL)
    ''');
  }
}
