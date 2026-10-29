import 'package:flutter/material.dart';

import '../controllers/expense_controller.dart';
import '../controllers/profile_controller.dart';
import '../widgets/clear_expenses_button.dart';
import '../widgets/error_state.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/profile_name_dialog.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
    required this.controller,
    required this.profile,
  });
  final ExpenseController controller;
  final ProfileController profile;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: constraints.maxHeight),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const ProfileAvatar(),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      profile.name,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Edit name',
                    onPressed: () => showDialog<void>(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => ProfileNameDialog(profile: profile),
                    ),
                    icon: const Icon(Icons.edit, size: 16, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClearExpensesButton(controller: controller),
              if (profile.error != null)
                ErrorState(profile.error!, onRetry: profile.load),
            ],
          ),
        ),
      ),
    ),
  );
}
