import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../widgets/profile_top_bar.dart';

/// Kelola Data Pribadi — drill-down form (tanpa bottom nav),
/// mengikuti screen Stitch "Kelola Data Pribadi (Mobile)".
class KelolaDataPribadiPage extends StatelessWidget {
  const KelolaDataPribadiPage({super.key});

  static const routeName = '/profile/data-pribadi';

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final surface = isLight ? AppColors.surface : AppColors.darkSurface;
    final border = isLight ? AppColors.border : AppColors.darkBorder;

    return Scaffold(
      backgroundColor: isLight ? AppColors.background : AppColors.darkBackground,
      body: SafeArea(
        child: Column(
          children: [
            const ProfileTopBar(title: 'Kelola Data Pribadi'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.gutter,
                  AppSpacing.md,
                  AppSpacing.gutter,
                  AppSpacing.xl,
                ),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: surface,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    border: Border.all(color: border),
                  ),
                  child: const Column(
                    children: [
                      _ProfileField(
                        label: 'NAMA LENGKAP',
                        hint: 'Contoh: Rian Pratama',
                        initialValue: 'Rian Pratama',
                        icon: FontAwesomeIcons.user,
                      ),
                      SizedBox(height: AppSpacing.md),
                      _ProfileField(
                        label: 'NOMOR WHATSAPP',
                        hint: '08xxxxxxxxxx',
                        initialValue: '0812-3456-7890',
                        icon: FontAwesomeIcons.comment,
                        keyboardType: TextInputType.phone,
                        badge: 'Kontak Aktif',
                      ),
                      SizedBox(height: AppSpacing.md),
                      _ProfileField(
                        label: 'ALAMAT EMAIL',
                        hint: 'nama@email.com',
                        initialValue: 'rian.pratama@email.com',
                        icon: FontAwesomeIcons.envelope,
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Field label uppercase + input pill berikon. Meniru field pada screen
/// "Kelola Data Pribadi" (label muted kecil, badge opsional, input full pill).
class _ProfileField extends StatelessWidget {
  const _ProfileField({
    required this.label,
    required this.hint,
    required this.icon,
    this.initialValue,
    this.keyboardType,
    this.badge,
  });

  final String label;
  final String hint;
  final FaIconData icon;
  final String? initialValue;
  final TextInputType? keyboardType;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final muted = isLight ? AppColors.textSecondary : AppColors.darkTextSecondary;
    final border = isLight ? AppColors.border : AppColors.darkBorder;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: AppSpacing.xs, bottom: 6),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: AppTypography.labelSm.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: muted,
                  ),
                ),
              ),
              if (badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.12),
                    borderRadius: AppRadius.radiusFull,
                  ),
                  child: Text(
                    badge!,
                    style: AppTypography.labelSm.copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.warning,
                    ),
                  ),
                ),
            ],
          ),
        ),
        TextFormField(
          initialValue: initialValue,
          keyboardType: keyboardType,
          style: AppTypography.bodyMd.copyWith(
            fontWeight: FontWeight.w500,
            color: isLight ? AppColors.textPrimary : AppColors.darkTextPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTypography.bodyMd.copyWith(color: muted),
            prefixIcon: SizedBox(
              width: 44,
              child: Center(
                child: FaIcon(icon, size: 16, color: muted),
              ),
            ),
            filled: true,
            fillColor: isLight ? AppColors.surface : AppColors.darkSurface,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
            border: OutlineInputBorder(
              borderRadius: AppRadius.radiusFull,
              borderSide: BorderSide(color: border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.radiusFull,
              borderSide: BorderSide(color: border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadius.radiusFull,
              borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ),
      ],
    );
  }
}
