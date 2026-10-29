import '../models/credit.dart';
import 'amount_parser.dart';

DateTime? nextCreditDate(Credit credit) {
  if (credit.plan == CreditPlan.oneTime) return null;
  final month = credit.plan == CreditPlan.monthly
      ? DateTime(credit.dueDate.year, credit.dueDate.month + 1)
      : DateTime(credit.dueDate.year + 1, credit.anchorMonth);
  final lastDay = DateTime(month.year, month.month + 1, 0).day;
  final day = credit.anchorDay.clamp(1, lastDay);
  return DateTime(month.year, month.month, day);
}

void validateCredit(Credit credit) {
  if (credit.recipient.trim().isEmpty || !creditTypes.contains(credit.type)) {
    throw const FormatException('Recipient and credit type are required.');
  }
  if (credit.amountPaise <= 0 || credit.amountPaise > maxAmountPaise) {
    throw const FormatException('Enter a valid positive amount.');
  }
  if (credit.dueDate.year < 2000 ||
      credit.dueDate.year > 2100 ||
      credit.anchorDay < 1 ||
      credit.anchorDay > 31 ||
      credit.anchorMonth < 1 ||
      credit.anchorMonth > 12) {
    throw const FormatException('Choose a valid due date.');
  }
}
