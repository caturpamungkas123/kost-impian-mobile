import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Data favorit — UI-first: dummy di presentation.
/// Nanti diganti entity favorites + BLoC (fase business logic, prd.md §3.4).
class FavoriteKos {
  const FavoriteKos({
    required this.id,
    required this.name,
    required this.location,
    required this.price,
    required this.badge,
    this.urgencyBadge,
    required this.type,
    required this.amenities,
    required this.rating,
    required this.reviewCount,
    required this.imageUrl,
    this.showChatAction = false,
  });

  final String id;
  final String name;
  final String location;
  final String price;
  final String badge;
  final String? urgencyBadge;
  final String type;
  final List<String> amenities;
  final double rating;
  final int reviewCount;
  final String imageUrl;
  final bool showChatAction;
}

const _kemangImg =
    'https://lh3.googleusercontent.com/aida-public/AB6AXuDMspArVcBF3jFEgyfrsAESTilPPMKFI-yGzEkoQ8aSWk_-GucpWNqAxtFPCWHASBiV7rONUxGlsJMljoeoOyYx2_cEmKZQ-p2cgBcyU6_J1ZImfi5ImiiDnDzmg6mil--q8wTwNAxnbF4dU9ZV6E_G-OMBmOfNh2F5JFSUcUNVLTeHlZrThOk4SjkVRy7TYMe-wUhrEwidGQrLXRMkVZIVo9bzFng5JfwO114MgKSI8gW5pQD47bKz';
const _tebetImg =
    'https://lh3.googleusercontent.com/aida-public/AB6AXuClpH02u7_A8SaxhiLjKfndwMHlF_DG-zaTVZV6pZklU1-D22Oen4Iv2UmH5BCcV0pdP3LZuRiu1irfNfDLSc_gQmy-rkt7EgRCdRG7CLrVDzXba647zlqN4GLcUatcLfiJVjOfqaLi2MFq9BHXnrx_39JeoC10JwnpUaLGn8JKP_vINSkktuKPmZ-HMgTpdSjthDn8mtFnGjbu95vV_mf-UsvvPC0gTPinNl-3kCU3kBHaJlAqiTKd';
const _cipeteImg =
    'https://lh3.googleusercontent.com/aida-public/AB6AXuABF9PiiWzZenzk15l3MQ-GZoD0sxd0Gb-iHCHCncO4dl4KJhg4VfOcxRy0aRKOhZ0prDNrw5RGdsLPau6KanZjD3d_df4rgzSXSpqnVGxz94S27Ue1JgQHs8mLx6hnHuwmg_YSpYKO2fH-MhAWDXVd2B8VD49lOl7Zn0bH_MEqmhCJLqK8bKEId3tNXkPkAWkHkPkiHvEba02qj2oXoa04CYFZcndAo0whMG9VAInQ1G--vg-LZaEn';

const dummyFavorites = [
  FavoriteKos(
    id: 'kemang',
    name: 'KosanKu Urban Kemang',
    location: 'Kemang, Jaksel • 500m dr MRT',
    price: 'Rp 2.450.000',
    badge: 'Campur • Eksklusif',
    urgencyBadge: 'Sisa 2 Kamar',
    type: 'Campur',
    amenities: ['K. Mandi Dalam', 'AC Dingin', 'WiFi 50M'],
    rating: 4.9,
    reviewCount: 28,
    imageUrl: _kemangImg,
    showChatAction: true,
  ),
  FavoriteKos(
    id: 'tebet',
    name: 'Pavilion Asri Tebet',
    location: 'Tebet, Jaksel • 500m dr Stasiun Tebet',
    price: 'Rp 1.850.000',
    badge: 'Khusus Putri',
    type: 'Putri',
    amenities: ['Kasur Queen', 'Listrik Termasuk', 'Parkir Motor'],
    rating: 4.8,
    reviewCount: 42,
    imageUrl: _tebetImg,
  ),
  FavoriteKos(
    id: 'cipete',
    name: "D'Coliving Cipete Signature",
    location: 'Cipete, Jaksel • Dekat MRT Cipete Raya',
    price: 'Rp 2.200.000',
    badge: 'Putra • PRO Verified',
    type: 'Putra',
    amenities: ['K. Mandi Dlm', 'Dapur Bersama', 'Water Heater'],
    rating: 4.7,
    reviewCount: 19,
    imageUrl: _cipeteImg,
  ),
];

/// Ikon aksi header favorit.
abstract final class FavoriteHeaderIcons {
  static const search = FontAwesomeIcons.magnifyingGlass;
  static const more = FontAwesomeIcons.ellipsis;
}
