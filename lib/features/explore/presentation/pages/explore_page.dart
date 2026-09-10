import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/bottom_nav.dart';
import '../../../favorites/presentation/pages/favorites_page.dart';
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
  final Set<String> _favorites = {};

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
    final results = _filtered;
    final featured = results.where((k) => k.isFeatured).toList();
    final nearby = results.where((k) => !k.isFeatured).toList();

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.gutter,
                AppSpacing.sm,
                AppSpacing.gutter,
                120, // inset bawah anti-tertutup bottom nav (DESIGN.md)
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
                        isFavorite: _favorites.contains(kos.id),
                        onFavoriteToggle: () => setState(() {
                          _favorites.contains(kos.id)
                              ? _favorites.remove(kos.id)
                              : _favorites.add(kos.id);
                        }),
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
                      isFavorite: _favorites.contains(nearby[i].id),
                      onFavoriteToggle: () => setState(() {
                        _favorites.contains(nearby[i].id)
                            ? _favorites.remove(nearby[i].id)
                            : _favorites.add(nearby[i].id);
                      }),
                    ),
                    if (i < nearby.length - 1)
                      const SizedBox(height: AppSpacing.md),
                  ],
                ],
              ),
            ),
            Positioned(
              left: AppSpacing.gutter,
              right: AppSpacing.gutter,
              bottom: 20,
              child: KosankuBottomNav(
                currentIndex: 0,
                unreadChatCount: 2,
                onTap: (i) {
                  if (i == 2) context.go(FavoritesPage.routeName);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
