import 'package:flutter/material.dart';

import '../core/config/business_config.dart';

ThemeData buildTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: businessConfig.primaryColor,
    brightness: Brightness.light,
    surface: const Color(0xFFFFFCF7),
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: const Color(0xFFFFFCF7),
    textTheme: Typography.material2021().black.apply(
      fontFamily: 'sans-serif',
      bodyColor: const Color(0xFF21302C),
      displayColor: const Color(0xFF16322B),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFD6DDD8)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFD6DDD8)),
      ),
    ),
  );
}
