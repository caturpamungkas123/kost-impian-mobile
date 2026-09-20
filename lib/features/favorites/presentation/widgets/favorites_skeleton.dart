import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_shimmer.dart';

/// Skeleton loading Favorit — cerminan header, filter pills, dan kartu
/// favorit (gambar 192 + info + amenity + rating). Lihat juga [kMockNetworkDelay].
class FavoritesSkeleton extends StatelessWidget {
  const FavoritesSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppShimmer(
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          AppSpacing.gutter,
          AppSpacing.sm,
          AppSpacing.gutter,
          120,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerBox(
                      width: 130,
                      height: 22,
                      borderRadius: BorderRadius.all(
                        Radius.circular(AppRadius.md),
                      ),
                    ),
                    SizedBox(height: 6),
                    ShimmerBox(width: 150, height: 12),
                  ],
                ),
                Row(
                  children: [
                    ShimmerCircle(),
                    SizedBox(width: 8),
                    ShimmerCircle(),
                  ],
                ),
              ],
            ),
            SizedBox(height: AppSpacing.md),
            Row(
              children: [
                ShimmerBox(width: 84, height: 32),
                SizedBox(width: 8),
                ShimmerBox(width: 76, height: 32),
                SizedBox(width: 8),
                ShimmerBox(width: 64, height: 32),
              ],
            ),
            SizedBox(height: AppSpacing.md),
            _SkeletonFavoriteCard(),
            SizedBox(height: AppSpacing.md),
            _SkeletonFavoriteCard(),
          ],
        ),
      ),
    );
  }
}

class _SkeletonFavoriteCard extends StatelessWidget {
  const _SkeletonFavoriteCard();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShimmerBox(
          height: 192,
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.lg)),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerBox(width: 170, height: 16),
                  SizedBox(height: 6),
                  ShimmerBox(width: 130, height: 12),
                ],
              ),
            ),
            ShimmerBox(width: 90, height: 14),
          ],
        ),
        SizedBox(height: 10),
        Row(
          children: [
            ShimmerBox(width: 100, height: 24),
            SizedBox(width: 6),
            ShimmerBox(width: 80, height: 24),
          ],
        ),
      ],
    );
  }
}
