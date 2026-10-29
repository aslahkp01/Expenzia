import 'package:expenzia/controllers/expense_controller.dart';
import 'package:expenzia/controllers/profile_controller.dart';
import 'package:expenzia/data/profile_database.dart';
import 'package:expenzia/screens/app_shell.dart';
import 'package:expenzia/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_database.dart';

class WidgetHarness {
  WidgetHarness(this.fixture, this.controller, this.profile);
  final TestDatabase fixture;
  final ExpenseController controller;
  final ProfileController profile;

  static Future<WidgetHarness> mount(
    WidgetTester tester, {
    Size size = const Size(393, 852),
    bool seeded = false,
  }) async {
    late WidgetHarness harness;
    await tester.runAsync(() async {
      final fixture = await TestDatabase.create();
      if (seeded) await fixture.database.save(exampleExpense());
      final controller = ExpenseController(fixture.database);
      final profile = ProfileController(ProfileDatabase(fixture.database));
      await controller.load();
      await profile.load();
      harness = WidgetHarness(fixture, controller, profile);
    });
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = size;
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(
      RepaintBoundary(
        key: const ValueKey('preview'),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: appTheme(),
          home: AppShell(
            controller: harness.controller,
            profile: harness.profile,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox.shrink());
      harness.controller.dispose();
      harness.profile.dispose();
      await harness.fixture.dispose();
    });
    return harness;
  }

  Future<void> finishWrites(WidgetTester tester) async {
    await tester.runAsync(() async {
      final timer = Stopwatch()..start();
      while (controller.saving || profile.saving) {
        if (timer.elapsed > const Duration(seconds: 5)) {
          throw StateError('Database write did not complete.');
        }
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }
    });
    await tester.pumpAndSettle();
  }

  Future<void> saveForm(WidgetTester tester) async {
    tester.testTextInput.hide();
    await tester.pump();
    final save = find.widgetWithText(ElevatedButton, 'Save');
    await tester.ensureVisible(save);
    await tester.tap(save);
    await finishWrites(tester);
  }
}
