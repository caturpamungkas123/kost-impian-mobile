import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../auth/presentation/pages/auth_page.dart';
import '../widgets/profile_menu_item.dart';
import 'keamanan_page.dart';
import 'kelola_data_pribadi_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static const routeName = '/profile';

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
      backgroundColor: isLight ? AppColors.background : AppColors.darkBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.gutter,
          AppSpacing.xl,
          AppSpacing.gutter,
          120,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.sm),
            Text(
              'PENGATURAN AKUN',
              style: AppTypography.labelSm.copyWith(
                color: isLight ? AppColors.textSecondary : AppColors.darkTextSecondary,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Container(
              decoration: BoxDecoration(
                color: isLight ? AppColors.surface : AppColors.darkSurface,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  ProfileMenuItem(
                    icon: FontAwesomeIcons.user,
                    title: 'Kelola Data Pribadi',
                    subtitle: 'Nama, nomor telepon, email, dan alamat',
                    onTap: () => context.push(KelolaDataPribadiPage.routeName),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    child: Divider(
                      height: 1,
                      color: isLight ? AppColors.border : AppColors.darkBorder,
                    ),
                  ),
                  ProfileMenuItem(
                    icon: FontAwesomeIcons.lock,
                    title: 'Keamanan & Kata Sandi',
                    subtitle: 'Ubah password, autentikasi 2-langkah',
                    onTap: () => context.push(KeamananPage.routeName),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                // `go` menimpa stack → tidak bisa back ke halaman profil.
                onPressed: () => context.go(AuthPage.loginRoute),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  side: const BorderSide(color: AppColors.error, width: 1.5),
                  backgroundColor: Colors.transparent,
                ),
                icon: const FaIcon(
                  FontAwesomeIcons.arrowRightFromBracket,
                  size: 16,
                  color: AppColors.error,
                ),
                label: Text(
                  'Keluar dari Akun',
                  style: AppTypography.ctaLabel.copyWith(color: AppColors.error),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Center(
              child: Column(
                children: [
                  Text(
                    'Hapus Akun Saya',
                    style: AppTypography.bodyMd.copyWith(
                      color: isLight ? AppColors.textSecondary : AppColors.darkTextSecondary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'KosanKu v2.4.0',
                    style: AppTypography.labelSm.copyWith(
                      color: isLight ? AppColors.textSecondary : AppColors.darkTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
