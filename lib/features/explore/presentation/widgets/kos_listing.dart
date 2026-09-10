import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Data listing kos — UI-first: dummy di presentation.
/// Nanti diganti entity dari domain/ + BLoC (fase business logic).
class KosListing {
  const KosListing({
    required this.id,
    required this.name,
    required this.location,
    required this.price,
    required this.priceSuffix,
    required this.badge,
    required this.type,
    required this.specs,
    required this.imageUrl,
    this.isFeatured = false,
  });

  final String id;
  final String name;
  final String location;
  final String price;
  final String priceSuffix;
  final String badge;
  final String type;
  final List<(FaIconData, String)> specs;
  final String imageUrl;
  final bool isFeatured;
}

const kosImageKemang =
    'https://lh3.googleusercontent.com/aida-public/AB6AXuD_vgR41xf_NBtKPzbLO7c8yNSIiYTKLwaTIYkjDIlbQcksAR7y2mlQJQq7QM6-5klxiCLY15jDuzWMs0O6QVw06iuiBTLTui9C_Oni0BcwjS4mP6qFIbg2wEvYW1t4KeGHl24Jgnhe-Z4EoyQtLzDcuDR6fgNdks4Z-PO0r2yx89mMDoxUwZut3ivXhQnqljwFm4aegM00bDG_oiXBvKoXGjirphD3f0ioUc2j8JBY0NhnThopzf-6';
const kosImageTebet =
    'https://lh3.googleusercontent.com/aida-public/AB6AXuCn19hb2mNzPDAWnMDitYHvDdMh60CHXUWtmG2wvz9r7o3PFYWGJaV4E1FpxYb8LaegAiXKEPao2xe_lRE00fFoRv1EHR2q1mRN2hbVFLaUSEAK0LMVYsyB_MF378UMt6OnID_Tto5DASbXK-O-1znEjaZIJ1qi_7eMCEQr0RFaCxt1yXUxGffvyviL1EGcoO_rAC-DM7fpUFJkBY1eYcixOAfsRusqwwA9wKmbaFa3PuJmDCJpWwl5';

/// Dummy sesuai Stitch — featured selalu paling atas (prd.md §3.2/§4.4).
const dummyKosList = [
  KosListing(
    id: 'kemang',
    name: 'KosanKu Urban Kemang',
    location: 'Kemang, Jakarta Selatan',
    price: 'Rp 2,45 Jt',
    priceSuffix: '/ bulan',
    badge: 'Campur • Eksklusif',
    type: 'Campur',
    specs: [
      (FontAwesomeIcons.bath, 'K. Mandi Dlm'),
      (FontAwesomeIcons.wifi, 'WiFi 50M'),
      (FontAwesomeIcons.snowflake, 'AC Dingin'),
    ],
    imageUrl: kosImageKemang,
    isFeatured: true,
  ),
  KosListing(
    id: 'tebet',
    name: 'Pavilion Asri Tebet',
    location: 'Tebet • 500m dr Stasiun Tebet',
    price: 'Rp 1,85 Jt',
    priceSuffix: '/ bln',
    badge: 'Khusus Putri',
    type: 'Putri',
    specs: [
      (FontAwesomeIcons.bed, 'Kasur Queen'),
      (FontAwesomeIcons.bolt, 'Termasuk Listrik'),
      (FontAwesomeIcons.motorcycle, 'Parkir Motor'),
    ],
    imageUrl: kosImageTebet,
  ),
  KosListing(
    id: 'melati',
    name: 'Kost Griya Melati',
    location: 'Mampang, Jakarta Selatan',
    price: 'Rp 1,20 Jt',
    priceSuffix: '/ bln',
    badge: 'Khusus Putra',
    type: 'Putra',
    specs: [
      (FontAwesomeIcons.bed, 'Kasur Single'),
      (FontAwesomeIcons.wifi, 'WiFi 20M'),
      (FontAwesomeIcons.squareParking, 'Parkir Luas'),
    ],
    imageUrl: kosImageKemang,
  ),
];
