import 'package:flutter/material.dart';

class AppTheme {
  static const Color background = Color(0xFF0B0D14);
  static const Color surface = Color(0xFF171B28);
  static const Color primary = Color(0xFFE5484D);
  static const Color accent = Color(0xFFFFC857);
  static const Color muted = Color(0xFF9AA3B2);
  static const Color success = Color(0xFF36B37E);
  static const Color danger = Color(0xFFE5484D);

  static ThemeData get darkTheme {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.dark,
        surface: surface,
      ),
    );

    return base.copyWith(
      scaffoldBackgroundColor: background,
      textTheme: base.textTheme.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Colors.white10),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(120, 48),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: const BorderSide(color: Colors.white24),
          minimumSize: const Size(120, 46),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}

class AppColors {
  static const Color darkBackground = AppTheme.background;
  static const Color darkCard = AppTheme.surface;
  static const Color darkSurface = AppTheme.surface;

  static const Color gold = AppTheme.accent;
  static const Color goldDark = Color(0xFFB8860B);

  static const Color white = Colors.white;
  static const Color grey = AppTheme.muted;

  static const Color green = AppTheme.success;
  static const Color correctGreen = AppTheme.success;

  static const Color red = AppTheme.danger;
  static const Color wrongRed = AppTheme.danger;

  static const Color orange = Color(0xFFFF9800);
  static const Color eliminated = Color(0xFF303747);
}
