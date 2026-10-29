import 'dart:io';

import 'package:flutter/material.dart';

import '../controllers/profile_controller.dart';
import '../theme/app_colors.dart';
import 'photo_picker_sheet.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key, this.profile});
  final ProfileController? profile;

  bool get _hasPhoto {
    final path = profile?.photoPath;
    return path != null && File(path).existsSync();
  }

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      CircleAvatar(
        radius: 57,
        backgroundColor: const Color(0xFFB5B5B5),
        backgroundImage: _hasPhoto
            ? FileImage(File(profile!.photoPath!))
            : null,
        child: _hasPhoto
            ? null
            : const Icon(Icons.person, color: Color(0xFFE7E7E7), size: 105),
      ),
      Positioned(
        right: 0,
        bottom: 0,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: profile == null
                ? null
                : () => PhotoPickerSheet.show(context, profile!),
            borderRadius: BorderRadius.circular(21),
            child: Container(
              width: 41,
              height: 41,
              decoration: BoxDecoration(
                color: AppColors.teal,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
              ),
              child: const Tooltip(
                message: 'Change profile photo',
                child: Icon(Icons.camera_alt, color: Colors.white, size: 18),
              ),
            ),
          ),
        ),
      ),
    ],
  );
}
