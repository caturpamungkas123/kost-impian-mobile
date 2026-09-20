import 'package:flutter/foundation.dart';

import '../../../explore/presentation/widgets/kos_listing.dart';
import 'favorite_data.dart';

/// Store favorit sementara khusus fase UI-first (presentation-layer).
///
/// Explore & Favorit membaca/menulis ke [favoritesStore] yang sama supaya
/// toggle love di Explore langsung muncul di list Favorit, dan hapus di
/// Favorit langsung memadamkan hati di Explore.
///
/// Nanti diganti BLoC + domain/data (tabel `favorites`, prd.md §3.4/§6)
/// saat fase business logic dimulai — lalu file ini dihapus.
final favoritesStore =
    ValueNotifier<List<FavoriteKos>>(List.of(dummyFavorites));

bool isFavorite(String id) =>
    favoritesStore.value.any((element) => element.id == id);

/// Ubah [KosListing] Explore menjadi [FavoriteKos].
/// Kalau id-nya sudah ada di master dummy, pakai data kaya-nya
/// (rating, urgency badge, dsb); kalau belum, bangun dari data listing.
FavoriteKos favoriteFromListing(KosListing listing) {
  for (final fav in dummyFavorites) {
    if (fav.id == listing.id) return fav;
  }
  return FavoriteKos(
    id: listing.id,
    name: listing.name,
    location: listing.location,
    price: listing.price,
    badge: listing.badge,
    type: listing.type,
    amenities: [for (final spec in listing.specs) spec.$2],
    rating: 4.8,
    reviewCount: 12,
    imageUrl: listing.imageUrl,
  );
}

/// Tambah ke favorit bila belum ada, hapus bila sudah ada.
void toggleFavoriteFromListing(KosListing listing) {
  final current = List.of(favoritesStore.value);
  final index = current.indexWhere((element) => element.id == listing.id);
  if (index >= 0) {
    current.removeAt(index);
  } else {
    current.insert(0, favoriteFromListing(listing));
  }
  favoritesStore.value = current;
}

/// Hapus favorit by id (dipakai halaman Favorit).
void removeFavorite(String id) {
  favoritesStore.value = [
    for (final element in favoritesStore.value)
      if (element.id != id) element,
  ];
}

/// Kembalikan ke isi dummy awal — HANYA untuk isolasi antar widget test.
@visibleForTesting
void resetFavorites() {
  favoritesStore.value = List.of(dummyFavorites);
}
