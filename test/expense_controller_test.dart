import 'package:expenzia/controllers/expense_controller.dart';
import 'package:expenzia/data/expense_database.dart';
import 'package:expenzia/models/expense.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'support/test_database.dart';

class FailingDatabase extends ExpenseDatabase {
  FailingDatabase() : super(factory: databaseFactoryFfi);
  bool failLoading = true;
  @override
  Future<List<Expense>> all() async {
    if (failLoading) throw StateError('Unavailable');
    return [];
  }

  @override
  Future<List<Expense>> save(Expense expense) async =>
      throw StateError('Read-only database');
}

void main() {
  test(
    'totals follow CRUD and simultaneous saves cannot duplicate rows',
    () async {
      final fixture = await TestDatabase.create();
      final controller = ExpenseController(fixture.database);
      try {
        await controller.load();
        expect(controller.loaded, isTrue);
        expect(controller.totalPaise, 0);
        final firstSave = controller.save(exampleExpense());
        expect(await controller.save(exampleExpense()), isFalse);
        expect(await firstSave, isTrue);
        expect(controller.expenses.length, 1);
        expect(controller.totalPaise, 12345);
        final id = controller.expenses.single.id!;
        await controller.save(exampleExpense(id: id, amount: 250));
        expect(controller.totalPaise, 250);
        await controller.delete(id);
        expect(controller.totalPaise, 0);
        expect(controller.expenses, isEmpty);
      } finally {
        controller.dispose();
        await fixture.dispose();
      }
    },
  );

  test(
    'load errors support retry and failed writes leave data unchanged',
    () async {
      final database = FailingDatabase();
      final controller = ExpenseController(database);
      await controller.load();
      expect(controller.loaded, isFalse);
      expect(controller.loading, isFalse);
      expect(controller.error, contains('Could not load'));
      database.failLoading = false;
      await controller.load();
      expect(controller.loaded, isTrue);
      expect(controller.error, isNull);
      expect(await controller.save(exampleExpense()), isFalse);
      expect(controller.error, contains('Could not save'));
      expect(controller.saving, isFalse);
      expect(controller.expenses, isEmpty);
      controller.dispose();
    },
  );
}
