import 'package:flutter/material.dart';

class BalanceItem extends StatelessWidget {
  const BalanceItem({
    super.key,
    required this.label,
    required this.amount,
    required this.icon,
  });
  final String label;
  final String amount;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      CircleAvatar(
        radius: 13,
        backgroundColor: const Color(0xFF529995),
        child: Icon(icon, color: Colors.white, size: 16),
      ),
      const SizedBox(width: 8),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(color: Color(0xFFD9EEEE), fontSize: 13),
          ),
          const SizedBox(height: 2),
          Text(
            amount,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ],
  );
}
