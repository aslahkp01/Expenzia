import 'package:flutter/material.dart';

import '../controllers/expense_controller.dart';
import '../models/expense.dart';
import '../theme/app_spacing.dart';
import '../widgets/empty_state.dart';
import '../widgets/expense_content.dart';
import '../widgets/expense_tile.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({
    super.key,
    required this.controller,
    required this.onEdit,
  });
  final ExpenseController controller;
  final ValueChanged<Expense> onEdit;

  @override
  Widget build(BuildContext context) => ExpenseContent(
    controller: controller,
    child: RefreshIndicator(
      onRefresh: controller.load,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.page),
        children: [
          if (controller.expenses.isEmpty) const EmptyState(),
          for (final expense in controller.expenses)
            ExpenseTile(
              expense: expense,
              controller: controller,
              actions: true,
              onEdit: () => onEdit(expense),
            ),
        ],
      ),
    ),
  );
}
