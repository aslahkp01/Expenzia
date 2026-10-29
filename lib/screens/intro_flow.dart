import 'package:flutter/material.dart';

import '../controllers/expense_controller.dart';
import '../controllers/profile_controller.dart';
import 'app_shell.dart';
import 'onboarding_screen.dart';
import 'splash_screen.dart';

class IntroFlow extends StatefulWidget {
  const IntroFlow({super.key, required this.controller, required this.profile});
  final ExpenseController controller;
  final ProfileController profile;

  @override
  State<IntroFlow> createState() => _IntroFlowState();
}

class _IntroFlowState extends State<IntroFlow> {
  int _stage = 0;

  @override
  Widget build(BuildContext context) => switch (_stage) {
    0 => Scaffold(
      body: SplashScreen(onFinished: () => setState(() => _stage = 1)),
    ),
    1 => Scaffold(
      body: OnboardingScreen(onStarted: () => setState(() => _stage = 2)),
    ),
    _ => AppShell(controller: widget.controller, profile: widget.profile),
  };
}
