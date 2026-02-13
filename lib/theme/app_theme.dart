import 'package:flutter/material.dart';

class AppTheme {
  // Premium Gradient
  static const Gradient mainGradient = LinearGradient(
    colors: [
      Color(0xFF6A11CB), // Purple
      Color(0xFF2575FC), // Blue
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ========================
  // LIGHT THEME
  // ========================
  static ThemeData light() {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF5F7FA),
      primaryColor: const Color(0xFF6A11CB),
      useMaterial3: true,

      // AppBar
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Color(0xFF6A11CB),
        foregroundColor: Colors.white,
        titleTextStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),

      // FIXED: CardThemeData instead of CardTheme
      cardTheme: CardThemeData(
        elevation: 3,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      textTheme: const TextTheme(
        bodyLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        bodyMedium: TextStyle(fontSize: 16),
        titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }

  // ========================
  // DARK THEME
  // ========================
  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF111318),
      primaryColor: const Color(0xFF6A11CB),
      useMaterial3: true,

      // AppBar
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),

      // FIXED: CardThemeData
      cardTheme: CardThemeData(
        elevation: 3,
        color: Color(0xFF1A1D23),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      textTheme: const TextTheme(
        bodyLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        bodyMedium: TextStyle(fontSize: 16),
        titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }
}
