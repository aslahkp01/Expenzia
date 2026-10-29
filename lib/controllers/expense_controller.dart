import 'package:flutter/foundation.dart';

import '../data/expense_database.dart';
import '../models/expense.dart';

class ExpenseController extends ChangeNotifier {
  ExpenseController(this.database);

  final ExpenseDatabase database;
  List<Expense> _expenses = const [];
  bool _disposed = false;
  bool loading = false;
  bool saving = false;
  bool loaded = false;
  String? error;

  List<Expense> get expenses => List.unmodifiable(_expenses);
  int get totalPaise =>
      _expenses.fold(0, (sum, item) => sum + item.amountPaise);

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  Future<void> load() async {
    if (loading || saving) return;
    loading = true;
    error = null;
    _notify();
    try {
      _expenses = await database.all();
      loaded = true;
    } catch (_) {
      error = 'Could not load expenses. Please try again.';
    } finally {
      loading = false;
      _notify();
    }
  }

  Future<bool> _write(
    Future<List<Expense>> Function() action,
    String failureMessage,
  ) async {
    if (saving || loading || !loaded) return false;
    saving = true;
    error = null;
    _notify();
    try {
      _expenses = await action();
      return true;
    } catch (_) {
      error = failureMessage;
      return false;
    } finally {
      saving = false;
      _notify();
    }
  }

  Future<bool> save(Expense expense) => _write(
    () => database.save(expense),
    'Could not save the expense. Your changes were not saved.',
  );

  Future<bool> delete(int id) => _write(
    () => database.delete(id),
    'Could not delete the expense. Please try again.',
  );

  Future<bool> clear() =>
      _write(database.clear, 'Could not clear expenses. Please try again.');

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
