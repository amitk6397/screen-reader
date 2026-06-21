import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Theme-Aware Colors ──────────────────────
  static Color navy(BuildContext context) => _t(
    context,
    dark: const Color(0xFF0F1724),
    light: const Color(0xFFF4F6FB),
  );

  static Color navyMid(BuildContext context) =>
      _t(context, dark: const Color(0xFF1A2435), light: Colors.white);

  static Color navyLight(BuildContext context) => _t(
    context,
    dark: const Color(0xFF243047),
    light: const Color(0xFFE2E8F4),
  );

  static Color textPrimary(BuildContext context) => _t(
    context,
    dark: const Color(0xFFF0F4FF),
    light: const Color(0xFF0F1724),
  );

  static Color textMuted(BuildContext context) => _t(
    context,
    dark: const Color(0xFF6B7A9A),
    light: const Color(0xFF8896B0),
  );

  static Color textSecondary(BuildContext context) => _t(
    context,
    dark: const Color(0xFFC8D6E5),
    light: const Color(0xFF475569),
  );

  // ── Static Colors (Theme independent) ──────────────────────
  static const Color accent = Color(0xFFC8A96E);
  static const Color accentDim = Color(0x22C8A96E);
  static const Color accentBorder = Color(0x404ECDC4);

  static const Color danger = Color(0xFFE05C5C);
  static const Color success = Color(0xFF1D9E75);
  static const Color warning = Color(0xFFF5A623);
  static const Color info = Color(0xFF5B9BF8);

  static const Color coverGreen = Color(0xFF4CAF7D);
  static const Color coverBlue = Color(0xFF5B9BF8);
  static const Color coverPurple = Color(0xFF9B7FD4);
  static const Color coverTeal = Color(0xFF4DB6AC);
  static const Color coverOrange = Color(0xFF993C1D);
  static const Color coverPink = Color(0xFF993556);

  // Common
  static const Color transparent = Colors.transparent;
  static const Color primary = Color(0xFF06192B);
  static const Color blue = Color(0xFF059AE4);
  static const Color error = Color(0xFFEB5757);

  // Grey Scale
  static const grey50 = Color(0xFFF5F5F5);
  static const grey100 = Color(0xFFF0F0F0);
  static const grey200 = Color(0xFFEEEEEE);
  static const grey300 = Color(0xFFE0E0E0);
  static const grey400 = Color(0xFFBDBDBD);
  static const grey500 = Colors.grey;
  static const grey600 = Color(0xFF757575);
  static const grey700 = Color(0xFF616161);
  static const grey800 = Color(0xFF424242);
  static const grey900 = Color(0xFF212121);

  // Helper
  static Color _t(
    BuildContext context, {
    required Color dark,
    required Color light,
  }) {
    return Theme.of(context).brightness == Brightness.dark ? dark : light;
  }
}
