import 'package:flutter/material.dart';
import 'package:movie_assignment/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Class responsible for managing the app's theme preferences
class ThemeProvider with ChangeNotifier {
  // Key to store the selected theme in SharedPreferences
  static const String _themeKey = 'selectedTheme';
  // Default theme set to light mode
  ThemeData _themeData = lightMode;
  // Getter for accessing the current theme
  ThemeData get themeData => _themeData;

  // Setter for updating the theme and saving the preference
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners(); // Notify listeners about the theme change
    _saveThemePreference(
        themeData); // Save the selected theme to SharedPreferences
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
