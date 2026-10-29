import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AppBottomNavigation extends StatelessWidget {
  const AppBottomNavigation({
    super.key,
    required this.selected,
    required this.onSelected,
  });
  final int selected;
  final ValueChanged<int> onSelected;

  Widget _item(IconData icon, String label, int index) => Expanded(
    child: IconButton(
      onPressed: () => onSelected(index),
      tooltip: label,
      isSelected: selected == index,
      icon: Icon(
        icon,
        size: 28,
        color: selected == index ? Colors.white : const Color(0xFF286C68),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) => BottomAppBar(
    height: 64,
    padding: const EdgeInsets.symmetric(horizontal: 8),
    color: AppColors.navigation,
    surfaceTintColor: Colors.transparent,
    shape: const CircularNotchedRectangle(),
    notchMargin: 7,
    child: Row(
      children: [
        _item(Icons.home_outlined, 'Home', 0),
        _item(Icons.history, 'History', 1),
        const SizedBox(width: 80),
        _item(Icons.wallet_outlined, 'Credit', 2),
        _item(Icons.person_outline, 'Profile', 3),
      ],
    ),
  );
}
