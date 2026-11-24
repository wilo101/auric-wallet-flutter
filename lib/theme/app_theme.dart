import 'package:flutter/material.dart';

/// Design tokens taken from the Figma design system (dark green + gold).
/// Keeping them in one place is what makes a Figma handoff maintainable:
/// change a token here and every screen follows.
class AuricColors {
  static const background = Color(0xFF0B1A14);
  static const surface = Color(0xFF12261D);
  static const surfaceHigh = Color(0xFF1A3328);
  static const gold = Color(0xFFD4AF37);
  static const goldSoft = Color(0xFFE9D38A);
  static const textPrimary = Color(0xFFF4F1E6);
  static const textMuted = Color(0xFF8FA89B);
  static const income = Color(0xFF5FD39A);
  static const expense = Color(0xFFE5786D);
}

class AppTheme {
  static ThemeData get dark {
    const scheme = ColorScheme.dark(
      primary: AuricColors.gold,
      onPrimary: AuricColors.background,
      surface: AuricColors.surface,
      onSurface: AuricColors.textPrimary,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AuricColors.background,
      textTheme: const TextTheme(
        displaySmall: TextStyle(
            fontSize: 34, fontWeight: FontWeight.w700, color: AuricColors.textPrimary),
        titleMedium: TextStyle(
            fontSize: 16, fontWeight: FontWeight.w600, color: AuricColors.textPrimary),
        bodyMedium: TextStyle(fontSize: 14, color: AuricColors.textMuted),
      ),
      cardTheme: CardTheme(
        color: AuricColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AuricColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AuricColors.gold,
          foregroundColor: AuricColors.background,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }
}
