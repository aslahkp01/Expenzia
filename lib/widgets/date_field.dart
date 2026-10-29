import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../utils/formatters.dart';
import 'labeled_field.dart';

class DateField extends StatelessWidget {
  const DateField({
    super.key,
    required this.date,
    required this.onChanged,
    this.enabled = true,
    this.label = 'DATE',
  });
  final DateTime date;
  final ValueChanged<DateTime> onChanged;
  final bool enabled;
  final String label;

  Future<void> _pick(BuildContext context) async {
    final value = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100, 12, 31),
    );
    if (!context.mounted || value == null) return;
    onChanged(value);
  }

  @override
  Widget build(BuildContext context) => LabeledField(
    label,
    child: Semantics(
      button: true,
      label: 'Choose date, ${formatDate(date)}',
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: enabled ? () => _pick(context) : null,
        child: InputDecorator(
          decoration: const InputDecoration(
            suffixIcon: Icon(Icons.calendar_month, size: 20),
          ),
          child: Text(
            formatDate(date),
            style: const TextStyle(color: AppColors.muted),
          ),
        ),
      ),
    ),
  );
}
