import 'package:flutter/material.dart';

import '../controllers/expense_controller.dart';
import '../models/expense.dart';
import '../models/expense_summary.dart';
import '../theme/app_spacing.dart';
import '../widgets/balance_card.dart';
import '../widgets/expense_content.dart';
import '../widgets/recent_expenses.dart';
import '../widgets/summary_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.controller,
    required this.name,
    required this.onSeeAll,
    required this.onEdit,
  });
  final ExpenseController controller;
  final String name;
  final VoidCallback onSeeAll;
  final ValueChanged<Expense> onEdit;

  @override
  Widget build(BuildContext context) {
    final summary = ExpenseSummary(controller.expenses);
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'morning'
        : hour < 17
        ? 'afternoon'
        : 'evening';
    return ExpenseContent(
      controller: controller,
      child: RefreshIndicator(
        onRefresh: controller.load,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.page,
            20,
            AppSpacing.page,
            36,
          ),
          children: [
            Text('Good $greeting,'),
            const SizedBox(height: 3),
            Text(name, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 20),
            BalanceCard(
              totalPaise: summary.totalPaise,
              count: controller.expenses.length,
            ),
            const SizedBox(height: 34),
            Row(
              children: [
                Expanded(
                  child: SummaryCard(
                    'DAILY AVERAGE',
                    summary.dailyAveragePaise,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(child: SummaryCard('WEEKLY', summary.weeklyPaise)),
              ],
            ),
            const SizedBox(height: 24),
            RecentExpenses(
              controller: controller,
              onSeeAll: onSeeAll,
              onEdit: onEdit,
            ),
          ],
        ),
      ),
    );
  }
}
