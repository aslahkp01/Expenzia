import 'package:flutter/material.dart';

import 'labeled_field.dart';

class CreditPreviewForm extends StatelessWidget {
  const CreditPreviewForm({super.key});

  Widget _field(String label, String value, IconData? icon) => LabeledField(
    label,
    child: InputDecorator(
      decoration: InputDecoration(
        suffixIcon: icon == null ? null : Icon(icon, size: 20),
      ),
      child: Text(value),
    ),
  );

  @override
  Widget build(BuildContext context) => Column(
    children: [
      _field('CREDIT TYPE', 'Subscriptions', Icons.keyboard_arrow_down),
      const SizedBox(height: 18),
      _field('TO', 'Recipient', null),
      const SizedBox(height: 18),
      _field('DATE', 'Choose a due date', Icons.calendar_month),
      const SizedBox(height: 18),
      _field('PLAN TYPE', 'Monthly', Icons.keyboard_arrow_down),
      const SizedBox(height: 18),
      const ElevatedButton(onPressed: null, child: Text('Save')),
    ],
  );
}
