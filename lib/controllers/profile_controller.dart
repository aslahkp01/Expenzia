import 'package:flutter/foundation.dart';

import '../data/profile_database.dart';

class ProfileController extends ChangeNotifier {
  ProfileController(this.database);
  final ProfileDatabase database;
  String name = 'Expenzia User';
  String? error;
  bool saving = false;
  bool _disposed = false;

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  Future<void> load() async {
    try {
      name = await database.loadName();
      error = null;
    } catch (_) {
      error = 'Could not load your profile.';
    }
    _notify();
  }

  Future<bool> save(String value) async {
    if (saving || value.trim().isEmpty) return false;
    saving = true;
    error = null;
    _notify();
    try {
      await database.saveName(value);
      name = value.trim();
      return true;
    } catch (_) {
      error = 'Could not save your name. Please try again.';
      return false;
    } finally {
      saving = false;
      _notify();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
