import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../explore/presentation/widgets/kos_listing.dart';

/// Dummy Detail Kos — UI-first, mock langsung di presentation.
/// Nanti diganti entity domain/ + BLoC (fase business logic).
/// Mengacu prd.md §3.3 (galeri, harga, alamat, spesifikasi, fasilitas,
/// pemilik + Chat/WA, peta) & Stitch `Detail KosanKu Urban Kemang`.
class KosDetailData {
  const KosDetailData({
    required this.id,
    required this.name,
    required this.address,
    required this.area,
    required this.price,
    required this.priceSuffix,
    required this.rating,
    required this.reviewCount,
    required this.badge,
    required this.remainingLabel,
    required this.gallery,
    required this.ownerPhone,
  });

  final String id;
  final String name;
  final String address;
  final String area;
  final String price;
  final String priceSuffix;
  final double rating;
  final int reviewCount;
  final String badge;
  final String remainingLabel;
  final List<String> gallery;

  /// Nomor WA pemilik — tombol WA hanya aktif bila valid (prd.md §7.4),
  /// deep link `wa.me/<nomor>` murni client-side.
  final String ownerPhone;
}

const dummyKosDetail = KosDetailData(
  id: 'kemang',
  name: 'KosanKu Urban Kemang',
  address: 'Jl. Kemang Raya No. 12, Bangka',
  area: 'Kemang, Jakarta Selatan',
  price: 'Rp 2,45 Jt',
  priceSuffix: '/ bulan',
  rating: 4.9,
  reviewCount: 128,
  badge: 'Campur • Eksklusif',
  remainingLabel: 'Sisa 2 Kamar',
  gallery: [kosImageKemang, kosImageTebet, kosImageKemang],
  ownerPhone: '6281234567890',
);

class KosSpec {
  const KosSpec(this.icon, this.value, this.label);

  final FaIconData icon;
  final String value;
  final String label;
}

const dummySpecs = [
  KosSpec(FontAwesomeIcons.peopleRoof, 'Campur', 'Tipe Kos'),
  KosSpec(FontAwesomeIcons.bath, 'Dalam', 'K. Mandi'),
  KosSpec(FontAwesomeIcons.rulerCombined, '3 x 4 m', 'Ukuran'),
  KosSpec(FontAwesomeIcons.bed, '2 Unit', 'Sisa Kamar'),
];

class KosFacility {
  const KosFacility(this.icon, this.label);

  final FaIconData icon;
  final String label;
}

const dummyFacilities = [
  KosFacility(FontAwesomeIcons.wifi, 'WiFi 50 Mbps'),
  KosFacility(FontAwesomeIcons.snowflake, 'AC Dingin'),
  KosFacility(FontAwesomeIcons.bed, 'Kasur Queen'),
  KosFacility(FontAwesomeIcons.doorClosed, 'Lemari Pakaian'),
  KosFacility(FontAwesomeIcons.utensils, 'Dapur Bersama'),
  KosFacility(FontAwesomeIcons.squareParking, 'Parkir Motor'),
  KosFacility(FontAwesomeIcons.shower, 'KM Dalam'),
  KosFacility(FontAwesomeIcons.shieldHalved, 'CCTV 24 Jam'),
];

class KosRoomType {
  const KosRoomType({
    required this.name,
    required this.size,
    required this.price,
    required this.status,
    required this.available,
  });

  final String name;
  final String size;
  final String price;
  final String status;
  final bool available;
}

const dummyRoomTypes = [
  KosRoomType(
    name: 'Tipe A — Deluxe',
    size: '3 x 4 m • KM Dalam',
    price: 'Rp 2,45 Jt/bln',
    status: 'Sisa 1',
    available: true,
  ),
  KosRoomType(
    name: 'Tipe B — Reguler',
    size: '3 x 3 m • KM Luar',
    price: 'Rp 1,95 Jt/bln',
    status: 'Sisa 1',
    available: true,
  ),
];

const kosDescription =
    'Hunian modern di jantung Kemang dengan desain hangat dan pencahayaan '
    'alami. 5 menit ke Kemang Village, dekat MRT Cipete & halte TransJakarta. '
    'Lingkungan tenang, keamanan 24 jam, cleaning service mingguan, dan dapur '
    'bersama yang bersih. Cocok untuk pekerja & mahasiswa.';
