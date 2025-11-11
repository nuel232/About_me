import 'package:about_me/theme/dark_mode.dart';
import 'package:about_me/theme/light_mode.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  //initially start in dark mode
  ThemeData _themeData = darkMode;

  //get current theme
  ThemeData get themeData => _themeData;

  bool get isLightMode => _themeData == lightMode;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    if (themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }
}
