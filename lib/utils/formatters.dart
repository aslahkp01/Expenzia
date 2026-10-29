String formatMoney(int paise) {
  final absolute = paise.abs();
  final digits = (absolute ~/ 100).toString();
  final fraction = (absolute % 100).toString().padLeft(2, '0');
  var grouped = digits;
  if (digits.length > 3) {
    final leading = digits.substring(0, digits.length - 3);
    final trailing = digits.substring(digits.length - 3);
    final prefix = leading.replaceAllMapped(
      RegExp(r'(\d)(?=(\d{2})+(?!\d))'),
      (match) => '${match[1]},',
    );
    grouped = '$prefix,$trailing';
  }
  return '${paise < 0 ? '-' : ''}₹ $grouped.$fraction';
}

String formatDate(DateTime date) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${date.day} ${months[date.month - 1]} ${date.year}';
}

String transactionDate(DateTime date, {DateTime? now}) {
  final current = now ?? DateTime.now();
  final today = DateTime(current.year, current.month, current.day);
  final day = DateTime(date.year, date.month, date.day);
  if (day == today) return 'Today';
  if (day == DateTime(today.year, today.month, today.day - 1)) {
    return 'Yesterday';
  }
  return formatDate(date);
}
