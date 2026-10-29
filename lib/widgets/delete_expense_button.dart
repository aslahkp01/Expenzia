import 'package:flutter/material.dart';

import '../controllers/expense_controller.dart';
import '../models/expense.dart';
import '../theme/app_colors.dart';

Future<void> deleteExpense(
  BuildContext context,
  ExpenseController controller,
  Expense expense,
) async {
  if (controller.saving) return;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Delete expense?'),
      content: Text('Permanently delete "${expense.title}"?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text(
            'Delete',
            style: TextStyle(color: AppColors.expense),
          ),
        ),
      ],
    ),
  );
  if (!context.mounted || confirmed != true) return;
  final deleted = await controller.delete(expense.id!);
  if (!context.mounted || deleted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(controller.error ?? 'Could not delete expense.')),
  );
}
