import 'package:flutter/material.dart';

abstract final class RiptideColors {
  static const deepOcean = Color(0xFF082B49);
  static const ocean = Color(0xFF0C4F78);
  static const aqua = Color(0xFF22B8F0);
  static const reefTeal = Color(0xFF10B8A7);
  static const coral = Color(0xFFFF7A2D);
  static const seaMist = Color(0xFFEAF5FA);
  static const foam = Color(0xFFF7FBFD);
  static const ink = Color(0xFF071A2B);
  static const white = Color(0xFFFFFFFF);
}

ThemeData buildRiptideTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: RiptideColors.aqua,
    brightness: Brightness.light,
    primary: RiptideColors.deepOcean,
    secondary: RiptideColors.aqua,
    surface: RiptideColors.foam,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: RiptideColors.foam,
    fontFamily: 'Inter',
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 58, height: .98, fontWeight: FontWeight.w700, letterSpacing: -2.0),
      displayMedium: TextStyle(fontSize: 44, height: 1.0, fontWeight: FontWeight.w700, letterSpacing: -1.4),
      headlineLarge: TextStyle(fontSize: 34, fontWeight: FontWeight.w700, letterSpacing: -.8),
      headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, letterSpacing: -.5),
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
      bodyLarge: TextStyle(fontSize: 16, height: 1.5),
      bodyMedium: TextStyle(fontSize: 14, height: 1.45),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: RiptideColors.aqua,
        foregroundColor: RiptideColors.deepOcean,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 17),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
      ),
    ),
  );
}
