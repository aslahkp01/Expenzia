import 'package:flutter/foundation.dart';

import '../data/credit_database.dart';
import '../data/credit_payments.dart';
import '../models/credit.dart';
import '../models/credit_payment.dart';
import 'expense_controller.dart';

class CreditController extends ChangeNotifier {
  CreditController(this.database, this.expenses);
  final CreditDatabase database;
  final ExpenseController expenses;
  List<Credit> _credits = const [];
  List<Credit> get credits => List.unmodifiable(_credits);
  bool busy = false;
  bool loaded = false;
  bool _disposed = false;
  String? error;

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  Future<bool> _run(
    Future<List<Credit>> Function() action,
    String message,
  ) async {
    if (busy) return false;
    busy = true;
    error = null;
    _notify();
    try {
      _credits = await action();
      loaded = true;
      return true;
    } catch (_) {
      error = message;
      return false;
    } finally {
      busy = false;
      _notify();
    }
  }

  Future<bool> load() =>
      _run(database.all, 'Could not load payment plans. Please try again.');
  Future<bool> save(Credit credit) => _run(
    () => database.save(credit),
    'Could not save the payment plan. Please try again.',
  );
  Future<bool> delete(Credit credit) => _run(
    () => database.delete(credit.id!),
    'Could not delete the payment plan. Please try again.',
  );

  Future<bool> pay(Credit credit) => _run(() async {
    CreditPayment? payment;
    final saved = await expenses.recordPayment(() async {
      payment = await CreditPayments(database).pay(credit);
      return payment!.expenses;
    });
    if (!saved) throw StateError('Payment could not be recorded.');
    return payment!.credits;
  }, 'Could not record payment. Refresh and check whether it is already paid.');

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
