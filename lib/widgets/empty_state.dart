import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 38),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.receipt_long_outlined,
          size: 42,
          color: AppColors.navigation,
        ),
        SizedBox(height: 12),
        Text('No expenses yet', style: TextStyle(fontWeight: FontWeight.w600)),
        SizedBox(height: 6),
        Text(
          'Tap + to add your first expense.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.muted),
        ),
      ],
    ),
  );
}
