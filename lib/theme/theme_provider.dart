import 'package:flutter/material.dart';
import 'package:movie_assignment/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  static const String _themeKey = 'selectedTheme';

  ThemeData _themeData = lightMode;

  ThemeData get themeData => _themeData;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
    _saveThemePreference(themeData);
  }

  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }

  // Load the theme preference from SharedPreferences
  Future<void> loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? savedThemeIndex = prefs.getInt(_themeKey);

    if (savedThemeIndex != null) {
      // Apply the saved theme
      _themeData = savedThemeIndex == 0 ? lightMode : darkMode;
      notifyListeners();
    }
  }

  // Save the selected theme preference to SharedPreferences
  Future<void> _saveThemePreference(ThemeData themeData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int themeIndex = themeData == lightMode ? 0 : 1;
    await prefs.setInt(_themeKey, themeIndex);
  }
}
