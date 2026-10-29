import 'package:flutter/material.dart';

import '../controllers/credit_form_controller.dart';
import '../models/credit.dart';
import '../theme/app_spacing.dart';
import '../utils/validators.dart';
import 'amount_field.dart';
import 'date_field.dart';
import 'labeled_field.dart';
import 'selection_field.dart';

class CreditFormFields extends StatelessWidget {
  const CreditFormFields({super.key, required this.draft});
  final CreditFormController draft;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: draft,
    builder: (context, child) => Column(
      children: [
        SelectionField<String>(
          'CREDIT TYPE',
          value: draft.type,
          values: creditTypes,
          text: (value) => value,
          onChanged: draft.setType,
        ),
        const SizedBox(height: AppSpacing.fieldGap),
        LabeledField(
          'TO',
          child: TextFormField(
            key: const ValueKey('credit-recipient'),
            controller: draft.recipient,
            validator: validateRequired,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(hintText: 'e.g. Netflix'),
          ),
        ),
        const SizedBox(height: AppSpacing.fieldGap),
        AmountField(controller: draft.amount),
        const SizedBox(height: AppSpacing.fieldGap),
        DateField(
          date: draft.date,
          onChanged: draft.setDate,
          label: 'DUE DATE',
        ),
        const SizedBox(height: AppSpacing.fieldGap),
        SelectionField<CreditPlan>(
          'PLAN TYPE',
          value: draft.plan,
          values: CreditPlan.values,
          text: (value) => value.label,
          onChanged: draft.setPlan,
        ),
      ],
    ),
  );
}
