import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../widgets/credit_preview_form.dart';

class CreditScreen extends StatelessWidget {
  const CreditScreen({super.key});

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(AppSpacing.page),
    children: [
      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.pale,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Text(
          'Credit preview · Saving is unavailable until credit amounts, '
          'repayments, and recurring plans are defined.',
          style: TextStyle(color: AppColors.teal),
        ),
      ),
      const SizedBox(height: 20),
      const CreditPreviewForm(),
      const SizedBox(height: 28),
      Text('Your Saved Lists', style: Theme.of(context).textTheme.titleMedium),
      const SizedBox(height: 16),
      const Text(
        'No credit entries.',
        style: TextStyle(color: AppColors.muted),
      ),
    ],
  );
}
