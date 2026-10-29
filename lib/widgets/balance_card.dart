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

  bool get _hasIncome => totalIncomePaise > 0;
  String get _headline => !_hasIncome
      ? formatMoney(totalPaise)
      : '${netBalancePaise < 0 ? '- ' : ''}${formatMoney(netBalancePaise.abs())}';

  @override
  Widget build(BuildContext context) {
    final label = _hasIncome
        ? 'Income: +${formatMoney(totalIncomePaise)}'
        : 'Expenses';
    final sub = _hasIncome
        ? 'Expenses: -${formatMoney(totalPaise)}'
        : 'All your spending, in one place.';
    final icon = _hasIncome ? Icons.wallet : Icons.arrow_upward;
    return Container(
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
          Text(
            _hasIncome ? 'Total Balance' : 'Total Expenses',
            style: const TextStyle(
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
          BalanceCardRow(label: label, count: count, icon: icon),
          const SizedBox(height: 8),
          Text(
            sub,
            style: const TextStyle(color: Color(0xFFD9EEEE), fontSize: 12),
          ),
        ],
      ),
    );
  }
}
