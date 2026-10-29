import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../utils/amount_parser.dart';
import 'labeled_field.dart';

class AmountField extends StatelessWidget {
  const AmountField({super.key, required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) => LabeledField(
    'AMOUNT',
    child: TextFormField(
      key: const ValueKey('amount'),
      controller: controller,
      validator: validateAmount,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: const TextStyle(
        color: AppColors.teal,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        prefixText: '₹ ',
        hintText: '0.00',
        suffixIcon: TextButton(
          onPressed: controller.clear,
          child: const Text('Clear'),
        ),
      ),
    ),
  );
}
