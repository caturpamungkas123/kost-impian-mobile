import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_shimmer.dart';

/// Skeleton loading inbox chat — header, search pill, filter, 4 tile.
/// Lihat [kMockNetworkDelay].
class ChatListSkeleton extends StatelessWidget {
  const ChatListSkeleton({super.key});

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
                      width: 170,
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
            ShimmerBox(height: 48),
            SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                ShimmerBox(width: 76, height: 32),
                SizedBox(width: 8),
                ShimmerBox(width: 110, height: 32),
                SizedBox(width: 8),
                ShimmerBox(width: 130, height: 32),
              ],
            ),
            SizedBox(height: AppSpacing.md),
            _SkeletonTile(),
            _SkeletonTile(),
            _SkeletonTile(),
            _SkeletonTile(),
          ],
        ),
      ),
    );
  }
}

class _SkeletonTile extends StatelessWidget {
  const _SkeletonTile();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          ShimmerCircle(size: 52),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: ShimmerBox(height: 14)),
                    SizedBox(width: 8),
                    ShimmerBox(width: 40, height: 11),
                  ],
                ),
                SizedBox(height: 6),
                ShimmerBox(width: 130, height: 11),
                SizedBox(height: 6),
                ShimmerBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Skeleton loading thread chat — header, kartu kos, bubble selang-seling.
class ChatThreadSkeleton extends StatelessWidget {
  const ChatThreadSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppShimmer(
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          AppSpacing.gutter,
          AppSpacing.sm,
          AppSpacing.gutter,
          AppSpacing.md,
        ),
        child: Column(
          children: [
            Row(
              children: [
                ShimmerCircle(),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerBox(width: 130, height: 14),
                      SizedBox(height: 6),
                      ShimmerBox(width: 170, height: 11),
                    ],
                  ),
                ),
                ShimmerCircle(),
                SizedBox(width: 8),
                ShimmerCircle(),
              ],
            ),
            SizedBox(height: AppSpacing.md),
            ShimmerBox(
              height: 76,
              borderRadius:
                  BorderRadius.all(Radius.circular(AppRadius.lg)),
            ),
            SizedBox(height: AppSpacing.md),
            Align(
              alignment: Alignment.centerRight,
              child: ShimmerBox(width: 220, height: 64),
            ),
            SizedBox(height: AppSpacing.sm),
            Align(
              alignment: Alignment.centerLeft,
              child: ShimmerBox(width: 240, height: 80),
            ),
            SizedBox(height: AppSpacing.sm),
            Align(
              alignment: Alignment.centerRight,
              child: ShimmerBox(width: 180, height: 48),
            ),
          ],
        ),
      ),
    );
  }
}
