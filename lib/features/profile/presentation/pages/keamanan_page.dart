import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../widgets/profile_top_bar.dart';

/// Keamanan & Kata Sandi — drill-down form (tanpa bottom nav),
/// mengikuti screen Stitch "Keamanan KosanKu (Mobile)".
class KeamananPage extends StatelessWidget {
  const KeamananPage({super.key});

  static const routeName = '/profile/keamanan';

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final surface = isLight ? AppColors.surface : AppColors.darkSurface;
    final border = isLight ? AppColors.border : AppColors.darkBorder;
    final muted = isLight ? AppColors.textSecondary : AppColors.darkTextSecondary;

    return Scaffold(
      backgroundColor: isLight ? AppColors.background : AppColors.darkBackground,
      body: SafeArea(
        child: Column(
          children: [
            const ProfileTopBar(title: 'Keamanan & Kata Sandi'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.gutter,
                  AppSpacing.md,
                  AppSpacing.gutter,
                  AppSpacing.xl,
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: surface,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        border: Border.all(color: border),
                      ),
                      child: Column(
                        children: [
                          const _PasswordField(
                            label: 'KATA SANDI SAAT INI',
                            hint: 'Masukkan kata sandi lama',
                          ),
                          const SizedBox(height: AppSpacing.md),
                          const _PasswordField(
                            label: 'KATA SANDI BARU',
                            hint: 'Minimal 8 karakter',
                          ),
                          const SizedBox(height: AppSpacing.md),
                          const _PasswordField(
                            label: 'KONFIRMASI KATA SANDI BARU',
                            hint: 'Ulangi kata sandi baru',
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                'Lupa kata sandi?',
                                style: AppTypography.labelSm.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.warning,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isLight ? AppColors.tertiary : AppColors.darkTertiary,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border: Border.all(color: border),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: FaIcon(
                              FontAwesomeIcons.shield,
                              size: 16,
                              color: muted,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              'Gunakan kombinasi minimal 8 karakter dengan huruf kapital, angka, dan simbol untuk keamanan maksimal akun KosanKu Anda.',
                              style: AppTypography.labelSm.copyWith(
                                fontSize: 11,
                                height: 1.5,
                                color: muted,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Input kata sandi pill berikon lock + aksi toggle visibilitas.
/// State lokal visibilitas (bukan business logic) — aman di StatefulWidget.
class _PasswordField extends StatefulWidget {
  const _PasswordField({required this.label, required this.hint});

  final String label;
  final String hint;

  @override
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  bool _obscure = true;

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
          child: Text(
            widget.label,
            style: AppTypography.labelSm.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
              color: muted,
            ),
          ),
        ),
        TextFormField(
          obscureText: _obscure,
          style: AppTypography.bodyMd.copyWith(
            fontWeight: FontWeight.w500,
            color: isLight ? AppColors.textPrimary : AppColors.darkTextPrimary,
          ),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: AppTypography.bodyMd.copyWith(color: muted),
            prefixIcon: SizedBox(
              width: 44,
              child: Center(child: FaIcon(FontAwesomeIcons.lock, size: 16, color: muted)),
            ),
            suffixIcon: IconButton(
              onPressed: () => setState(() => _obscure = !_obscure),
              icon: FaIcon(
                _obscure ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye,
                size: 16,
                color: muted,
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
