import 'package:flutter/material.dart';

import 'const.dart' as constants;

/// Application theme configuration providing a dark material theme.
class AppTheme {
  AppTheme._();

  /// The dark theme used throughout the app.
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // ── ColorScheme ──
      colorScheme: ColorScheme.light(
        surface: const Color(0xFFF5F5F5),
        primary: const Color(0xFF1A73E8),
        onSurface: const Color(0xFF202124),
        onPrimary: Colors.white,
        secondary: const Color(0xFF34A853),
        onSecondary: Colors.white,
        error: Colors.redAccent,
        background: const Color(0xFFF5F5F5),
        onBackground: const Color(0xFF202124),
        surfaceVariant: const Color(0xFFE8EAED),
      ),

      // ── TextTheme ──
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          fontFamily: 'Roboto',
        ),
        displayMedium: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          fontFamily: 'Roboto',
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          fontFamily: 'Roboto',
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          fontFamily: 'Roboto',
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          fontFamily: 'Roboto',
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          fontFamily: 'Roboto',
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          fontFamily: 'Roboto',
        ),
      ),

      // ── Scaffold ──
      scaffoldBackgroundColor: constants.background,

      // ── ButtonTheme ──
      buttonTheme: ButtonThemeData(
        buttonColor: constants.primary,
        textTheme: ButtonTextTheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),

      // ── ElevatedButtonTheme ──
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: constants.primary,
          foregroundColor: constants.textPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),

      // ── TextButtonTheme ──
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: constants.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

      // ── CardThemeData ──
      cardTheme: const CardThemeData(
        color: constants.surface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        margin: EdgeInsets.all(8),
      ),

      // ── AppBarTheme ──
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: constants.textPrimary,
        elevation: 0,
        centerTitle: true,
      ),

      // ── BottomNavigationBarTheme ──
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: constants.surface,
        selectedItemColor: constants.primary,
        unselectedItemColor: constants.textSecondary,
        type: BottomNavigationBarType.fixed,
      ),

      // ── Dialog theme ──
      dialogTheme: const DialogThemeData(
        backgroundColor: constants.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),

      // ── InputDecorationTheme ──
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: constants.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: constants.textSecondary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: constants.textSecondary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: constants.primary, width: 2),
        ),
        hintStyle: const TextStyle(
          color: constants.textSecondary,
          fontFamily: 'Roboto',
        ),
      ),
    );
  }
}
