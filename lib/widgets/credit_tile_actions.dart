import 'package:flutter/material.dart';

import '../controllers/credit_controller.dart';
import '../models/credit.dart';
import 'credit_actions.dart';

class CreditTileActions extends StatelessWidget {
  const CreditTileActions({
    super.key,
    required this.credit,
    required this.controller,
    required this.onEdit,
  });
  final Credit credit;
  final CreditController controller;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      if (!credit.isPaid)
        TextButton(
          onPressed:
              controller.busy ||
                  controller.expenses.saving ||
                  !controller.expenses.loaded
              ? null
              : () =>
                    confirmCreditAction(context, controller, credit, pay: true),
          child: const Text('Mark paid'),
        ),
      PopupMenuButton<String>(
        tooltip: 'Payment plan actions',
        enabled: !controller.busy,
        onSelected: (action) => action == 'edit'
            ? onEdit()
            : confirmCreditAction(context, controller, credit, pay: false),
        itemBuilder: (context) => const [
          PopupMenuItem(value: 'edit', child: Text('Edit')),
          PopupMenuItem(value: 'delete', child: Text('Delete')),
        ],
      ),
    ],
  );
}
