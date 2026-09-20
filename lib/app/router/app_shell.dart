import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/bottom_nav.dart';

/// Cangkang tab utama — SATU bottom nav permanen untuk semua tab.
///
/// Nav hidup di shell, di luar konten branch yang dianimasikan go_router,
/// sehingga tidak ikut transisi/fade saat pindah page dan tidak di-rebuild.
/// Bonus: state tiap tab (scroll, filter, query) tetap terjaga karena
/// branch memakai IndexedStack.
///
/// Cara pakai untuk halaman baru: tambah branch di [appRouter] sesuai
/// urutan tab [KosankuBottomNav] (0 Explore, 1 Peta, 2 Favorit, 3 Chat,
/// 4 Profil), lalu ganti [TabPlaceholderPage] dengan page fitur aslinya.
/// Halaman drill-down (mis. Detail Kos) tetap route top-level di luar
/// shell supaya tampil tanpa bottom nav.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            navigationShell,
            Positioned(
              left: AppSpacing.gutter,
              right: AppSpacing.gutter,
              bottom: 20,
              child: KosankuBottomNav(
                currentIndex: navigationShell.currentIndex,
                // Dummy UI-first — badge pesan belum dibaca (prd.md §3.5).
                unreadChatCount: 2,
                onTap: navigationShell.goBranch,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Placeholder sementara untuk tab yang page-nya belum dibangun
/// (Peta, Chat, Profil). Flat ala DESIGN.md, tanpa shadow.
/// Hapus pemakaiannya saat page fitur asli sudah ada.
class TabPlaceholderPage extends StatelessWidget {
  const TabPlaceholderPage({
    super.key,
    required this.title,
    required this.icon,
  });

  final String title;
  final FaIconData icon;

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final muted =
        isLight ? AppColors.textSecondary : AppColors.darkTextSecondary;
    final circleBg =
        isLight ? AppColors.tertiary : AppColors.darkTertiary;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.gutter,
        AppSpacing.xl,
        AppSpacing.gutter,
        120, // inset bawah anti-tertutup bottom nav shell (DESIGN.md)
      ),
      child: Column(
        children: [
          const SizedBox(height: 64),
          Container(
            width: 72,
            height: 72,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: circleBg,
            ),
            child: FaIcon(icon, size: 26, color: muted),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(title, style: AppTypography.h2),
          const SizedBox(height: 4),
          Text(
            'Segera hadir — diganti page fitur aslinya.',
            textAlign: TextAlign.center,
            style: AppTypography.bodyMd.copyWith(color: muted),
          ),
        ],
      ),
    );
  }
}
