import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class LabeledField extends StatelessWidget {
  const LabeledField(this.label, {super.key, required this.child});
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          fontSize: 11.5,
          color: AppColors.muted,
          letterSpacing: .8,
          fontWeight: FontWeight.w500,
        ),
      ),
      const SizedBox(height: 8),
      child,
    ],
  );
}
