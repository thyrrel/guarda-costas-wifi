import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme(MaterialColor color) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorSchemeSeed: color,
      appBarTheme: AppBarTheme(
        backgroundColor: color,
        foregroundColor: Colors.white,
      ),
    );
  }

  static ThemeData darkTheme(MaterialColor color) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorSchemeSeed: color,
    );
  }
}