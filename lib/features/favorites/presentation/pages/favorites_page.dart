import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/page_title.dart';
import '../../../explore/presentation/pages/explore_page.dart';
import '../../../explore/presentation/widgets/explore_widgets.dart'
    show FilterPills;
import '../../../kos_detail/presentation/pages/kos_detail_page.dart';
import '../widgets/favorite_card.dart';
import '../widgets/favorite_data.dart';
import '../widgets/favorites_skeleton.dart';
import '../widgets/favorites_store.dart';
import '../../../../core/widgets/app_shimmer.dart';

/// Laman Favorit — prd.md §3.4: kos tersimpan untuk dilihat kembali.
/// Referensi: Stitch `Favorit KosanKu`
/// (projects/3380788847386773914/screens/712edd62688a4949949d1bc64636305c).
/// UI-first: dummy + state lokal (filter, hapus favorit).
class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  static const routeName = '/favorites';

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  static const _baseFilters = ['Semua', 'Campur', 'Putri', 'Tersedia Segera'];

  String _selectedFilter = _baseFilters[0];
  late List<FavoriteKos> _items;
  late List<FavoriteKos> _visible;
  GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  // Simulasi fetch awal — hapus saat BLoC tersedia, diganti state loading asli.
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    // Baca dari store bersama (sinkron dengan toggle love di Explore).
    _items = List.of(favoritesStore.value);
    _visible = _applyFilter(_items, _selectedFilter);
    Future.delayed(kMockNetworkDelay, () {
      if (mounted) setState(() => _loading = false);
    });
  }

  static List<FavoriteKos> _applyFilter(List<FavoriteKos> items, String filter) {
    return items.where((kos) {
      switch (filter) {
        case 'Campur':
        case 'Putri':
          return kos.type == filter;
        case 'Tersedia Segera':
          return kos.urgencyBadge != null;
        default:
          return true;
      }
    }).toList();
  }

  void _changeFilter(String label) {
    setState(() {
      _selectedFilter = label.startsWith('Semua') ? 'Semua' : label;
      _visible = _applyFilter(_items, _selectedFilter);
      // Ganti kunci agar list me-reset penuh ikut filter baru.
      _listKey = GlobalKey<AnimatedListState>();
    });
  }

  /// Hapus dengan animasi menyusut — daftar tidak hilang seketika
  /// sehingga konten tidak "melompat" dan bottom nav terasa tetap.
  /// Hapus juga di store bersama agar hati di Explore ikut padam.
  void _remove(FavoriteKos item) {
    final index = _visible.indexOf(item);
    if (index < 0) return;
    _visible.removeAt(index);
    _items.removeWhere((e) => e.id == item.id);
    removeFavorite(item.id);
    _listKey.currentState?.removeItem(
      index,
      (context, animation) => SizeTransition(
        sizeFactor: animation,
        child: FavoriteKosCard(item: item, onRemove: () {}),
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: FavoritesSkeleton());
    }
    final scheme = Theme.of(context).colorScheme;
    final isLight = Theme.of(context).brightness == Brightness.light;
    final border = isLight ? AppColors.border : AppColors.darkBorder;
    final muted =
        isLight ? AppColors.textSecondary : AppColors.darkTextSecondary;
    final filters = [
      'Semua (${_items.length})',
      ..._baseFilters.skip(1),
    ];
    final selectedLabel = _selectedFilter == 'Semua'
        ? filters.first
        : _selectedFilter;

    return Scaffold(
      // Bottom nav disediakan permanen oleh AppShell — halaman ini
      // hanya konten, supaya tidak ikut animasi pindah page.
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.gutter,
          AppSpacing.sm,
          AppSpacing.gutter,
          120,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const PageTitle('Kos Favorit'),
                    Text(
                      '${_items.length} kos idaman tersimpan',
                      style: AppTypography.bodyMd.copyWith(
                        fontSize: 12,
                        color: muted,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    _CircleIconButton(
                      icon: FavoriteHeaderIcons.search,
                      border: border,
                      onTap: () {},
                    ),
                    const SizedBox(width: 8),
                    _CircleIconButton(
                      icon: FavoriteHeaderIcons.more,
                      border: border,
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            FilterPills(
              filters: filters,
              selected: selectedLabel,
              onSelected: _changeFilter,
            ),
            const SizedBox(height: AppSpacing.md),
            if (_visible.isEmpty)
              _EmptyState(
                hasAny: _items.isNotEmpty,
                onExplore: () => context.go(ExplorePage.routeName),
              )
            else ...[
              AnimatedList(
                key: _listKey,
                initialItemCount: _visible.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index, animation) {
                  final item = _visible[index];
                  return Padding(
                    padding: const EdgeInsets.only(
                      bottom: AppSpacing.md,
                    ),
                    child: FavoriteKosCard(
                      item: item,
                      onRemove: () => _remove(item),
                      onDetail: () =>
                          context.push(KosDetailPage.routeName),
                    ),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              _CompareBanner(
                count: _items.length,
                surface: scheme.surface,
                border: border,
                muted: muted,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({
    required this.icon,
    required this.border,
    required this.onTap,
  });

  final FaIconData icon;
  final Color border;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.surface,
          border: Border.all(color: border),
        ),
        child: FaIcon(icon, size: 15),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.hasAny, required this.onExplore});

  final bool hasAny;
  final VoidCallback onExplore;

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final muted =
        isLight ? AppColors.textSecondary : AppColors.darkTextSecondary;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Center(
        child: Column(
          children: [
            Container(
              width: 72,
              height: 72,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isLight
                    ? AppColors.tertiary
                    : AppColors.darkTertiary,
              ),
              child: FaIcon(
                FontAwesomeIcons.heart,
                size: 26,
                color: muted,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              hasAny ? 'Tidak ada hasil filter' : 'Belum ada favorit',
              style: AppTypography.labelSm.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              hasAny
                  ? 'Coba pilih filter lain.'
                  : 'Tap ikon hati di Explore untuk menyimpan kos.',
              style: AppTypography.bodyMd.copyWith(color: muted),
            ),
          ],
        ),
      ),
    );
  }
}

class _CompareBanner extends StatelessWidget {
  const _CompareBanner({
    required this.count,
    required this.surface,
    required this.border,
    required this.muted,
  });

  final int count;
  final Color surface;
  final Color border;
  final Color muted;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: const BorderRadius.all(
          Radius.circular(AppRadius.lg),
        ),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(AppRadius.md),
              ),
              color: scheme.primary.withValues(alpha: 0.06),
            ),
            child: FaIcon(
              FontAwesomeIcons.chartColumn,
              size: 18,
              color: scheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bingung pilih yang mana?',
                  style: AppTypography.labelSm.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Bandingkan $count kos sekaligus',
                  style: AppTypography.labelSm.copyWith(
                    fontSize: 11,
                    color: muted,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 7,
              ),
              decoration: BoxDecoration(
                color: scheme.primary,
                borderRadius: AppRadius.radiusFull,
              ),
              child: Text(
                'Bandingkan',
                style: AppTypography.labelSm.copyWith(
                  fontSize: 12,
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
