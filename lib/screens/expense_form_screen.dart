import 'package:flutter/material.dart';

import '../controllers/expense_controller.dart';
import '../controllers/expense_form_controller.dart';
import '../models/expense.dart';
import '../widgets/app_header.dart';
import '../widgets/expense_form_fields.dart';
import '../widgets/form_layout.dart';
import '../widgets/primary_button.dart';

class ExpenseFormScreen extends StatefulWidget {
  const ExpenseFormScreen({super.key, required this.controller, this.expense});
  final ExpenseController controller;
  final Expense? expense;

  @override
  State<ExpenseFormScreen> createState() => _ExpenseFormScreenState();
}

class _ExpenseFormScreenState extends State<ExpenseFormScreen> {
  final _key = GlobalKey<FormState>();
  late final _draft = ExpenseFormController(widget.expense);

  Future<void> _save() async {
    if (widget.controller.saving || !_key.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final saved = await widget.controller.save(_draft.toExpense());
    if (!mounted) return;
    if (saved) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.controller.error ?? 'Please wait and try again.',
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _draft.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.controller,
    builder: (context, child) => PopScope(
      canPop: !widget.controller.saving,
      child: Scaffold(
        appBar: AppHeader(
          widget.expense == null ? 'Transaction' : 'Edit Transaction',
          back: !widget.controller.saving,
        ),
        body: SafeArea(
          top: false,
          child: FormLayout(
            fields: AbsorbPointer(
              absorbing: widget.controller.saving,
              child: Form(
                key: _key,
                child: ExpenseFormFields(draft: _draft),
              ),
            ),
            footer: PrimaryButton(
              'Save',
              onPressed: widget.controller.loaded ? _save : null,
              busy: widget.controller.saving,
            ),
          ),
        ),
      ),
    ),
  );
}
