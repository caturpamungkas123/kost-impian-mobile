import 'package:flutter/widgets.dart';

/// Mapping langsung dari DESIGN.md — rounded.
/// Full pill (9999) wajib untuk button, filter tag, search bar, bottom nav.
/// 24-32 untuk property card & image container.
class AppRadius {
  const AppRadius._();

  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double full = 9999;

  static const BorderRadius radiusSm = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius radiusMd = BorderRadius.all(Radius.circular(md));
  static const BorderRadius radiusLg = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius radiusXl = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius radiusFull = BorderRadius.all(Radius.circular(full));
}
