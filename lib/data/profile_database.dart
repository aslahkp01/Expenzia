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

  Future<String?> loadPhotoPath() async {
    final db = await database.connection;
    final rows = await db.query(
      'settings',
      where: 'key = ?',
      whereArgs: ['profile_photo_path'],
    );
    return rows.isEmpty ? null : rows.first['value'] as String?;
  }

  Future<void> savePhotoPath(String? path) async {
    final db = await database.connection;
    if (path == null || path.isEmpty) {
      await db.delete(
        'settings',
        where: 'key = ?',
        whereArgs: ['profile_photo_path'],
      );
      return;
    }
    await db.insert('settings', {
      'key': 'profile_photo_path',
      'value': path,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
