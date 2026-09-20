import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';

/// Simulasi jeda network khusus fase UI-first supaya skeleton shimmer
/// terlihat sebelum data dummy tampil.
///
/// HAPUS beserta seluruh pemakaiannya saat fase business logic dimulai —
/// diganti state loading asli dari BLoC (tabel prd.md §6 via Dio).
const kMockNetworkDelay = Duration(milliseconds: 900);

/// Pembungkus shimmer yang sadar tema (DESIGN.md light + colors-dark).
/// Flat, tanpa shadow — kilauannya hanya dari gradasi base → highlight.
class AppShimmer extends StatelessWidget {
  const AppShimmer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final base = isLight ? AppColors.border : AppColors.darkBorder;
    final highlight = isLight
        ? AppColors.surface
        // Satu step lebih terang dari base agar sapuan terlihat di dark mode.
        : Color.lerp(AppColors.darkBorder, AppColors.darkTextPrimary, 0.25)!;
    return Shimmer.fromColors(
      baseColor: base,
      highlightColor: highlight,
      child: child,
    );
  }
}

/// Kotak placeholder rounded — cerminan card/image/chip per DESIGN.md
/// (pill 9999 untuk bar, 16–32 untuk blok besar).
class ShimmerBox extends StatelessWidget {
  const ShimmerBox({
    super.key,
    this.width,
    this.height = 14,
    this.borderRadius = AppRadius.radiusFull,
  });

  final double? width;
  final double height;
  final BorderRadiusGeometry borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white, // diwarnai ulang oleh Shimmer.fromColors
        borderRadius: borderRadius,
      ),
    );
  }
}

/// Lingkaran placeholder (avatar, tombol ikon).
class ShimmerCircle extends StatelessWidget {
  const ShimmerCircle({super.key, this.size = 40});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: const DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
