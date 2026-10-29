import 'package:expenzia/data/credit_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/credit_widget_helpers.dart';
import 'support/widget_harness.dart';

void main() {
  testWidgets(
    'Credit validates, saves, edits, and survives reentering the tab',
    (tester) async {
      final harness = await WidgetHarness.mount(tester);
      final database = CreditDatabase(harness.fixture.database);
      await openCredit(tester, harness);
      await submitCredit(tester, harness);
      expect(find.text('This field is required'), findsOneWidget);
      expect(find.text('Enter an amount'), findsOneWidget);
      await fillCredit(tester, amount: '1.234');
      await submitCredit(tester, harness);
      expect(
        find.text('Enter a positive amount with up to 2 decimal places'),
        findsOneWidget,
      );
      await fillCredit(tester);
      await submitCredit(tester, harness);
      expect(find.text('Netflix'), findsOneWidget);
      expect(harness.controller.totalPaise, 0);
      await creditMenu(tester, 'Edit');
      await fillCredit(tester, name: 'Netflix Premium', amount: '999.00');
      await submitCredit(tester, harness, label: 'Update');
      await tester.runAsync(() async {
        final plan = (await database.all()).single;
        expect(plan.recipient, 'Netflix Premium');
        expect(plan.amountPaise, 99900);
      });
      await tester.tap(find.byTooltip('Home'));
      await tester.pumpAndSettle();
      await openCredit(tester, harness);
      expect(find.text('Netflix Premium'), findsOneWidget);
      await creditMenu(tester, 'Delete');
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(find.text('Netflix Premium'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Credit form remains scrollable with a keyboard on small phones',
    (tester) async {
      final harness = await WidgetHarness.mount(
        tester,
        size: const Size(320, 640),
      );
      await openCredit(tester, harness);
      tester.view.viewInsets = const FakeViewPadding(bottom: 280);
      addTearDown(tester.view.resetViewInsets);
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Save'));
      expect(tester.takeException(), isNull);
    },
  );
}
