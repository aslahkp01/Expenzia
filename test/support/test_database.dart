import 'dart:io';

import 'package:expenzia/data/expense_database.dart';
import 'package:expenzia/models/expense.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class TestDatabase {
  TestDatabase._(this.directory, this.database);
  final Directory directory;
  final ExpenseDatabase database;

  static Future<TestDatabase> create() async {
    sqfliteFfiInit();
    final directory = await Directory.systemTemp.createTemp('expenzia_test_');
    final database = ExpenseDatabase(
      factory: databaseFactoryFfi,
      databasePath: '${directory.path}/expenses.db',
    );
    return TestDatabase._(directory, database);
  }

  Future<void> dispose() async {
    await database.close();
    final target = directory.absolute.path;
    final parent = Directory.systemTemp.absolute.path;
    if (!target.startsWith('$parent${Platform.pathSeparator}expenzia_test_')) {
      throw StateError('Refusing to remove an unexpected test directory.');
    }
    await directory.delete(recursive: true);
  }
}

Expense exampleExpense({int? id, int amount = 12345, String title = 'Lunch'}) =>
    Expense(
      id: id,
      title: title,
      amountPaise: amount,
      category: 'Food',
      date: DateTime(2026, 10, 29),
      description: 'With friends',
    );
