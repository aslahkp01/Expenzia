import 'package:flutter/material.dart';

import '../controllers/credit_controller.dart';
import '../models/credit.dart';
import '../theme/app_colors.dart';
import '../utils/formatters.dart';
import 'credit_tile_actions.dart';

class CreditTile extends StatelessWidget {
  const CreditTile({
    super.key,
    required this.credit,
    required this.controller,
    required this.onEdit,
  });
  final Credit credit;
  final CreditController controller;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final overdue = !credit.isPaid && credit.dueDate.isBefore(today);
    final due = credit.dueDate == today ? 'Today' : formatDate(credit.dueDate);
    final status = credit.isPaid
        ? 'Paid'
        : '${overdue ? 'Overdue' : 'Due'} $due';
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  credit.recipient,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                formatMoney(credit.amountPaise),
                textAlign: TextAlign.right,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 7),
          Row(
            children: [
              Expanded(
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 12,
                    color: overdue ? AppColors.expense : AppColors.muted,
                  ),
                ),
              ),
              Text(
                credit.plan.label,
                style: const TextStyle(fontSize: 12, color: AppColors.muted),
              ),
            ],
          ),
          CreditTileActions(
            credit: credit,
            controller: controller,
            onEdit: onEdit,
          ),
        ],
      ),
    );
  }
}
