import 'package:flutter_test/flutter_test.dart';

import 'support/widget_harness.dart';

void main() {
  testWidgets('deletion requires confirmation and updates the dashboard', (
    tester,
  ) async {
    final harness = await WidgetHarness.mount(tester, seeded: true);
    await tester.tap(find.byTooltip('History'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Expense actions'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(harness.controller.expenses.length, 1);
    await tester.tap(find.byTooltip('Expense actions'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await harness.finishWrites(tester);
    expect(find.text('No expenses yet'), findsOneWidget);
    await tester.tap(find.byTooltip('Home'));
    await tester.pumpAndSettle();
    expect(harness.controller.totalPaise, 0);
    expect(find.text('₹ 0.00'), findsNWidgets(3));
    expect(tester.takeException(), isNull);
  });
}
