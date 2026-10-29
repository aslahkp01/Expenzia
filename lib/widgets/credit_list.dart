import 'package:flutter/material.dart';

import '../controllers/credit_controller.dart';
import '../models/credit.dart';
import '../theme/app_colors.dart';
import 'credit_tile.dart';
import 'error_state.dart';

class CreditList extends StatelessWidget {
  const CreditList({super.key, required this.controller, required this.onEdit});
  final CreditController controller;
  final ValueChanged<Credit> onEdit;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Your Saved Lists',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      if (controller.error != null)
        ErrorState(controller.error!, onRetry: controller.load),
      if (controller.credits.isEmpty)
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Text(
            'No payment plans yet.',
            style: TextStyle(color: AppColors.muted),
          ),
        ),
      for (final credit in controller.credits)
        CreditTile(
          credit: credit,
          controller: controller,
          onEdit: () => onEdit(credit),
        ),
    ],
  );
}
