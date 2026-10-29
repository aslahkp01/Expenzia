import 'package:flutter/material.dart';

import '../controllers/expense_controller.dart';
import '../theme/app_colors.dart';

class ClearExpensesButton extends StatelessWidget {
  const ClearExpensesButton({super.key, required this.controller});
  final ExpenseController controller;

  Future<void> _clear(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear storage?'),
        content: const Text('Permanently delete every saved expense?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
    if (!context.mounted || confirmed != true) return;
    final cleared = await controller.clear();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          cleared
              ? 'Expenses cleared.'
              : controller.error ?? 'Could not clear expenses.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => OutlinedButton(
    onPressed: controller.loaded && !controller.saving
        ? () => _clear(context)
        : null,
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.muted,
      side: const BorderSide(color: AppColors.border),
    ),
    child: const Text('Clear Storage'),
  );
}
