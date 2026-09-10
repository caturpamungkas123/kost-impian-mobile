import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Peran akun — syarat PRD §3.1: dipilih saat registrasi
/// (Pencari Kos gratis penuh vs Pemilik Kos tenant berlangganan).
enum AuthRole { seeker, owner }

extension AuthRoleLabel on AuthRole {
  String get title => this == AuthRole.seeker ? 'Pencari Kos' : 'Pemilik Kos';
  String get subtitle => this == AuthRole.seeker
      ? 'Cari kos gratis & direct WhatsApp'
      : 'Kelola listing & langganan SaaS';
  FaIconData get icon =>
      this == AuthRole.seeker ? FontAwesomeIcons.house : FontAwesomeIcons.building;
}

/// Kartu pilih peran 2 kolom. Selected: border primary 2px + indikator check.
class RoleSelector extends StatelessWidget {
  const RoleSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final AuthRole selected;
  final ValueChanged<AuthRole> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isLight = Theme.of(context).brightness == Brightness.light;
    final border = isLight ? AppColors.border : AppColors.darkBorder;
    final muted =
        isLight ? AppColors.textSecondary : AppColors.darkTextSecondary;

    Widget card(AuthRole role) {
      final active = role == selected;
      return Expanded(
        child: GestureDetector(
          onTap: () => onChanged(role),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: const BorderRadius.all(
                Radius.circular(AppRadius.lg),
              ),
              border: Border.all(
                color: active ? scheme.primary : border,
                width: active ? 2 : 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isLight
                            ? AppColors.background
                            : AppColors.darkBackground,
                      ),
                      child: FaIcon(role.icon, size: 14, color: muted),
                    ),
                    Container(
                      width: 20,
                      height: 20,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: active ? scheme.primary : Colors.transparent,
                        border: active
                            ? null
                            : Border.all(color: border),
                      ),
                      child: active
                          ? FaIcon(
                              FontAwesomeIcons.check,
                              size: 10,
                              color: scheme.onPrimary,
                            )
                          : null,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  role.title,
                  style: AppTypography.labelSm.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  role.subtitle,
                  style: AppTypography.labelSm.copyWith(
                    fontSize: 10,
                    color: muted,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'PILIH PERAN ANDA',
              style: AppTypography.labelSm.copyWith(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: muted,
              ),
            ),
            Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  'Fleksibel & Gratis',
                  style: AppTypography.labelSm.copyWith(
                    fontSize: 11,
                    color: isLight
                        ? AppColors.success
                        : AppColors.darkSuccess,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            card(AuthRole.seeker),
            const SizedBox(width: 10),
            card(AuthRole.owner),
          ],
        ),
      ],
    );
  }
}
