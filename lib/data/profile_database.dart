import 'package:sqflite/sqflite.dart';

import 'expense_database.dart';

class ProfileDatabase {
  ProfileDatabase(this.database);
  final ExpenseDatabase database;

  Future<String> loadName() async {
    final db = await database.connection;
    final rows = await db.query(
      'settings',
      where: 'key = ?',
      whereArgs: ['profile_name'],
    );
    return rows.isEmpty ? 'Expenzia User' : rows.first['value'] as String;
  }

  Future<void> saveName(String name) async {
    if (name.trim().isEmpty) throw const FormatException('Name is required.');
    final db = await database.connection;
    await db.insert('settings', {
      'key': 'profile_name',
      'value': name.trim(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
