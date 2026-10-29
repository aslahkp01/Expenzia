import '../models/credit.dart';
import '../models/credit_payment.dart';
import '../models/expense.dart';
import '../utils/credit_schedule.dart';
import '../utils/formatters.dart';
import 'credit_database.dart';

class CreditPayments {
  CreditPayments(this.database);
  final CreditDatabase database;

  Future<CreditPayment> pay(Credit expected, {DateTime? now}) async {
    final db = await database.database.connection;
    return db.transaction((transaction) async {
      final rows = await transaction.query(
        'credits',
        where: 'id = ?',
        whereArgs: [expected.id],
      );
      if (rows.isEmpty) throw StateError('Payment plan no longer exists.');
      final credit = Credit.fromMap(rows.single);
      if (credit.isPaid ||
          credit.dueDate != expected.dueDate ||
          credit.paidAt != expected.paidAt ||
          credit.plan != expected.plan ||
          credit.amountPaise != expected.amountPaise ||
          credit.recipient != expected.recipient ||
          credit.type != expected.type ||
          credit.anchorDay != expected.anchorDay ||
          credit.anchorMonth != expected.anchorMonth) {
        throw StateError('This payment was already recorded or changed.');
      }
      final paidAt = now ?? DateTime.now();
      final expense = Expense(
        title: credit.recipient,
        amountPaise: credit.amountPaise,
        category: ['Subscriptions', 'Bills'].contains(credit.type)
            ? credit.type
            : 'Other',
        date: paidAt,
        description:
            '${credit.plan.label} payment due ${formatDate(credit.dueDate)}',
      );
      await transaction.insert('expenses', expense.toMap());
      final next = nextCreditDate(credit);
      await transaction.update(
        'credits',
        {
          'paid_at': paidAt.toIso8601String(),
          if (next != null) 'due_date': next.toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [credit.id],
      );
      final expenseRows = await transaction.query(
        'expenses',
        orderBy: 'date DESC, id DESC',
      );
      return CreditPayment(
        credits: await database.read(transaction),
        expenses: expenseRows.map(Expense.fromMap).toList(growable: false),
      );
    });
  }
}
