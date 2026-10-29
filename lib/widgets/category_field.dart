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

class CategoryField extends StatelessWidget {
  const CategoryField({
    super.key,
    required this.value,
    required this.onChanged,
  });
  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) => LabeledField(
    'CATEGORY',
    child: DropdownButtonFormField<String>(
      key: const ValueKey('category'),
      initialValue: value,
      hint: const Text('Select a category'),
      isExpanded: true,
      icon: const Icon(Icons.keyboard_arrow_down),
      validator: validateRequired,
      items: {...expenseCategories, if (value != null) value!}
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: onChanged,
    ),
  );
}
