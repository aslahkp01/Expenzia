import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/widget_harness.dart';

void main() {
  testWidgets('invalid forms stay open and valid add/edit persists once', (
    tester,
  ) async {
    final harness = await WidgetHarness.mount(tester);
    await tester.tap(find.byTooltip('Add expense'));
    await tester.pumpAndSettle();
    await harness.saveForm(tester);
    expect(find.text('This field is required'), findsNWidgets(2));
    expect(find.text('Enter an amount'), findsOneWidget);
    await tester.enterText(find.byKey(const ValueKey('title')), 'Groceries');
    await tester.enterText(find.byKey(const ValueKey('amount')), '12.345');
    await harness.saveForm(tester);
    expect(
      find.text('Enter a positive amount with up to 2 decimal places'),
      findsOneWidget,
    );
    await tester.enterText(find.byKey(const ValueKey('amount')), '123.45');
    final category = find.byKey(const ValueKey('category'));
    await tester.ensureVisible(category);
    await tester.tap(category);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Food').last);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('description')),
      'Weekly food',
    );
    await harness.saveForm(tester);
    expect(find.text('Groceries'), findsOneWidget);
    expect(harness.controller.totalPaise, 12345);
    final originalId = harness.controller.expenses.single.id;
    await tester.tap(find.text('Groceries'));
    await tester.pumpAndSettle();
    expect(find.text('Edit Transaction'), findsOneWidget);
    await tester.enterText(find.byKey(const ValueKey('amount')), '99.01');
    await harness.saveForm(tester);
    expect(harness.controller.expenses.single.id, originalId);
    expect(harness.controller.totalPaise, 9901);
    await tester.runAsync(() async {
      await harness.fixture.database.close();
      final saved = (await harness.fixture.database.all()).single;
      expect(saved.amountPaise, 9901);
      expect(saved.description, 'Weekly food');
    });
    expect(tester.takeException(), isNull);
  });
}
