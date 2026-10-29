import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/profile_controller.dart';
import '../theme/app_colors.dart';

class PhotoPickerSheet extends StatelessWidget {
  const PhotoPickerSheet({super.key, required this.profile});
  final ProfileController profile;

  static Future<void> show(BuildContext context, ProfileController profile) =>
      showModalBottomSheet<void>(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (_) => PhotoPickerSheet(profile: profile),
      );

  Future<void> _pick(BuildContext context, ImageSource source) async {
    Navigator.of(context).pop();
    try {
      final picker = ImagePicker();
      final file = await picker.pickImage(
        source: source,
        maxWidth: 400,
        maxHeight: 400,
        imageQuality: 80,
      );
      if (file != null) {
        final bytes = await file.readAsBytes();
        await profile.savePhoto(base64Encode(bytes));
      }
    } catch (_) {
      // Handled silently or by controller error state
    }
  }

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.photo_camera, color: AppColors.teal),
            title: const Text('Take Photo'),
            onTap: () => _pick(context, ImageSource.camera),
          ),
          ListTile(
            leading: const Icon(Icons.photo_library, color: AppColors.teal),
            title: const Text('Choose from Gallery'),
            onTap: () => _pick(context, ImageSource.gallery),
          ),
          if (profile.photoPath != null)
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text(
                'Remove Photo',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () async {
                Navigator.of(context).pop();
                await profile.savePhoto(null);
              },
            ),
        ],
      ),
    ),
  );
}
