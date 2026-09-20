import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Top bar drill-down Profil — back arrow, judul tengah, tombol Simpan pill.
/// Dipakai bersama oleh halaman Kelola Data Pribadi & Keamanan.
class ProfileTopBar extends StatelessWidget {
  const ProfileTopBar({
    super.key,
    required this.title,
    this.onSave,
  });

  final String title;
  final VoidCallback? onSave;

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final scheme = Theme.of(context).colorScheme;
    final border = isLight ? AppColors.border : AppColors.darkBorder;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.gutter,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: border.withValues(alpha: 0.5))),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 36,
            height: 36,
            child: InkWell(
              onTap: () => Navigator.of(context).maybePop(),
              borderRadius: BorderRadius.circular(AppRadius.full),
              child: Center(
                child: FaIcon(
                  FontAwesomeIcons.arrowLeft,
                  size: 20,
                  color: isLight ? AppColors.textPrimary : AppColors.darkTextPrimary,
                ),
              ),
            ),
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: AppTypography.bodyMd.copyWith(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: isLight ? AppColors.textPrimary : AppColors.darkTextPrimary,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: scheme.primary,
              borderRadius: AppRadius.radiusFull,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onSave ?? () {},
                borderRadius: AppRadius.radiusFull,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: Text(
                    'Simpan',
                    style: AppTypography.labelSm.copyWith(
                      fontWeight: FontWeight.w700,
                      color: scheme.onPrimary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
