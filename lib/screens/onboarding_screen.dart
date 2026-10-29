import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/primary_button.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key, required this.onStarted});
  final VoidCallback onStarted;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => Column(
      children: [
        Expanded(
          flex: 7,
          child: SizedBox(
            width: double.infinity,
            child: Image.asset(
              'assets/images/onboarding.png',
              fit: BoxFit.cover,
              alignment: Alignment.bottomCenter,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: SafeArea(
            top: false,
            minimum: const EdgeInsets.fromLTRB(26, 12, 26, 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Spend Smarter\nSave More',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 34,
                        height: 1.04,
                        fontWeight: FontWeight.w800,
                        color: AppColors.navigation,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                PrimaryButton('Get Started', onPressed: onStarted),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
