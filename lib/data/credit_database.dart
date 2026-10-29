import 'package:sqflite/sqflite.dart';

import '../models/credit.dart';
import '../utils/credit_schedule.dart';
import 'expense_database.dart';

class CreditDatabase {
  CreditDatabase(this.database);
  final ExpenseDatabase database;

  Future<List<Credit>> read(DatabaseExecutor executor) async {
    final rows = await executor.query(
      'credits',
      orderBy:
          "CASE WHEN plan = 'oneTime' AND paid_at IS NOT NULL THEN 1 ELSE 0 END, "
          'due_date, id DESC',
    );
    return rows.map(Credit.fromMap).toList(growable: false);
  }

  Future<List<Credit>> all() async => read(await database.connection);

  Future<List<Credit>> save(Credit credit) async {
    validateCredit(credit);
    final db = await database.connection;
    return db.transaction((transaction) async {
      if (credit.id == null) {
        await transaction.insert('credits', credit.toMap());
      } else {
        final changed = await transaction.update(
          'credits',
          credit.toMap(),
          where: 'id = ?',
          whereArgs: [credit.id],
        );
        if (changed != 1) throw StateError('Payment plan no longer exists.');
      }
      return read(transaction);
    });
  }

  Future<List<Credit>> delete(int id) async {
    final db = await database.connection;
    return db.transaction((transaction) async {
      final changed = await transaction.delete(
        'credits',
        where: 'id = ?',
        whereArgs: [id],
      );
      if (changed != 1) throw StateError('Payment plan no longer exists.');
      return read(transaction);
    });
  }
}
