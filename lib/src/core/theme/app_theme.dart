import 'package:flutter/material.dart';

class AppTheme {
  static const Color honey = Color(0xFFF4B942);
  static const Color ink = Color(0xFF1D2A2E);
  static const Color hive = Color(0xFF2D6A4F);
  static const Color cream = Color(0xFFFFFBF2);

  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: honey,
      brightness: Brightness.light,
      surface: cream,
    );
    return ThemeData(
      colorScheme: scheme,
      scaffoldBackgroundColor: cream,
      useMaterial3: true,
      fontFamily: 'sans-serif',
      appBarTheme: const AppBarTheme(
        backgroundColor: cream,
        foregroundColor: ink,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: ink.withValues(alpha: 0.06)),
        ),
      ),
    );
  }
}
