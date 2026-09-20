import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_shimmer.dart';

/// Skeleton loading Auth — cerminan judul, tab switcher, role selector,
/// field pill, dan CTA. Lihat [kMockNetworkDelay].
class AuthSkeleton extends StatelessWidget {
  const AuthSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppShimmer(
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.gutter),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: AppSpacing.lg),
            ShimmerCircle(size: 52),
            SizedBox(height: AppSpacing.md),
            ShimmerBox(width: 180, height: 24),
            SizedBox(height: AppSpacing.sm),
            ShimmerBox(height: 12),
            SizedBox(height: 6),
            ShimmerBox(width: 220, height: 12),
            SizedBox(height: AppSpacing.lg),
            ShimmerBox(height: 48),
            SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(child: ShimmerBox(height: 64)),
                SizedBox(width: AppSpacing.sm),
                Expanded(child: ShimmerBox(height: 64)),
              ],
            ),
            SizedBox(height: AppSpacing.lg),
            ShimmerBox(height: 52),
            SizedBox(height: AppSpacing.md),
            ShimmerBox(height: 52),
            SizedBox(height: AppSpacing.md),
            ShimmerBox(height: 52),
            SizedBox(height: AppSpacing.lg),
            ShimmerBox(height: 52),
          ],
        ),
      ),
    );
  }
}
