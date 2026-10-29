import 'package:flutter/material.dart';

import '../controllers/credit_controller.dart';
import '../models/credit.dart';
import '../utils/formatters.dart';

Future<void> confirmCreditAction(
  BuildContext context,
  CreditController controller,
  Credit credit, {
  required bool pay,
}) async {
  if (controller.busy) return;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(pay ? 'Record payment?' : 'Delete payment plan?'),
      content: Text(
        pay
            ? 'Record ${formatMoney(credit.amountPaise)} paid to ${credit.recipient} '
                  'for ${formatDate(credit.dueDate)}? This adds an expense.'
            : 'Delete ${credit.recipient}? Recorded expenses stay in your history.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(pay ? 'Mark paid' : 'Delete'),
        ),
      ],
    ),
  );
  if (!context.mounted || confirmed != true) return;
  final success = pay
      ? await controller.pay(credit)
      : await controller.delete(credit);
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        success
            ? (pay
                  ? 'Payment recorded as an expense.'
                  : 'Payment plan deleted.')
            : controller.error ?? 'Please wait and try again.',
      ),
    ),
  );
}
