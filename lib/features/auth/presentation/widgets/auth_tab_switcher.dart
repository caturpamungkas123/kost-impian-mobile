import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Switcher pill Masuk / Daftar Akun — active state memakai primary
/// (hitam di light, krem di dark) sesuai DESIGN.md filter pills.
class AuthTabSwitcher extends StatelessWidget {
  const AuthTabSwitcher({
    super.key,
    required this.isLogin,
    required this.onChanged,
  });

  final bool isLogin;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isLight = Theme.of(context).brightness == Brightness.light;
    final muted =
        isLight ? AppColors.textSecondary : AppColors.darkTextSecondary;

    Widget tab(String label, bool active, VoidCallback onTap) {
      return Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: active ? scheme.primary : Colors.transparent,
              borderRadius: AppRadius.radiusFull,
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: AppTypography.labelSm.copyWith(
                fontWeight: FontWeight.w700,
                color: active ? scheme.onPrimary : muted,
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isLight ? AppColors.tertiary : AppColors.darkTertiary,
        borderRadius: AppRadius.radiusFull,
      ),
      child: Row(
        children: [
          tab('Masuk', isLogin, () => onChanged(true)),
          const SizedBox(width: AppSpacing.xs),
          tab('Daftar Akun', !isLogin, () => onChanged(false)),
        ],
      ),
    );
  }
}
