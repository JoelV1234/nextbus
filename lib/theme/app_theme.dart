import 'package:flutter/material.dart';

class AppTheme {
  // TransLink colors
  static const Color primaryBlue = Color(0xFF005DAA); // Endeavour Blue
  static const Color darkBlue = Color(0xFF00174D); // Stratos
  static const Color accentYellow = Color(0xFFF2A900); // TransLink Yellow
  static const Color backgroundLight = Color(0xFFF8FAFC); // Soft gray-white
  static const Color cardColor = Colors.white;
  static const Color textDark = Color(0xFF00174D);
  static const Color textLight = Color(0xFF6B7280);
  static const Color warningRedColor = Color.fromARGB(255, 193, 48, 0);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: backgroundLight,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        secondary: accentYellow,
        background: backgroundLight,
        surface: cardColor,
      ),
      fontFamily: 'Roboto', // Modern sans-serif default
      cardTheme: CardTheme(
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.08),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: accentYellow, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        labelStyle: const TextStyle(color: textLight),
        hintStyle: const TextStyle(color: textLight),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: textDark,
          fontWeight: FontWeight.bold,
          fontSize: 32,
        ),
        titleLarge: TextStyle(
          color: textDark,
          fontWeight: FontWeight.w700,
          fontSize: 22,
        ),
        bodyLarge: TextStyle(color: textDark, fontSize: 16),
        bodyMedium: TextStyle(color: textLight, fontSize: 14),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
    );
  }
}
