import 'package:about_me/theme/dark_mode.dart';
import 'package:about_me/theme/light_mode.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  // Initially start in dark mode
  ThemeData _themeData = darkMode;
  ThemeMode _themeMode = ThemeMode.dark;

  // Get current theme
  ThemeData get themeData => _themeData;
  ThemeMode get themeMode => _themeMode;

  bool get isLightMode => _themeData == lightMode;
  bool get isDarkMode => _themeData == darkMode;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    _themeMode = themeData == lightMode ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == lightMode) {
      _themeData = darkMode;
      _themeMode = ThemeMode.dark;
    } else {
      _themeData = lightMode;
      _themeMode = ThemeMode.light;
    }
    notifyListeners();
  }
}
