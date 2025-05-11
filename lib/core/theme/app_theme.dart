import 'package:flutter/material.dart';

// lib/core/theme/app_theme.dart
class AppTheme {
  static final lightTheme = ThemeData(
    colorScheme: ColorScheme.light(
      primary: Colors.blue.shade800,
      secondary: Colors.blue.shade600,
    ),
    useMaterial3: true,
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );

  static final darkTheme = ThemeData(
    colorScheme: ColorScheme.dark(
      primary: Colors.blue.shade300,
      secondary: Colors.blue.shade200,
    ),
    useMaterial3: true,
  );
}