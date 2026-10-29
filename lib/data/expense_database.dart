import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

import '../models/expense.dart';
import '../utils/validators.dart';
import 'expense_schema.dart';

class ExpenseDatabase {
  ExpenseDatabase({DatabaseFactory? factory, this.databasePath})
    : _factory = factory ?? databaseFactory;

  final DatabaseFactory _factory;
  final String? databasePath;
  Future<Database>? _connection;

  Future<Database> _open() async {
    final location =
        databasePath ??
        path.join(await _factory.getDatabasesPath(), 'expenzia.db');
    return _factory.openDatabase(
      location,
      options: OpenDatabaseOptions(
        version: ExpenseSchema.version,
        onCreate: ExpenseSchema.create,
        onUpgrade: ExpenseSchema.upgrade,
      ),
    );
  }

  Future<Database> get connection async {
    final pending = _connection ??= _open();
    try {
      return await pending;
    } catch (_) {
      _connection = null;
      rethrow;
    }
  }

  Future<List<Expense>> _read(DatabaseExecutor executor) async {
    final rows = await executor.query(
      ExpenseSchema.table,
      orderBy: 'date DESC, id DESC',
    );
    return rows.map(Expense.fromMap).toList(growable: false);
  }

  Future<List<Expense>> all() async => _read(await connection);

  Future<List<Expense>> save(Expense expense) async {
    validateExpense(expense);
    final db = await connection;
    return db.transaction((transaction) async {
      if (expense.id == null) {
        await transaction.insert(ExpenseSchema.table, expense.toMap());
      } else {
        final count = await transaction.update(
          ExpenseSchema.table,
          expense.toMap(),
          where: 'id = ?',
          whereArgs: [expense.id],
        );
        if (count != 1) throw StateError('Expense no longer exists.');
      }
      return _read(transaction);
    });
  }

  Future<List<Expense>> delete(int id) async {
    final db = await connection;
    return db.transaction((transaction) async {
      final count = await transaction.delete(
        ExpenseSchema.table,
        where: 'id = ?',
        whereArgs: [id],
      );
      if (count != 1) throw StateError('Expense no longer exists.');
      return _read(transaction);
    });
  }

  Future<List<Expense>> clear() async {
    final db = await connection;
    return db.transaction((transaction) async {
      await transaction.delete(ExpenseSchema.table);
      return _read(transaction);
    });
  }

  Future<void> close() async {
    final pending = _connection;
    _connection = null;
    if (pending != null) await (await pending).close();
  }
}
