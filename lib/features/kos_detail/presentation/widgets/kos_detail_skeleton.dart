import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_shimmer.dart';

/// Skeleton loading Detail Kos — galeri full-bleed, judul+harga, bento
/// spesifikasi, kartu pemilik, dan bottom contact bar. Lihat [kMockNetworkDelay].
class KosDetailSkeleton extends StatelessWidget {
  const KosDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppShimmer(
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(bottom: 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerBox(
              height: 320,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(AppRadius.xl),
                bottomRight: Radius.circular(AppRadius.xl),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.gutter,
                AppSpacing.md,
                AppSpacing.gutter,
                0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerBox(width: 140, height: 12),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ShimmerBox(
                          height: 22,
                          borderRadius: BorderRadius.all(
                            Radius.circular(AppRadius.md),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      ShimmerBox(width: 90, height: 18),
                    ],
                  ),
                  SizedBox(height: 8),
                  ShimmerBox(width: 200, height: 12),
                  SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Expanded(child: ShimmerBox(height: 76)),
                      SizedBox(width: AppSpacing.sm),
                      Expanded(child: ShimmerBox(height: 76)),
                      SizedBox(width: AppSpacing.sm),
                      Expanded(child: ShimmerBox(height: 76)),
                      SizedBox(width: AppSpacing.sm),
                      Expanded(child: ShimmerBox(height: 76)),
                    ],
                  ),
                  SizedBox(height: AppSpacing.md),
                  ShimmerBox(
                    height: 68,
                    borderRadius: BorderRadius.all(
                      Radius.circular(AppRadius.lg),
                    ),
                  ),
                  SizedBox(height: AppSpacing.lg),
                  ShimmerBox(width: 120, height: 16),
                  SizedBox(height: AppSpacing.sm),
                  ShimmerBox(height: 12),
                  SizedBox(height: 6),
                  ShimmerBox(height: 12),
                  SizedBox(height: 6),
                  ShimmerBox(width: 180, height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
