import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../favorites/presentation/widgets/favorite_data.dart';
import '../../../favorites/presentation/widgets/favorites_store.dart';
import '../../../kos_detail/presentation/pages/kos_detail_page.dart';
import '../widgets/explore_skeleton.dart';
import '../widgets/explore_widgets.dart';
import '../widgets/kos_card.dart';
import '../widgets/kos_listing.dart';

/// Laman Explore Kos — alur prd.md §4 langkah 3-4:
/// cari (kata kunci + filter tipe/harga/fasilitas), hasil dengan
/// Featured tampil lebih dahulu, badge "Unggulan".
///
/// Referensi: Stitch `Explore KosanKu`
/// (projects/3380788847386773914/screens/883ea09f140a49878c6c9c652da6b315).
/// UI-first: dummy data + state lokal (query, filter, favorit).
class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  static const routeName = '/explore';

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  static const filters = [
    'Semua Tipe',
    'Putri',
    'Putra',
    'Campur',
    '< Rp 2 Jt',
    'AC & WiFi',
  ];

  String _selectedFilter = filters[0];
  String _query = '';
  // Simulasi fetch awal — hapus saat BLoC tersedia, diganti state loading asli.
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(kMockNetworkDelay, () {
      if (mounted) setState(() => _loading = false);
    });
  }

  /// Favorit dibaca dari [favoritesStore] bersama (bukan Set lokal),
  /// supaya sinkron dua arah dengan halaman Favorit (prd.md §3.4).

  List<KosListing> get _filtered {
    return dummyKosList.where((kos) {
      final matchType =
          _selectedFilter == 'Semua Tipe' || kos.type == _selectedFilter;
      final q = _query.trim().toLowerCase();
      final matchQuery = q.isEmpty ||
          kos.name.toLowerCase().contains(q) ||
          kos.location.toLowerCase().contains(q);
      return matchType && matchQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // Dengarkan store agar hati di Explore ikut update saat item
    // dihapus dari halaman Favorit (dan sebaliknya).
    return ValueListenableBuilder<List<FavoriteKos>>(
      valueListenable: favoritesStore,
      builder: (context, favs, _) {
        if (_loading) {
          return const Scaffold(body: ExploreSkeleton());
        }
        final favIds = {for (final fav in favs) fav.id};
        final results = _filtered;
        final featured = results.where((k) => k.isFeatured).toList();
        final nearby = results.where((k) => !k.isFeatured).toList();

        return Scaffold(
          // Bottom nav disediakan permanen oleh AppShell — halaman ini
          // hanya konten, supaya tidak ikut animasi pindah page.
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.gutter,
              AppSpacing.sm,
              AppSpacing.gutter,
              120, // inset bawah anti-tertutup bottom nav shell (DESIGN.md)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ExploreHeader(),
                const SizedBox(height: AppSpacing.md),
                ExploreSearchBar(
                  onChanged: (v) => setState(() => _query = v),
                  onFilterTap: () {},
                ),
                const SizedBox(height: AppSpacing.sm),
                FilterPills(
                  filters: filters,
                  selected: _selectedFilter,
                  onSelected: (f) => setState(() => _selectedFilter = f),
                ),
                if (featured.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.lg),
                  const SectionHeader(
                    title: 'Kos Unggulan',
                    trailing: 'Lihat semua',
                    proTag: true,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  for (final kos in featured)
                    KosCard(
                      listing: kos,
                      imageHeight: 176,
                      isFavorite: favIds.contains(kos.id),
                      onFavoriteToggle: () =>
                          toggleFavoriteFromListing(kos),
                      // prd.md §4 langkah 5: tap card → Detail Kos.
                      // push (bukan go) agar tombol back detail berfungsi.
                      onTap: () => context.push(KosDetailPage.routeName),
                    ),
                ],
                const SizedBox(height: AppSpacing.lg),
                const SectionHeader(
                  title: 'Rekomendasi Terdekat',
                  trailing: 'Dekat MRT & KRL',
                ),
                const SizedBox(height: AppSpacing.sm),
                if (nearby.isEmpty && featured.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: Center(
                      child: Text('Tidak ada kos yang cocok.'),
                    ),
                  ),
                for (var i = 0; i < nearby.length; i++) ...[
                  KosCard(
                    listing: nearby[i],
                    isFavorite: favIds.contains(nearby[i].id),
                    onFavoriteToggle: () =>
                        toggleFavoriteFromListing(nearby[i]),
                    onTap: () => context.push(KosDetailPage.routeName),
                  ),
                  if (i < nearby.length - 1)
                    const SizedBox(height: AppSpacing.md),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
