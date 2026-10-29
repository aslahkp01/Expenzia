import 'package:expenzia/data/credit_database.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/credit_widget_helpers.dart';
import 'support/widget_harness.dart';

void main() {
  testWidgets('Mark paid requires confirmation and updates dashboard totals', (
    tester,
  ) async {
    final harness = await WidgetHarness.mount(tester);
    await openCredit(tester, harness);
    await fillCredit(tester);
    await submitCredit(tester, harness);
    final pay = find.text('Mark paid');
    await tester.ensureVisible(pay);
    await tester.pumpAndSettle();
    await tester.tap(pay);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(harness.controller.totalPaise, 0);
    await tester.tap(pay);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mark paid').last);
    await harness.settleDatabase(tester);
    expect(harness.controller.totalPaise, 85000);
    await tester.runAsync(() async {
      final plan = (await CreditDatabase(
        harness.fixture.database,
      ).all()).single;
      expect(plan.paidAt, isNotNull);
      expect(plan.dueDate.isAfter(DateTime.now()), isTrue);
    });
    await creditMenu(tester, 'Delete');
    await tester.tap(find.text('Delete').last);
    await harness.settleDatabase(tester);
    expect(find.text('No payment plans yet.'), findsOneWidget);
    expect(harness.controller.totalPaise, 85000);
    await tester.tap(find.byTooltip('Home'));
    await tester.pumpAndSettle();
    expect(find.text('Netflix'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
