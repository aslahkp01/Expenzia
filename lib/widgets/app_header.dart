import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  const AppHeader(this.title, {super.key, this.back = false, this.onBack});

  final String title;
  final bool back;
  final VoidCallback? onBack;

  @override
  Size get preferredSize => const Size.fromHeight(88);

  @override
  Widget build(BuildContext context) => AppBar(
    title: Text(title),
    centerTitle: true,
    toolbarHeight: 88,
    automaticallyImplyLeading: back,
    leading: onBack == null
        ? null
        : IconButton(
            onPressed: onBack,
            tooltip: 'Back',
            icon: const Icon(Icons.chevron_left, size: 30),
          ),
    backgroundColor: AppColors.teal,
    foregroundColor: Colors.white,
    surfaceTintColor: Colors.transparent,
    systemOverlayStyle: SystemUiOverlayStyle.light,
    titleTextStyle: const TextStyle(
      fontFamily: 'Roboto',
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
  );
}
