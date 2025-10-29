import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryBlue = Color(0xFF2B7BA6);
  static const Color lightBlue = Color(0xFFBEE6FF);
  static const Color successGreen = Color(0xFF3CB043);
  static const Color dangerRed = Color(0xFFDE4B4B);
  static const Color warningOrange = Color(0xFFFB8C00);

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryBlue,
      colorScheme: ColorScheme.fromSwatch().copyWith(primary: primaryBlue),
      scaffoldBackgroundColor: const Color(0xFFF7F8FA),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: primaryBlue,
        elevation: 1,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(backgroundColor: primaryBlue),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
