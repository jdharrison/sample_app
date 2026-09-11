import 'package:flutter/material.dart';

import '../core/config/riptide.dart';

export '../core/config/riptide.dart' show RiptideColors, RiptideTokens;

ThemeData buildRiptideTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: RiptideColors.ocean,
    brightness: Brightness.light,
    primary: RiptideColors.oceanDeep,
    onPrimary: RiptideColors.parchmentLight,
    primaryContainer: RiptideColors.ocean,
    onPrimaryContainer: RiptideColors.parchmentLight,
    secondary: RiptideColors.gold,
    onSecondary: RiptideColors.ink,
    secondaryContainer: RiptideColors.parchment,
    onSecondaryContainer: RiptideColors.oceanDeep,
    tertiary: RiptideColors.bronze,
    onTertiary: RiptideColors.parchmentLight,
    tertiaryContainer: RiptideColors.parchmentLight,
    onTertiaryContainer: RiptideColors.oceanDeep,
    error: RiptideColors.danger,
    onError: RiptideColors.parchmentLight,
    errorContainer: RiptideColors.parchmentLight,
    onErrorContainer: RiptideColors.danger,
    surface: RiptideColors.parchment,
    onSurface: RiptideColors.ink,
    onSurfaceVariant: RiptideColors.oceanDeep,
    surfaceDim: RiptideColors.parchmentDark,
    surfaceBright: RiptideColors.parchmentLight,
    surfaceContainerLowest: RiptideColors.parchmentLight,
    surfaceContainerLow: RiptideColors.parchmentLight,
    surfaceContainer: RiptideColors.parchment,
    surfaceContainerHigh: RiptideColors.parchment,
    surfaceContainerHighest: RiptideColors.parchmentDark,
    outline: RiptideColors.bronze,
    outlineVariant: RiptideColors.bronze,
    inverseSurface: RiptideColors.oceanDeep,
    onInverseSurface: RiptideColors.parchmentLight,
    inversePrimary: RiptideColors.gold,
    surfaceTint: Colors.transparent,
    shadow: RiptideTokens.shadowColor,
    scrim: RiptideColors.ink,
  );
  final base = ThemeData(useMaterial3: true, colorScheme: scheme);
  final text = base.textTheme.apply(
    bodyColor: RiptideColors.ink,
    displayColor: RiptideColors.oceanDeep,
  );
  TextStyle? heading(TextStyle? style, double size) => style?.copyWith(
    fontFamily: RiptideTokens.headingFontFamily,
    fontFamilyFallback: RiptideTokens.headingFontFallback,
    fontSize: size,
    height: 1.15,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
  );
  final textTheme = text.copyWith(
    displayLarge: heading(text.displayLarge, 58),
    displayMedium: heading(text.displayMedium, 44),
    displaySmall: heading(text.displaySmall, 38),
    headlineLarge: heading(text.headlineLarge, 34),
    headlineMedium: heading(text.headlineMedium, 28),
    headlineSmall: heading(text.headlineSmall, 24),
    titleLarge: heading(text.titleLarge, 20),
    bodyLarge: text.bodyLarge?.copyWith(fontSize: 16, height: 1.6),
    bodyMedium: text.bodyMedium?.copyWith(fontSize: 14, height: 1.5),
    bodySmall: text.bodySmall?.copyWith(fontSize: 12, height: 1.5),
  );
  final controlShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(RiptideTokens.controlRadius),
  );
  final surfaceShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(RiptideTokens.cardRadius),
    side: const BorderSide(
      color: RiptideColors.bronze,
      width: RiptideTokens.strokeWidth,
    ),
  );
  final inputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(RiptideTokens.controlRadius),
    borderSide: const BorderSide(color: RiptideColors.bronze),
  );
  final enamelButton = FilledButton.styleFrom(
    backgroundColor: RiptideColors.oceanDeep,
    foregroundColor: RiptideColors.parchmentLight,
    disabledBackgroundColor: RiptideColors.parchment,
    disabledForegroundColor: RiptideColors.bronze,
    overlayColor: RiptideColors.gold,
    side: const BorderSide(color: RiptideColors.gold),
    minimumSize: const Size(48, 48),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 17),
    shape: controlShape,
    textStyle: const TextStyle(fontWeight: FontWeight.w700, letterSpacing: .3),
    animationDuration: RiptideTokens.animationFast,
  );

  return base.copyWith(
    scaffoldBackgroundColor: RiptideColors.parchment,
    canvasColor: RiptideColors.parchmentLight,
    shadowColor: RiptideTokens.shadowColor,
    dividerColor: RiptideColors.bronze,
    textTheme: textTheme,
    primaryTextTheme: textTheme.apply(
      bodyColor: RiptideColors.parchmentLight,
      displayColor: RiptideColors.parchmentLight,
    ),
    iconTheme: const IconThemeData(color: RiptideColors.oceanDeep),
    appBarTheme: AppBarTheme(
      backgroundColor: RiptideColors.oceanDeep,
      foregroundColor: RiptideColors.parchmentLight,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: RiptideTokens.cardElevation,
      shadowColor: RiptideTokens.shadowColor,
      titleTextStyle: textTheme.titleLarge?.copyWith(
        color: RiptideColors.parchmentLight,
      ),
      shape: const Border(bottom: BorderSide(color: RiptideColors.gold)),
    ),
    cardTheme: CardThemeData(
      elevation: RiptideTokens.cardElevation,
      shadowColor: RiptideTokens.shadowColor,
      color: RiptideColors.parchmentLight,
      surfaceTintColor: Colors.transparent,
      shape: surfaceShape,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: RiptideColors.parchmentLight,
      surfaceTintColor: Colors.transparent,
      shadowColor: RiptideTokens.shadowColor,
      elevation: RiptideTokens.raisedElevation,
      shape: surfaceShape,
      titleTextStyle: textTheme.headlineSmall,
      contentTextStyle: textTheme.bodyMedium,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: RiptideColors.parchmentLight,
      modalBackgroundColor: RiptideColors.parchmentLight,
      surfaceTintColor: Colors.transparent,
      elevation: RiptideTokens.raisedElevation,
      shape: surfaceShape,
      dragHandleColor: RiptideColors.bronze,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: RiptideColors.parchmentLight,
      labelStyle: const TextStyle(color: RiptideColors.oceanDeep),
      floatingLabelStyle: const TextStyle(color: RiptideColors.oceanDeep),
      hintStyle: const TextStyle(color: RiptideColors.bronze),
      helperStyle: const TextStyle(color: RiptideColors.oceanDeep),
      errorStyle: const TextStyle(color: RiptideColors.danger),
      prefixIconColor: RiptideColors.ocean,
      suffixIconColor: RiptideColors.ocean,
      contentPadding: const EdgeInsets.all(RiptideTokens.spaceMd),
      border: inputBorder,
      enabledBorder: inputBorder,
      disabledBorder: inputBorder,
      focusedBorder: inputBorder.copyWith(
        borderSide: const BorderSide(
          color: RiptideColors.oceanDeep,
          width: RiptideTokens.focusStrokeWidth,
        ),
      ),
      errorBorder: inputBorder.copyWith(
        borderSide: const BorderSide(color: RiptideColors.danger),
      ),
      focusedErrorBorder: inputBorder.copyWith(
        borderSide: const BorderSide(
          color: RiptideColors.danger,
          width: RiptideTokens.focusStrokeWidth,
        ),
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: RiptideColors.oceanDeep,
      selectionColor: RiptideColors.gold.withValues(alpha: .4),
      selectionHandleColor: RiptideColors.ocean,
    ),
    filledButtonTheme: FilledButtonThemeData(style: enamelButton),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: enamelButton.copyWith(
        elevation: const WidgetStatePropertyAll(RiptideTokens.cardElevation),
        shadowColor: const WidgetStatePropertyAll(RiptideTokens.shadowColor),
        surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(style: enamelButton),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: RiptideColors.oceanDeep,
        overlayColor: RiptideColors.bronze,
        minimumSize: const Size(48, 48),
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
        animationDuration: RiptideTokens.animationFast,
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: RiptideColors.parchmentLight,
      surfaceTintColor: Colors.transparent,
      indicatorColor: RiptideColors.oceanDeep,
      iconTheme: WidgetStateProperty.resolveWith(
        (states) => IconThemeData(
          color: states.contains(WidgetState.selected)
              ? RiptideColors.gold
              : RiptideColors.oceanDeep,
        ),
      ),
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => TextStyle(
          color: RiptideColors.oceanDeep,
          fontWeight: states.contains(WidgetState.selected)
              ? FontWeight.w700
              : FontWeight.w500,
        ),
      ),
    ),
    navigationRailTheme: const NavigationRailThemeData(
      backgroundColor: RiptideColors.parchmentLight,
      useIndicator: true,
      indicatorColor: RiptideColors.oceanDeep,
      selectedIconTheme: IconThemeData(color: RiptideColors.gold),
      unselectedIconTheme: IconThemeData(color: RiptideColors.oceanDeep),
      selectedLabelTextStyle: TextStyle(
        color: RiptideColors.oceanDeep,
        fontWeight: FontWeight.w700,
      ),
      unselectedLabelTextStyle: TextStyle(color: RiptideColors.oceanDeep),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: RiptideColors.oceanDeep,
      selectedItemColor: RiptideColors.gold,
      unselectedItemColor: RiptideColors.parchmentLight,
      type: BottomNavigationBarType.fixed,
    ),
    tabBarTheme: const TabBarThemeData(
      labelColor: RiptideColors.oceanDeep,
      unselectedLabelColor: RiptideColors.ocean,
      indicatorColor: RiptideColors.oceanDeep,
      dividerColor: RiptideColors.bronze,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: RiptideColors.parchmentLight,
      selectedColor: RiptideColors.gold,
      labelStyle: const TextStyle(color: RiptideColors.ink),
      secondaryLabelStyle: const TextStyle(color: RiptideColors.ink),
      checkmarkColor: RiptideColors.ink,
      side: const BorderSide(color: RiptideColors.bronze),
      shape: controlShape,
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: RiptideColors.parchmentLight,
      surfaceTintColor: Colors.transparent,
      shadowColor: RiptideTokens.shadowColor,
      shape: surfaceShape,
      textStyle: textTheme.bodyMedium,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: RiptideColors.ocean,
      linearTrackColor: RiptideColors.parchmentDark,
      circularTrackColor: RiptideColors.parchmentDark,
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: RiptideColors.oceanDeep,
        border: Border.all(color: RiptideColors.gold),
        borderRadius: BorderRadius.circular(RiptideTokens.controlRadius),
      ),
      textStyle: const TextStyle(color: RiptideColors.parchmentLight),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: RiptideColors.oceanDeep,
      contentTextStyle: const TextStyle(color: RiptideColors.parchmentLight),
      actionTextColor: RiptideColors.gold,
      behavior: SnackBarBehavior.floating,
      elevation: RiptideTokens.raisedElevation,
      shape: controlShape.copyWith(
        side: const BorderSide(color: RiptideColors.gold),
      ),
    ),
  );
}
