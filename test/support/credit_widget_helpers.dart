import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'widget_harness.dart';

Future<void> openCredit(WidgetTester tester, WidgetHarness harness) async {
  await tester.tap(find.byTooltip('Credit'));
  await harness.settleDatabase(tester);
}

Future<void> fillCredit(
  WidgetTester tester, {
  String name = 'Netflix',
  String amount = '850.00',
}) async {
  final recipient = find.byKey(const ValueKey('credit-recipient'));
  await tester.ensureVisible(recipient);
  await tester.pumpAndSettle();
  await tester.enterText(recipient, name);
  final amountField = find.byKey(const ValueKey('amount'));
  await tester.ensureVisible(amountField);
  await tester.pumpAndSettle();
  await tester.enterText(amountField, amount);
}

Future<void> submitCredit(
  WidgetTester tester,
  WidgetHarness harness, {
  String label = 'Save',
}) async {
  tester.testTextInput.hide();
  await tester.pump();
  final save = find.widgetWithText(ElevatedButton, label);
  await tester.ensureVisible(save);
  await tester.pumpAndSettle();
  await tester.tap(save);
  await harness.settleDatabase(tester);
}

Future<void> creditMenu(WidgetTester tester, String action) async {
  final menu = find.byTooltip('Payment plan actions');
  await tester.ensureVisible(menu);
  await tester.pumpAndSettle();
  await tester.tap(menu);
  await tester.pumpAndSettle();
  await tester.tap(find.text(action));
  await tester.pumpAndSettle();
}
