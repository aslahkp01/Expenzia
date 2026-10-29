import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key});

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      const CircleAvatar(
        radius: 57,
        backgroundColor: Color(0xFFB5B5B5),
        child: Icon(Icons.person, color: Color(0xFFE7E7E7), size: 105),
      ),
      Positioned(
        right: 0,
        bottom: 0,
        child: Container(
          width: 41,
          height: 41,
          decoration: BoxDecoration(
            color: AppColors.teal,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
          ),
          child: const Tooltip(
            message: 'Profile photo unavailable',
            child: Icon(Icons.camera_alt, color: Colors.white, size: 18),
          ),
        ),
      ),
    ],
  );
}
