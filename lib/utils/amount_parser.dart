const maxAmountPaise = 999999999999;

int? parseAmountPaise(String input) {
  final text = input.trim();
  if (!RegExp(r'^\d{1,10}(?:\.\d{1,2})?$').hasMatch(text)) return null;
  final parts = text.split('.');
  final rupees = int.parse(parts.first);
  final fraction = parts.length == 2 ? parts[1] : '';
  final amount = rupees * 100 + int.parse(fraction.padRight(2, '0'));
  return amount > 0 && amount <= maxAmountPaise ? amount : null;
}

String amountInput(int paise) {
  final fraction = (paise % 100).toString().padLeft(2, '0');
  return '${paise ~/ 100}.$fraction';
}

String? validateAmount(String? value) {
  if (value == null || value.trim().isEmpty) return 'Enter an amount';
  return parseAmountPaise(value) == null
      ? 'Enter a positive amount with up to 2 decimal places'
      : null;
}
