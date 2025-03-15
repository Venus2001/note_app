import 'package:flutter/material.dart';

import 'theme.dart';

class ThemeProvider with ChangeNotifier {
  //initially, theme is light mode
  ThemeData _themeData = lightMode;

// getter method to access the theme frome other parts of the codes
  ThemeData get themeData => _themeData;

// getter method to see if we are in dark mode or not
  bool get isDarkMode => _themeData == darkMode;

// setter methode to set the new theme
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

// we will to use the toggel in a swiche later on...
  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }
}