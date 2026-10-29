import 'package:flutter/material.dart';

import '../controllers/profile_controller.dart';
import '../utils/validators.dart';

class ProfileNameDialog extends StatefulWidget {
  const ProfileNameDialog({super.key, required this.profile});
  final ProfileController profile;

  @override
  State<ProfileNameDialog> createState() => _ProfileNameDialogState();
}

class _ProfileNameDialogState extends State<ProfileNameDialog> {
  final _key = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.profile.name);

  Future<void> _save() async {
    if (!_key.currentState!.validate()) return;
    final saved = await widget.profile.save(_name.text);
    if (!mounted || !saved) return;
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.profile,
    builder: (context, child) => PopScope(
      canPop: !widget.profile.saving,
      child: AlertDialog(
        title: const Text('Edit name'),
        content: Form(
          key: _key,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _name,
                autofocus: true,
                enabled: !widget.profile.saving,
                validator: validateRequired,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              if (widget.profile.error != null) Text(widget.profile.error!),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: widget.profile.saving
                ? null
                : () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: widget.profile.saving ? null : _save,
            child: Text(widget.profile.saving ? 'Saving…' : 'Save'),
          ),
        ],
      ),
    ),
  );
}
