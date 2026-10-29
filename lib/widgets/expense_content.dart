import 'package:flutter/material.dart';

import '../controllers/expense_controller.dart';
import 'error_state.dart';

class ExpenseContent extends StatelessWidget {
  const ExpenseContent({
    super.key,
    required this.controller,
    required this.child,
  });
  final ExpenseController controller;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (controller.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (!controller.loaded) {
      return Center(
        child: ErrorState(
          controller.error ?? 'Expenses are not available.',
          onRetry: controller.load,
        ),
      );
    }
    return child;
  }
}
