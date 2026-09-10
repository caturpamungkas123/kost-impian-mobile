import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Mapping langsung dari DESIGN.md — typography.
/// Font: Plus Jakarta Sans, hierarki tebal (600-700) untuk harga & nama kos.
class AppTypography {
  const AppTypography._();

  static TextStyle get h1 => GoogleFonts.plusJakartaSans(
        fontSize: 40,
        fontWeight: FontWeight.w700,
        height: 1.2,
        letterSpacing: -0.8,
      );

  static TextStyle get h2 => GoogleFonts.plusJakartaSans(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.3,
      );

  static TextStyle get bodyMd => GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  static TextStyle get labelSm => GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.33,
      );

  /// Display hero onboarding — mengacu ke Stitch "TEMUKAN KOS IMPIAN"
  /// (42px, extrabold, uppercase, tight).
  static TextStyle get displayHero => GoogleFonts.plusJakartaSans(
        fontSize: 42,
        fontWeight: FontWeight.w800,
        height: 1.05,
        letterSpacing: -1.68,
      );

  static TextStyle get ctaLabel => GoogleFonts.plusJakartaSans(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        height: 1.33,
      );
}
