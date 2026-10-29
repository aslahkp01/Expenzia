import 'package:flutter/material.dart';

import '../controllers/credit_controller.dart';
import '../controllers/credit_form_controller.dart';
import '../models/credit.dart';
import 'credit_form_fields.dart';
import 'primary_button.dart';

class CreditForm extends StatefulWidget {
  const CreditForm({
    super.key,
    required this.controller,
    required this.onFinished,
    this.credit,
  });
  final CreditController controller;
  final Credit? credit;
  final VoidCallback onFinished;

  @override
  State<CreditForm> createState() => _CreditFormState();
}

class _CreditFormState extends State<CreditForm> {
  final _key = GlobalKey<FormState>();
  late final _draft = CreditFormController(widget.credit);

  Future<void> _save() async {
    if (widget.controller.busy || !_key.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final saved = await widget.controller.save(_draft.toCredit());
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          saved
              ? 'Payment plan saved.'
              : widget.controller.error ?? 'Could not save payment plan.',
        ),
      ),
    );
    if (saved) {
      _key.currentState!.reset();
      _draft.reset();
      widget.onFinished();
    }
  }

  @override
  void dispose() {
    _draft.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Form(
    key: _key,
    child: Column(
      children: [
        AbsorbPointer(
          absorbing: widget.controller.busy,
          child: CreditFormFields(draft: _draft),
        ),
        const SizedBox(height: 20),
        PrimaryButton(
          widget.credit == null ? 'Save' : 'Update',
          onPressed: _save,
          busy: widget.controller.busy,
        ),
        if (widget.credit != null)
          TextButton(
            onPressed: widget.controller.busy ? null : widget.onFinished,
            child: const Text('Cancel editing'),
          ),
      ],
    ),
  );
}
