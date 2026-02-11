import 'package:flutter/material.dart';

class CoffeenatorTheme {
  static ThemeData get defaultTheme {
    return ThemeData(
      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),
      scaffoldBackgroundColor: const Color(0xff2C1D11),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xffee7c2b),
        primary: const Color(0xffee7c2b),
        onPrimary: Colors.white,
      ),
      textTheme: _textTheme,
    );
  }

  static TextTheme get _textTheme {
    return const TextTheme(
      titleLarge: TextStyle(
        color: Colors.white,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
      bodyMedium: TextStyle(
        color: Colors.white,
        fontSize: 14,
      ),
      bodySmall: TextStyle(
        color: Colors.white,
        fontSize: 12,
      ),
      labelMedium: TextStyle(
        color: Colors.white,
        fontSize: 11,
      ),
    );
  }
}
