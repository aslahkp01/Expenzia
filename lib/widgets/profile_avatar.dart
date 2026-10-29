import 'dart:convert';

import 'package:flutter/material.dart';

import '../controllers/profile_controller.dart';
import '../theme/app_colors.dart';
import 'photo_picker_sheet.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key, this.profile});
  final ProfileController? profile;

  ImageProvider? get _avatarImage {
    final photo = profile?.photoPath;
    if (photo == null || photo.isEmpty) return null;
    try {
      return MemoryImage(base64Decode(photo));
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final image = _avatarImage;
    return Stack(
      children: [
        CircleAvatar(
          radius: 57,
          backgroundColor: const Color(0xFFB5B5B5),
          backgroundImage: image,
          child: image != null
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
}
