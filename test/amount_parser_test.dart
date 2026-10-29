import 'package:expenzia/utils/amount_parser.dart';
import 'package:expenzia/utils/formatters.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('amounts convert exactly to integer paise', () {
    expect(parseAmountPaise('850.25'), 85025);
    expect(parseAmountPaise('0.01'), 1);
    expect(parseAmountPaise(' 12.3 '), 1230);
    expect(parseAmountPaise('9999999999.99'), maxAmountPaise);
    expect(amountInput(12345), '123.45');
  });

  test('invalid amounts are rejected instead of rounded or stripped', () {
    for (final input in [
      '',
      '0',
      '-1',
      'abc',
      'NaN',
      'Infinity',
      '1.234',
      '1.2.3',
      '.5',
      '1.',
      '1e3',
      '10000000000',
      '12a34',
    ]) {
      expect(parseAmountPaise(input), isNull, reason: input);
      expect(validateAmount(input), isNotNull, reason: input);
    }
  });

  test('money uses rupees, Indian grouping, and two decimal places', () {
    expect(formatMoney(0), '₹ 0.00');
    expect(formatMoney(12345678), '₹ 1,23,456.78');
    expect(formatMoney(-150), '-₹ 1.50');
  });

  test('relative dates handle calendar boundaries', () {
    final now = DateTime(2026, 3, 1, 15);
    expect(transactionDate(DateTime(2026, 3, 1), now: now), 'Today');
    expect(transactionDate(DateTime(2026, 2, 28), now: now), 'Yesterday');
    expect(transactionDate(DateTime(2025, 1, 1), now: now), '1 Jan 2025');
  });
}
