import 'package:flutter/material.dart';

import '../controllers/expense_form_controller.dart';
import '../theme/app_spacing.dart';
import '../utils/validators.dart';
import 'amount_field.dart';
import 'category_field.dart';
import 'date_field.dart';
import 'labeled_field.dart';

class ExpenseFormFields extends StatelessWidget {
  const ExpenseFormFields({super.key, required this.draft});
  final ExpenseFormController draft;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: draft,
    builder: (context, child) => Column(
      children: [
        LabeledField(
          'TRANSACTION TYPE',
          child: DropdownButtonFormField<String>(
            key: const ValueKey('transaction_type'),
            initialValue: draft.type,
            isExpanded: true,
            icon: const Icon(Icons.keyboard_arrow_down),
            items: const [
              DropdownMenuItem(value: 'expense', child: Text('Expense')),
              DropdownMenuItem(value: 'income', child: Text('Income')),
            ],
            onChanged: (val) {
              if (val != null) draft.setType(val);
            },
          ),
        ),
        const SizedBox(height: AppSpacing.fieldGap),
        LabeledField(
          'NAME',
          child: TextFormField(
            key: const ValueKey('title'),
            controller: draft.title,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            validator: validateRequired,
            decoration: InputDecoration(
              hintText: draft.isIncome ? 'Income source' : 'Expense title',
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.fieldGap),
        AmountField(controller: draft.amount),
        const SizedBox(height: AppSpacing.fieldGap),
        CategoryField(
          value: draft.category,
          onChanged: draft.setCategory,
          isIncome: draft.isIncome,
        ),
        const SizedBox(height: AppSpacing.fieldGap),
        DateField(date: draft.date, onChanged: draft.setDate),
        const SizedBox(height: AppSpacing.fieldGap),
        LabeledField(
          'DESCRIPTION (OPTIONAL)',
          child: TextFormField(
            key: const ValueKey('description'),
            controller: draft.description,
            minLines: 2,
            maxLines: 4,
            decoration: const InputDecoration(hintText: 'Add a note'),
          ),
        ),
      ],
    ),
  );
}
