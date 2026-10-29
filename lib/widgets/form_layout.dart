import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

class FormLayout extends StatelessWidget {
  const FormLayout({super.key, required this.fields, required this.footer});
  final Widget fields;
  final Widget footer;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.all(AppSpacing.page),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: (constraints.maxHeight - AppSpacing.page * 2).clamp(
            0,
            double.infinity,
          ),
        ),
        child: IntrinsicHeight(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 19,
                  vertical: 28,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: .045),
                      blurRadius: 26,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: fields,
              ),
              const SizedBox(height: 30),
              const Spacer(),
              footer,
            ],
          ),
        ),
      ),
    ),
  );
}
