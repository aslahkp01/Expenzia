import 'package:flutter/material.dart';

import '../controllers/expense_controller.dart';
import '../models/expense.dart';
import '../theme/app_colors.dart';
import 'empty_state.dart';
import 'expense_tile.dart';

class RecentExpenses extends StatelessWidget {
  const RecentExpenses({
    super.key,
    required this.controller,
    required this.onSeeAll,
    required this.onEdit,
  });
  final ExpenseController controller;
  final VoidCallback onSeeAll;
  final ValueChanged<Expense> onEdit;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(
            child: Text(
              'Transactions History',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
          ),
          TextButton(
            onPressed: onSeeAll,
            style: TextButton.styleFrom(foregroundColor: AppColors.muted),
            child: const Text('See all'),
          ),
        ],
      ),
      if (controller.expenses.isEmpty) const EmptyState(),
      for (final expense in controller.expenses.take(3))
        ExpenseTile(
          expense: expense,
          controller: controller,
          onEdit: () => onEdit(expense),
        ),
    ],
  );
}
