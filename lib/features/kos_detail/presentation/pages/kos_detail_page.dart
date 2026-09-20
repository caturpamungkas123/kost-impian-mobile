import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../widgets/kos_detail_data.dart';
import '../widgets/kos_detail_skeleton.dart';
import '../widgets/kos_detail_widgets.dart';

/// Detail Kos — prd.md §3.3 & §4 langkah 5-7:
/// galeri, nama + harga, alamat, spesifikasi, fasilitas, pemilik
/// (Chat di Aplikasi + WhatsApp `wa.me` client-only), peta.
///
/// Referensi: Stitch `Detail KosanKu Urban Kemang`
/// (projects/3380788847386773914/screens/50e4931354384a4b904c36f62d9abb8c).
/// UI-first: dummy + StatefulWidget lokal (index galeri, favorit, expand).
class KosDetailPage extends StatefulWidget {
  const KosDetailPage({super.key});

  static const routeName = '/kos-detail';

  @override
  State<KosDetailPage> createState() => _KosDetailPageState();
}

class _KosDetailPageState extends State<KosDetailPage> {
  int _galleryIndex = 0;
  bool _isFavorite = false;
  bool _expanded = false;
  // Simulasi fetch awal — hapus saat BLoC tersedia, diganti state loading asli.
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(kMockNetworkDelay, () {
      if (mounted) setState(() => _loading = false);
    });
  }

  /// Deep link WA prd §7.4 — hanya aktif bila nomor valid ada di data kos.
  /// Murni client-side, tanpa proses backend.
  String? get _waLink {
    final phone = dummyKosDetail.ownerPhone;
    if (phone.isEmpty) return null;
    final text = Uri.encodeComponent(
      'Halo, saya tertarik dengan ${dummyKosDetail.name}. '
      'Apakah masih tersedia?',
    );
    return 'https://wa.me/$phone?text=$text';
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: SafeArea(
          top: false,
          child: KosDetailSkeleton(),
        ),
      );
    }
    final scheme = Theme.of(context).colorScheme;
    final isLight = Theme.of(context).brightness == Brightness.light;
    final muted =
        isLight ? AppColors.textSecondary : AppColors.darkTextSecondary;
    final border = isLight ? AppColors.border : AppColors.darkBorder;
    final detail = dummyKosDetail;

    return Scaffold(
      body: SafeArea(
        top: false,
        child: Stack(
          fit: StackFit.expand,
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DetailGallery(
                    images: detail.gallery,
                    index: _galleryIndex,
                    onIndexChanged: (i) => setState(() => _galleryIndex = i),
                    badge: detail.badge,
                    remainingLabel: detail.remainingLabel,
                    isFavorite: _isFavorite,
                    onFavoriteToggle: () =>
                        setState(() => _isFavorite = !_isFavorite),
                    onBack: () => context.canPop()
                        ? context.pop()
                        : context.go('/explore'),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.gutter,
                      AppSpacing.md,
                      AppSpacing.gutter,
                      0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.solidStar,
                              size: 13,
                              color: isLight
                                  ? AppColors.warning
                                  : AppColors.darkWarning,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${detail.rating}',
                              style: AppTypography.labelSm.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              ' (${detail.reviewCount} ulasan)',
                              style: AppTypography.labelSm.copyWith(
                                fontSize: 12,
                                color: muted,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: scheme.primary,
                                borderRadius: AppRadius.radiusFull,
                              ),
                              child: Text(
                                'Unggulan',
                                style: AppTypography.labelSm.copyWith(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: scheme.onPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                detail.name,
                                style: AppTypography.h2.copyWith(fontSize: 22),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  detail.price,
                                  style: AppTypography.labelSm.copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  detail.priceSuffix,
                                  style: AppTypography.labelSm.copyWith(
                                    fontSize: 11,
                                    color: muted,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.locationDot,
                              size: 12,
                              color: muted,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                '${detail.address} • ${detail.area}',
                                style: AppTypography.bodyMd.copyWith(
                                  fontSize: 12,
                                  color: muted,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        const SpecBento(),
                        const SizedBox(height: AppSpacing.md),
                        OwnerCard(onChatTap: () {}),
                        const SizedBox(height: AppSpacing.lg),
                        const DetailSectionTitle(title: 'Deskripsi Kosan'),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          kosDescription,
                          maxLines: _expanded ? null : 3,
                          overflow:
                              _expanded ? null : TextOverflow.ellipsis,
                          style: AppTypography.bodyMd.copyWith(color: muted),
                        ),
                        GestureDetector(
                          onTap: () =>
                              setState(() => _expanded = !_expanded),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(vertical: 4),
                            child: Text(
                              _expanded
                                  ? 'Tutup'
                                  : 'Selengkapnya',
                              style: AppTypography.labelSm.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        const DetailSectionTitle(
                          title: 'Fasilitas Kos',
                          trailing: '8 fasilitas',
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                            mainAxisExtent: 44,
                          ),
                          itemCount: dummyFacilities.length,
                          itemBuilder: (context, i) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                            ),
                            decoration: BoxDecoration(
                              color: scheme.surface,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(AppRadius.md),
                              ),
                              border: Border.all(color: border),
                            ),
                            child: Row(
                              children: [
                                FaIcon(
                                  dummyFacilities[i].icon,
                                  size: 14,
                                  color: muted,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    dummyFacilities[i].label,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTypography.labelSm.copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        const DetailSectionTitle(
                          title: 'Tipe Kamar Tersedia',
                          trailing: '2 tipe',
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        for (var i = 0;
                            i < dummyRoomTypes.length;
                            i++) ...[
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: scheme.surface,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(AppRadius.lg),
                              ),
                              border: Border.all(color: border),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        dummyRoomTypes[i].name,
                                        style:
                                            AppTypography.labelSm.copyWith(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        dummyRoomTypes[i].size,
                                        style:
                                            AppTypography.labelSm.copyWith(
                                          fontSize: 11,
                                          color: muted,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        dummyRoomTypes[i].price,
                                        style:
                                            AppTypography.labelSm.copyWith(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: (isLight
                                            ? AppColors.success
                                            : AppColors.darkSuccess)
                                        .withValues(alpha: 0.15),
                                    borderRadius: AppRadius.radiusFull,
                                  ),
                                  child: Text(
                                    dummyRoomTypes[i].status,
                                    style: AppTypography.labelSm.copyWith(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: isLight
                                          ? AppColors.success
                                          : AppColors.darkSuccess,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (i < dummyRoomTypes.length - 1)
                            const SizedBox(height: AppSpacing.sm),
                        ],
                        const SizedBox(height: AppSpacing.lg),
                        const DetailSectionTitle(
                          title: 'Lokasi & Akses',
                          trailing: 'Buka di Maps',
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Container(
                          height: 148,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: isLight
                                ? AppColors.tertiary
                                : AppColors.darkTertiary,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(AppRadius.lg),
                            ),
                            border: Border.all(color: border),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: scheme.primary,
                                ),
                                child: FaIcon(
                                  FontAwesomeIcons.locationDot,
                                  size: 17,
                                  color: scheme.onPrimary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                detail.area,
                                style: AppTypography.labelSm.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                '500 m dari Stasiun • Dekat MRT',
                                style: AppTypography.labelSm.copyWith(
                                  fontSize: 11,
                                  color: muted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: AppSpacing.gutter,
              right: AppSpacing.gutter,
              bottom: 20,
              child: _BottomContactBar(
                price: detail.price,
                suffix: detail.priceSuffix,
                waEnabled: _waLink != null,
                onWaTap: () {},
                onChatTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Bar bawah sticky: harga + WA (secondary) + Chat di Aplikasi (primary).
/// Flat, pill, tanpa shadow — kecuali blur tipis ala bottom nav.
class _BottomContactBar extends StatelessWidget {
  const _BottomContactBar({
    required this.price,
    required this.suffix,
    required this.waEnabled,
    required this.onWaTap,
    required this.onChatTap,
  });

  final String price;
  final String suffix;
  final bool waEnabled;
  final VoidCallback onWaTap;
  final VoidCallback onChatTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isLight = Theme.of(context).brightness == Brightness.light;
    final muted =
        isLight ? AppColors.textSecondary : AppColors.darkTextSecondary;
    final border = isLight ? AppColors.border : AppColors.darkBorder;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 10, 10),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: AppRadius.radiusFull,
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  price,
                  style: AppTypography.labelSm.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  suffix,
                  style: AppTypography.labelSm.copyWith(
                    fontSize: 10,
                    color: muted,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: waEnabled ? onWaTap : null,
            child: Opacity(
              opacity: waEnabled ? 1 : 0.4,
              child: Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isLight
                      ? AppColors.tertiary
                      : AppColors.darkTertiary,
                  border: Border.all(color: border),
                ),
                child: const FaIcon(
                  FontAwesomeIcons.whatsapp,
                  size: 22,
                  color: Color(0xFF25D366),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onChatTap,
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: scheme.primary,
                borderRadius: AppRadius.radiusFull,
              ),
              child: Text(
                'Chat di Aplikasi',
                style: AppTypography.labelSm.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: scheme.onPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
