import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
        primaryColor: const Color(0xFF1976D2),
        scaffoldBackgroundColor: const Color(0xFFE3F2FD),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          color: Color(0xFF1976D2),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        cardTheme: CardTheme(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: Colors.white,
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0D47A1),
            fontFamily: 'Poppins',
          ),
          bodyLarge: TextStyle(
            fontSize: 14,
            color: Color(0xFF0D47A1),
            fontFamily: 'Poppins',
          ),
          bodyMedium: TextStyle(
            fontSize: 18,
            color: Color(0xFF0D47A1),
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
        ),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF1976D2),
          secondary: Color(0xFF64B5F6),
          surface: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF64B5F6),
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            textStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 16),
          ),
        ),
      );
}
