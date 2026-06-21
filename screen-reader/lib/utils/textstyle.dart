import 'package:flutter/material.dart';
import 'package:screen_reader/res/app_colors.dart';

const String fontFamily = "Poppins";

/// Base text style generator
TextStyle _baseTextStyle({
  required double fontSize,
  FontWeight fontWeight = FontWeight.normal,
  Color? color,
  BuildContext? context,
}) {
  final defaultColor = context != null
      ? AppColors.textPrimary(context)
      : const Color(0xFF0F1B2D); // fallback when context is null

  return TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color ?? defaultColor,
  );
}

// ── Regular Sizes ──────────────────────
TextStyle text8({
  FontWeight fontWeight = FontWeight.normal,
  Color? color,
  BuildContext? context,
}) => _baseTextStyle(
  fontSize: 8,
  fontWeight: fontWeight,
  color: color,
  context: context,
);

TextStyle text10({
  FontWeight fontWeight = FontWeight.normal,
  Color? color,
  BuildContext? context,
}) => _baseTextStyle(
  fontSize: 10,
  fontWeight: fontWeight,
  color: color,
  context: context,
);

TextStyle text11({
  FontWeight fontWeight = FontWeight.normal,
  Color? color,
  BuildContext? context,
}) => _baseTextStyle(
  fontSize: 11,
  fontWeight: fontWeight,
  color: color,
  context: context,
);

TextStyle text12({
  FontWeight fontWeight = FontWeight.normal,
  Color? color,
  BuildContext? context,
}) => _baseTextStyle(
  fontSize: 12,
  fontWeight: fontWeight,
  color: color,
  context: context,
);

TextStyle text13({
  FontWeight fontWeight = FontWeight.normal,
  Color? color,
  BuildContext? context,
}) => _baseTextStyle(
  fontSize: 13,
  fontWeight: fontWeight,
  color: color,
  context: context,
);

TextStyle text14({
  FontWeight fontWeight = FontWeight.normal,
  Color? color,
  BuildContext? context,
}) => _baseTextStyle(
  fontSize: 14,
  fontWeight: fontWeight,
  color: color,
  context: context,
);

TextStyle text15({
  FontWeight fontWeight = FontWeight.normal,
  Color? color,
  BuildContext? context,
}) => _baseTextStyle(
  fontSize: 15,
  fontWeight: fontWeight,
  color: color,
  context: context,
);

TextStyle text16({
  FontWeight fontWeight = FontWeight.normal,
  Color? color,
  BuildContext? context,
}) => _baseTextStyle(
  fontSize: 16,
  fontWeight: fontWeight,
  color: color,
  context: context,
);

// ── Larger / Heading Sizes ──────────────────────
TextStyle text18({
  FontWeight fontWeight = FontWeight.w600,
  Color? color,
  BuildContext? context,
}) => _baseTextStyle(
  fontSize: 18,
  fontWeight: fontWeight,
  color: color,
  context: context,
);

TextStyle text20({
  FontWeight fontWeight = FontWeight.w600,
  Color? color,
  BuildContext? context,
}) => _baseTextStyle(
  fontSize: 20,
  fontWeight: fontWeight,
  color: color,
  context: context,
);

TextStyle text24({
  FontWeight fontWeight = FontWeight.w700,
  Color? color,
  BuildContext? context,
}) => _baseTextStyle(
  fontSize: 24,
  fontWeight: fontWeight,
  color: color,
  context: context,
);

TextStyle text26({
  FontWeight fontWeight = FontWeight.w700,
  Color? color,
  BuildContext? context,
}) => _baseTextStyle(
  fontSize: 26,
  fontWeight: fontWeight,
  color: color,
  context: context,
);

TextStyle text30({
  FontWeight fontWeight = FontWeight.w700,
  Color? color,
  BuildContext? context,
}) => _baseTextStyle(
  fontSize: 30,
  fontWeight: fontWeight,
  color: color,
  context: context,
);

TextStyle text40({
  FontWeight fontWeight = FontWeight.w700,
  Color? color,
  BuildContext? context,
}) => _baseTextStyle(
  fontSize: 40,
  fontWeight: fontWeight,
  color: color,
  context: context,
);
