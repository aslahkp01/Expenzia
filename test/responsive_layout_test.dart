import 'package:expenzia/screens/onboarding_screen.dart';
import 'package:expenzia/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/widget_harness.dart';

void main() {
  for (final size in [const Size(320, 640), const Size(393, 852)]) {
    testWidgets('screens and keyboard fit ${size.width} wide', (tester) async {
      final harness = await WidgetHarness.mount(
        tester,
        size: size,
        seeded: true,
      );
      for (final tab in ['History', 'Credit', 'Profile', 'Home']) {
        await tester.tap(find.byTooltip(tab));
        await harness.settleDatabase(tester);
        expect(tester.takeException(), isNull, reason: tab);
      }
      await tester.tap(find.byTooltip('Add expense'));
      await tester.pumpAndSettle();
      tester.view.viewInsets = const FakeViewPadding(bottom: 280);
      addTearDown(tester.view.resetViewInsets);
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Save'));
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('onboarding fits a small screen with larger text', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 640);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(
      MaterialApp(
        theme: appTheme(),
        home: MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(1.5)),
          child: Scaffold(body: OnboardingScreen(onStarted: () {})),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Get Started'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
