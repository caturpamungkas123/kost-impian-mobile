import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_shimmer.dart';

/// Skeleton loading Explore — cerminan layout asli (header, search pill,
/// filter pills, section, kartu) dengan bentuk pill/rounded per DESIGN.md.
/// Ditampilkan selama state loading; diganti data asli dari BLoC
/// saat fase business logic (sementara: jeda [kMockNetworkDelay]).
class ExploreSkeleton extends StatelessWidget {
  const ExploreSkeleton({super.key});

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
                    ShimmerBox(width: 120, height: 12),
                    SizedBox(height: 8),
                    ShimmerBox(
                      width: 150,
                      height: 22,
                      borderRadius: BorderRadius.all(
                        Radius.circular(AppRadius.md),
                      ),
                    ),
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
                ShimmerBox(width: 90, height: 32),
                SizedBox(width: 8),
                ShimmerBox(width: 64, height: 32),
                SizedBox(width: 8),
                ShimmerBox(width: 76, height: 32),
              ],
            ),
            SizedBox(height: AppSpacing.lg),
            ShimmerBox(width: 140, height: 18),
            SizedBox(height: AppSpacing.sm),
            _SkeletonKosCard(imageHeight: 176),
            SizedBox(height: AppSpacing.lg),
            ShimmerBox(width: 180, height: 18),
            SizedBox(height: AppSpacing.sm),
            _SkeletonKosCard(imageHeight: 144),
          ],
        ),
      ),
    );
  }
}

class _SkeletonKosCard extends StatelessWidget {
  const _SkeletonKosCard({required this.imageHeight});

  final double imageHeight;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShimmerBox(
          height: imageHeight,
          borderRadius: const BorderRadius.all(
            Radius.circular(AppRadius.md),
          ),
        ),
        const SizedBox(height: 10),
        const Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerBox(width: 150, height: 15),
                  SizedBox(height: 6),
                  ShimmerBox(width: 110, height: 11),
                ],
              ),
            ),
            ShimmerBox(width: 80, height: 15),
          ],
        ),
        const SizedBox(height: 8),
        const Row(
          children: [
            Expanded(child: ShimmerBox(height: 30)),
            SizedBox(width: 6),
            Expanded(child: ShimmerBox(height: 30)),
            SizedBox(width: 6),
            Expanded(child: ShimmerBox(height: 30)),
          ],
        ),
      ],
    );
  }
}
