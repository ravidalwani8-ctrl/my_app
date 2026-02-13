import 'package:flutter/foundation.dart';

class SettingsProvider extends ChangeNotifier {
  bool _isDark = false;

  bool get isDark => _isDark;

  /// Toggle between Light and Dark Theme
  void toggleTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }
}
