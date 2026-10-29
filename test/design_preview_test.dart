import 'package:expenzia/screens/onboarding_screen.dart';
import 'package:expenzia/screens/splash_screen.dart';
import 'package:expenzia/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/capture_preview.dart';
import 'support/widget_harness.dart';

void main() {
  testWidgets('capture all eight screen previews', (tester) async {
    await loadPreviewFonts(tester);
    await WidgetHarness.mount(tester, seeded: true);
    await capturePreview(tester, '03-home');
    for (final item in {
      'History': '05-history',
      'Credit': '07-credit',
      'Profile': '08-profile',
    }.entries) {
      await tester.tap(find.byTooltip(item.key));
      await capturePreview(tester, item.value);
    }
    await tester.tap(find.byTooltip('Add expense'));
    await capturePreview(tester, '04-add-expense');
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('History'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Lunch'));
    await capturePreview(tester, '06-edit-expense');
    for (final item in <String, Widget>{
      '01-splash': SplashScreen(onFinished: () {}),
      '02-onboarding': OnboardingScreen(onStarted: () {}),
    }.entries) {
      await tester.pumpWidget(
        RepaintBoundary(
          key: const ValueKey('preview'),
          child: MaterialApp(
            key: ValueKey(item.key),
            debugShowCheckedModeBanner: false,
            theme: appTheme(),
            home: Scaffold(body: item.value),
          ),
        ),
      );
      await capturePreview(tester, item.key);
    }
    expect(tester.takeException(), isNull);
  }, skip: !const bool.fromEnvironment('CAPTURE_PREVIEWS'));
}
