import 'package:flutter/material.dart';

/// Mapping langsung dari DESIGN.md — colors + colors-dark.
/// Jangan hardcode hex di widget, selalu pakai token ini.
class AppColors {
  const AppColors._();

  // Light (DESIGN.md `colors`)
  static const primary = Color(0xFF1A1A1A);
  static const secondary = Color(0xFFFFFFFF);
  static const tertiary = Color(0xFFF3F4F6);
  static const background = Color(0xFFF5F4F0);
  static const surface = Color(0xFFFFFFFF);
  static const textPrimary = Color(0xFF1A1A1A);
  static const textSecondary = Color(0xFF6B7280);
  static const border = Color(0xFFE5E7EB);
  static const success = Color(0xFF10B981);
  static const warning = Color(0xFFF59E0B);
  static const error = Color(0xFFEF4444);

  // Dark (DESIGN.md `colors-dark`)
  static const darkPrimary = Color(0xFFF5F4F0);
  static const darkSecondary = Color(0xFF1A1A1A);
  static const darkTertiary = Color(0xFF211F1C);
  static const darkBackground = Color(0xFF141311);
  static const darkSurface = Color(0xFF1F1D1A);
  static const darkTextPrimary = Color(0xFFF5F4F0);
  static const darkTextSecondary = Color(0xFF9C9890);
  static const darkBorder = Color(0xFF302D29);
  static const darkSuccess = Color(0xFF34D399);
  static const darkWarning = Color(0xFFFBBF24);
  static const darkError = Color(0xFFF87171);
}
