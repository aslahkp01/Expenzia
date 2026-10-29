import 'package:flutter/material.dart';

import '../controllers/expense_controller.dart';
import '../models/expense.dart';
import '../theme/app_colors.dart';
import '../utils/formatters.dart';
import 'delete_expense_button.dart';

class ExpenseTile extends StatelessWidget {
  const ExpenseTile({
    super.key,
    required this.expense,
    required this.onEdit,
    required this.controller,
    this.actions = false,
  });
  final Expense expense;
  final VoidCallback onEdit;
  final ExpenseController controller;
  final bool actions;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: controller.saving ? null : onEdit,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expense.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${transactionDate(expense.date)} · ${expense.category}',
                  style: const TextStyle(fontSize: 12, color: AppColors.muted),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '- ${formatMoney(expense.amountPaise)}',
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: AppColors.expense,
            ),
          ),
          if (actions)
            PopupMenuButton<String>(
              tooltip: 'Expense actions',
              enabled: !controller.saving,
              onSelected: (value) {
                if (value == 'edit') {
                  onEdit();
                } else {
                  deleteExpense(context, controller, expense);
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'edit', child: Text('Edit')),
                PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
            ),
        ],
      ),
    ),
  );
}
