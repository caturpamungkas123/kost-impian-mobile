import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class ProfileMenuItem extends StatelessWidget {
  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  final dynamic icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isLight ? AppColors.tertiary : AppColors.darkTertiary,
              ),
              child: Center(
                child: icon is IconData
                    ? Icon(
                        icon,
                        size: 16,
                        color: isLight ? AppColors.textPrimary : AppColors.darkTextPrimary,
                      )
                    : FaIcon(
                        icon,
                        size: 16,
                        color: isLight ? AppColors.textPrimary : AppColors.darkTextPrimary,
                      ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.bodyMd.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isLight ? AppColors.textPrimary : AppColors.darkTextPrimary,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: AppTypography.labelSm.copyWith(
                        color: isLight ? AppColors.textSecondary : AppColors.darkTextSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            trailing ??
                FaIcon(
                  FontAwesomeIcons.chevronRight,
                  size: 14,
                  color: isLight ? AppColors.textSecondary : AppColors.darkTextSecondary,
                ),
          ],
        ),
      ),
    );
  }
}
