import 'package:flutter/material.dart';

class BalanceCardRow extends StatelessWidget {
  const BalanceCardRow({
    super.key,
    required this.label,
    required this.count,
    required this.icon,
  });
  final String label;
  final int count;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: const Color(0xFF529995),
            child: Icon(icon, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 7),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
      Text(
        '$count ${count == 1 ? 'record' : 'records'}',
        style: const TextStyle(color: Colors.white),
      ),
    ],
  );
}
