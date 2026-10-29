import 'package:flutter/material.dart';

import 'labeled_field.dart';

class SelectionField<T> extends StatelessWidget {
  const SelectionField(
    this.label, {
    super.key,
    required this.value,
    required this.values,
    required this.text,
    required this.onChanged,
  });
  final String label;
  final T value;
  final List<T> values;
  final String Function(T) text;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) => LabeledField(
    label,
    child: DropdownButtonFormField<T>(
      key: ValueKey('$label-$value'),
      initialValue: value,
      isExpanded: true,
      icon: const Icon(Icons.keyboard_arrow_down),
      items: values
          .map(
            (item) => DropdownMenuItem<T>(value: item, child: Text(text(item))),
          )
          .toList(),
      onChanged: (value) {
        if (value != null) onChanged(value);
      },
    ),
  );
}
