import 'package:flutter/material.dart';

class AppColors {
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color red = Colors.red;
  static const Color blue = Colors.blue;
  static const Color green = Colors.green;
  static const Color grey = Color(0xFF9D9898);
  static const Color primaryColor = Colors.purple;
  static Color colorTheme = Colors.white;
  static Color colorThemeText = Colors.black;
  static Color colorThemeDropdown = Colors.white;
  static Color colorThemeCardContentMultiple = Colors.white;

  static const disabledPrimaryButtonColorTheme = Color(0xFFEBEBEB);

  static void setTheme(String theme) {
    if (theme == 'light') {
      colorTheme = Colors.white;
      colorThemeText = Colors.black;
      colorThemeDropdown = Colors.white;
      colorThemeCardContentMultiple = Colors.white;
    } else {
      colorTheme = Colors.black54;
      colorThemeText = Colors.white;
      colorThemeDropdown = Colors.black.withAlpha(0);
      colorThemeCardContentMultiple = Colors.transparent;
    }
  }
}
