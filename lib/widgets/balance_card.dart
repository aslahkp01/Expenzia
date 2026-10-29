import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../utils/formatters.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key, required this.totalPaise, required this.count});
  final int totalPaise;
  final int count;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(22),
    decoration: BoxDecoration(
      color: AppColors.teal,
      borderRadius: BorderRadius.circular(19),
      boxShadow: [
        BoxShadow(
          color: AppColors.teal.withValues(alpha: .24),
          blurRadius: 9,
          offset: const Offset(0, 6),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Total Expenses',
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
            formatMoney(totalPaise),
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: Color(0xFF529995),
                    child: Icon(
                      Icons.arrow_upward,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  SizedBox(width: 7),
                  Flexible(
                    child: Text(
                      'Expenses',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                '$count ${count == 1 ? 'record' : 'records'}',
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'All your spending, in one place.',
          style: TextStyle(color: Color(0xFFD9EEEE), fontSize: 12),
        ),
      ],
    ),
  );
}
