import 'package:flutter/material.dart';

import '../utils/validators.dart';
import 'labeled_field.dart';

const expenseCategories = [
  'Food',
  'Transport',
  'Shopping',
  'Bills',
  'Subscriptions',
  'Health',
  'Entertainment',
  'Other',
];

const incomeCategories = [
  'Salary',
  'Freelance',
  'Business',
  'Investments',
  'Gift',
  'Other',
];

class CategoryField extends StatelessWidget {
  const CategoryField({
    super.key,
    required this.value,
    required this.onChanged,
    this.isIncome = false,
  });
  final String? value;
  final ValueChanged<String?> onChanged;
  final bool isIncome;

  @override
  Widget build(BuildContext context) {
    final list = isIncome ? incomeCategories : expenseCategories;
    return LabeledField(
      'CATEGORY',
      child: DropdownButtonFormField<String>(
        key: const ValueKey('category'),
        initialValue: value,
        hint: const Text('Select a category'),
        isExpanded: true,
        icon: const Icon(Icons.keyboard_arrow_down),
        validator: validateRequired,
        items: {...list, if (value != null) value!}
            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
