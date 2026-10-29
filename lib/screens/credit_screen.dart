import 'package:flutter/material.dart';

import '../controllers/credit_controller.dart';
import '../controllers/expense_controller.dart';
import '../data/credit_database.dart';
import '../models/credit.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../widgets/credit_form.dart';
import '../widgets/credit_list.dart';
import '../widgets/error_state.dart';

class CreditScreen extends StatefulWidget {
  const CreditScreen({super.key, required this.expenses});
  final ExpenseController expenses;

  @override
  State<CreditScreen> createState() => _CreditScreenState();
}

class _CreditScreenState extends State<CreditScreen> {
  late final _controller = CreditController(
    CreditDatabase(widget.expenses.database),
    widget.expenses,
  )..load();
  Credit? _editing;
  final _scroll = ScrollController();

  void _edit(Credit credit) {
    setState(() => _editing = credit);
    _scroll.animateTo(
      0,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: _controller,
    builder: (context, child) {
      if (!_controller.loaded) {
        return Center(
          child: _controller.busy
              ? const CircularProgressIndicator()
              : ErrorState(
                  _controller.error ?? 'Could not load payment plans.',
                  onRetry: _controller.load,
                ),
        );
      }
      return RefreshIndicator(
        onRefresh: () async {
          await _controller.load();
        },
        child: ListView(
          controller: _scroll,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.page),
          children: [
            const Text(
              'Plan upcoming payments. Mark paid after paying to '
              'record an expense.',
              style: TextStyle(color: AppColors.muted),
            ),
            const SizedBox(height: 20),
            CreditForm(
              key: ValueKey(_editing?.id ?? 'new-credit'),
              controller: _controller,
              credit: _editing,
              onFinished: () => setState(() => _editing = null),
            ),
            const SizedBox(height: 28),
            CreditList(controller: _controller, onEdit: _edit),
          ],
        ),
      );
    },
  );
}
