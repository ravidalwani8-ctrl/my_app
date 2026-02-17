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
      visualDensity: VisualDensity.standard,

      // AppBar
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Color(0xFF6A11CB),
        foregroundColor: Colors.white,
        titleTextStyle: TextStyle(fontSize: 21, fontWeight: FontWeight.w700),
      ),

      cardTheme: CardThemeData(
        elevation: 2,
        color: Colors.white,
        margin: const EdgeInsets.symmetric(vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),

      textTheme: const TextTheme(
        titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
        titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
        bodyMedium: TextStyle(fontSize: 15.5, height: 1.3),
        bodySmall: TextStyle(fontSize: 13.5, height: 1.3),
      ),
      inputDecorationTheme: InputDecorationTheme(
        isDense: false,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        minVerticalPadding: 8,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
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
      visualDensity: VisualDensity.standard,

      // AppBar
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        titleTextStyle: TextStyle(fontSize: 21, fontWeight: FontWeight.w700),
      ),

      cardTheme: CardThemeData(
        elevation: 2,
        color: const Color(0xFF1A1D23),
        margin: const EdgeInsets.symmetric(vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),

      textTheme: const TextTheme(
        titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
        titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
        bodyMedium: TextStyle(fontSize: 15.5, height: 1.3),
        bodySmall: TextStyle(fontSize: 13.5, height: 1.3),
      ),
      inputDecorationTheme: InputDecorationTheme(
        isDense: false,
        filled: true,
        fillColor: const Color(0xFF222733),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        minVerticalPadding: 8,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
