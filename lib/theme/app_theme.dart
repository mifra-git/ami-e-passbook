import 'package:flutter/material.dart';

class AppTheme {
  // ==========================================================
  // AMI E-PASSBOOK COLORS
  // ==========================================================

  static const Color primary = Color(0xFF0B2A4A);
  static const Color primaryLight = Color(0xFF123C73);
  static const Color primaryDark = Color(0xFF071C32);

  static const Color gold = Color(0xFFD4A72C);
  static const Color goldLight = Color(0xFFF5E7B2);

  static const Color background = Color(0xFFF6F8FC);
  static const Color card = Color(0xFFFFFFFF);

  static const Color textPrimary = Color(0xFF14213D);
  static const Color textSecondary = Color(0xFF687386);

  static const Color border = Color(0xFFE3E8EF);

  static const Color success = Color(0xFF16805C);
  static const Color error = Color(0xFFC62828);

  // ==========================================================
  // LIGHT THEME
  // ==========================================================

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,

    brightness: Brightness.light,

    scaffoldBackgroundColor: background,

    colorScheme: const ColorScheme.light(
      primary: primary,
      onPrimary: Colors.white,

      secondary: gold,
      onSecondary: Colors.white,

      surface: card,
      onSurface: textPrimary,

      error: error,
      onError: Colors.white,
    ),

    // --------------------------------------------------------
    // APP BAR
    // --------------------------------------------------------

    appBarTheme: const AppBarTheme(
      backgroundColor: background,
      foregroundColor: textPrimary,
      elevation: 0,
      centerTitle: false,
      surfaceTintColor: Colors.transparent,

      titleTextStyle: TextStyle(
        color: textPrimary,
        fontSize: 21,
        fontWeight: FontWeight.w800,
      ),
    ),

    // --------------------------------------------------------
    // CARD
    // --------------------------------------------------------

    cardTheme: CardThemeData(
      color: card,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      margin: EdgeInsets.zero,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(
          color: border,
        ),
      ),
    ),

    // --------------------------------------------------------
    // ELEVATED BUTTON
    // --------------------------------------------------------

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,

        padding: const EdgeInsets.symmetric(
          horizontal: 22,
          vertical: 14,
        ),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),

        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),

    // --------------------------------------------------------
    // OUTLINED BUTTON
    // --------------------------------------------------------

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primary,

        padding: const EdgeInsets.symmetric(
          horizontal: 22,
          vertical: 14,
        ),

        side: const BorderSide(
          color: border,
        ),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),

        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),

    // --------------------------------------------------------
    // TEXT BUTTON
    // --------------------------------------------------------

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primary,

        textStyle: const TextStyle(
          fontWeight: FontWeight.w700,
        ),
      ),
    ),

    // --------------------------------------------------------
    // INPUT FIELDS
    // --------------------------------------------------------

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,

      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 15,
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: border,
        ),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: border,
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: primary,
          width: 1.5,
        ),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: error,
        ),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: error,
          width: 1.5,
        ),
      ),

      labelStyle: const TextStyle(
        color: textSecondary,
      ),

      hintStyle: const TextStyle(
        color: textSecondary,
      ),
    ),

    // --------------------------------------------------------
    // NAVIGATION BAR
    // --------------------------------------------------------

    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      elevation: 0,
      height: 72,

      indicatorColor: goldLight,

      labelTextStyle:
          WidgetStateProperty.resolveWith<TextStyle>(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              color: primary,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            );
          }

          return const TextStyle(
            color: textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          );
        },
      ),

      iconTheme:
          WidgetStateProperty.resolveWith<IconThemeData>(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(
              color: primary,
              size: 24,
            );
          }

          return const IconThemeData(
            color: textSecondary,
            size: 23,
          );
        },
      ),
    ),

    // --------------------------------------------------------
    // DIVIDER
    // --------------------------------------------------------

    dividerTheme: const DividerThemeData(
      color: border,
      thickness: 1,
      space: 1,
    ),

    // --------------------------------------------------------
    // SNACKBAR
    // --------------------------------------------------------

    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,

      backgroundColor: primary,
      contentTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
    ),

    // --------------------------------------------------------
    // PROGRESS INDICATOR
    // --------------------------------------------------------

    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: primary,
    ),
  );
}

