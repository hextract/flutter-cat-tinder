import 'package:flutter/material.dart';

class AppTheme {
  // Color constants
  static const Color primaryBlue = Color(0xFF1976D2);
  static const Color secondaryBlue = Color(0xFF64B5F6);
  static const Color darkBlue = Color(0xFF0D47A1);
  static const Color backgroundLight = Color(0xFFE3F2FD);
  static const Color surfaceWhite = Colors.white;

  static ThemeData get lightTheme => ThemeData(
        primaryColor: primaryBlue,
        scaffoldBackgroundColor: backgroundLight,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          color: primaryBlue,
          titleTextStyle: TextStyle(
            color: surfaceWhite,
            fontSize: 20,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        cardTheme: CardTheme(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: surfaceWhite,
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: darkBlue,
            fontFamily: 'Poppins',
          ),
          bodyLarge: TextStyle(
            fontSize: 14,
            color: darkBlue,
            fontFamily: 'Poppins',
          ),
          bodyMedium: TextStyle(
            fontSize: 18,
            color: darkBlue,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
        ),
        colorScheme: const ColorScheme.light(
          primary: primaryBlue,
          secondary: secondaryBlue,
          surface: surfaceWhite,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: secondaryBlue,
            foregroundColor: surfaceWhite,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            textStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 16),
          ),
        ),
      );
}
