import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../utils/formatters.dart';
import 'balance_card_row.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({
    super.key,
    required this.totalPaise,
    required this.count,
    this.totalIncomePaise = 0,
    this.netBalancePaise = 0,
  });
  final int totalPaise;
  final int count;
  final int totalIncomePaise;
  final int netBalancePaise;

  String get _headline {
    final balance = totalIncomePaise > 0 || netBalancePaise != 0
        ? netBalancePaise
        : (totalPaise > 0 ? -totalPaise : 0);
    final sign = balance < 0 ? '- ' : '';
    return '$sign${formatMoney(balance.abs())}';
  }

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(22),
    decoration: BoxDecoration(
      color: AppColors.teal,
      borderRadius: BorderRadius.circular(19),
      boxShadow: const [
        BoxShadow(
          color: Color(0x3D2C807B),
          blurRadius: 9,
          offset: Offset(0, 6),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Total Balance',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 7),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            _headline,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BalanceItem(
              label: 'Income',
              amount: formatMoney(totalIncomePaise),
              icon: Icons.arrow_downward,
            ),
            BalanceItem(
              label: 'Expenses',
              amount: formatMoney(totalPaise),
              icon: Icons.arrow_upward,
            ),
          ],
        ),
      ],
    ),
  );
}
