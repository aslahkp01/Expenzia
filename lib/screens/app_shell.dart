import 'package:flutter/material.dart';

import '../controllers/expense_controller.dart';
import '../controllers/profile_controller.dart';
import '../models/expense.dart';
import '../theme/app_colors.dart';
import '../widgets/app_bottom_navigation.dart';
import '../widgets/app_header.dart';
import 'credit_screen.dart';
import 'expense_form_screen.dart';
import 'history_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.controller, required this.profile});
  final ExpenseController controller;
  final ProfileController profile;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _tab = 0;

  void _openForm([Expense? expense]) => Navigator.of(context).push<void>(
    MaterialPageRoute(
      builder: (context) =>
          ExpenseFormScreen(controller: widget.controller, expense: expense),
    ),
  );

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: Listenable.merge([widget.controller, widget.profile]),
    builder: (context, child) {
      final pages = [
        HomeScreen(
          controller: widget.controller,
          name: widget.profile.name,
          onSeeAll: () => setState(() => _tab = 1),
          onEdit: _openForm,
        ),
        HistoryScreen(controller: widget.controller, onEdit: _openForm),
        const CreditScreen(),
        ProfileScreen(controller: widget.controller, profile: widget.profile),
      ];
      const titles = ['', 'Transaction History', 'Credit', 'Profile'];
      return PopScope(
        canPop: _tab == 0,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) setState(() => _tab = 0);
        },
        child: Scaffold(
          appBar: _tab == 0
              ? null
              : AppHeader(
                  titles[_tab],
                  onBack: _tab == 3 ? () => setState(() => _tab = 0) : null,
                ),
          body: SafeArea(top: _tab == 0, bottom: false, child: pages[_tab]),
          bottomNavigationBar: AppBottomNavigation(
            selected: _tab,
            onSelected: (index) => setState(() => _tab = index),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: SizedBox(
            width: 72,
            height: 72,
            child: FloatingActionButton(
              tooltip: 'Add expense',
              onPressed: widget.controller.loaded && !widget.controller.saving
                  ? () => _openForm()
                  : null,
              shape: const CircleBorder(),
              elevation: 0,
              backgroundColor: AppColors.navigation,
              foregroundColor: Colors.white,
              child: const Icon(Icons.add, size: 34),
            ),
          ),
        ),
      );
    },
  );
}
