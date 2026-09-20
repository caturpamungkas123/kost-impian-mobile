import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Item hasil pencarian geocoding.
class _SearchResult {
  const _SearchResult({
    required this.displayName,
    required this.point,
  });

  final String displayName;
  final LatLng point;
}

/// Hasil konfirmasi peta: koordinat + alamat lengkap (hasil reverse geocoding).
class PetaLokasiHasil {
  const PetaLokasiHasil({required this.point, required this.address});

  final LatLng point;
  final String address;
}

/// Peta pilih titik lokasi kos (prd.md §3.6).
/// Dibuka dari modal Tambah Listing lalu mengembalikan [PetaLokasiHasil]
/// (koordinat + alamat lengkap) via `Navigator.pop`.
///
/// - Tile satelit (Esri World Imagery) + overlay nama tempat.
/// - Pin merah SELALU di tengah layar.
/// - Search bar di atas sejajar tombol back + autocomplete dropdown (1-5 hasil).
/// - Button bawah: "Konfirmasi lokasi peta" (lat/lng tersembunyi dari UI).
class PetaPilihLokasiPage extends StatefulWidget {
  const PetaPilihLokasiPage({super.key, this.initial});

  final LatLng? initial;

  static const defaultCenter = LatLng(-6.2615, 106.8106);

  @override
  State<PetaPilihLokasiPage> createState() => _PetaPilihLokasiPageState();
}

class _PetaPilihLokasiPageState extends State<PetaPilihLokasiPage> {
  final _mapController = MapController();
  final _searchCtrl = TextEditingController();
  final _dio = Dio();

  late LatLng _selected;
  Timer? _debounce;
  bool _searching = false;
  bool _confirming = false;
  List<_SearchResult> _suggestions = [];

  @override
  void initState() {
    super.initState();
    _selected = widget.initial ?? PetaPilihLokasiPage.defaultCenter;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchCtrl.dispose();
    _dio.close();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    if (query.trim().isEmpty) {
      setState(() {
        _suggestions = [];
        _searching = false;
      });
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 400), () {
      _fetchSuggestions(query.trim());
    });
  }

  /// Geocoding auto-suggest via Nominatim (limit 5).
  Future<void> _fetchSuggestions(String query) async {
    setState(() => _searching = true);
    try {
      final res = await _dio.get<List<dynamic>>(
        'https://nominatim.openstreetmap.org/search',
        queryParameters: {
          'q': query,
          'format': 'json',
          'limit': 5,
        },
        options: Options(
          headers: {'User-Agent': 'KosanKu-App/1.0'},
        ),
      );
      final data = res.data ?? [];
      final list = <_SearchResult>[];
      for (final item in data) {
        final m = item as Map<String, dynamic>;
        final lat = double.tryParse(m['lat'] as String? ?? '');
        final lon = double.tryParse(m['lon'] as String? ?? '');
        final name = m['display_name'] as String? ?? '';
        if (lat != null && lon != null && name.isNotEmpty) {
          list.add(_SearchResult(displayName: name, point: LatLng(lat, lon)));
        }
      }
      if (!mounted) return;
      setState(() => _suggestions = list);
    } catch (_) {
      if (!mounted) return;
      setState(() => _suggestions = []);
    } finally {
      if (mounted) setState(() => _searching = false);
    }
  }

  void _selectSuggestion(_SearchResult result) {
    FocusScope.of(context).unfocus();
    _searchCtrl.text = result.displayName.split(',').first;
    setState(() => _suggestions = []);
    _mapController.move(result.point, 16);
    setState(() => _selected = result.point);
  }

  /// Reverse geocoding titik terpilih → alamat lengkap, lalu pop hasilnya.
  Future<void> _confirm() async {
    if (_confirming) return;
    FocusScope.of(context).unfocus();
    setState(() => _confirming = true);
    var address = '';
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        'https://nominatim.openstreetmap.org/reverse',
        queryParameters: {
          'lat': _selected.latitude,
          'lon': _selected.longitude,
          'format': 'json',
        },
        options: Options(
          headers: {'User-Agent': 'KosanKu-App/1.0'},
        ),
      );
      address = res.data?['display_name'] as String? ?? '';
    } catch (_) {
      address = '';
    } finally {
      if (mounted) setState(() => _confirming = false);
    }
    if (!mounted) return;
    Navigator.of(context).pop(
      PetaLokasiHasil(point: _selected, address: address),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isLight = Theme.of(context).brightness == Brightness.light;
    final bg = isLight ? AppColors.background : AppColors.darkBackground;
    final surface = isLight ? AppColors.surface : AppColors.darkSurface;
    final textPrimary =
        isLight ? AppColors.textPrimary : AppColors.darkTextPrimary;
    final textSecondary =
        isLight ? AppColors.textSecondary : AppColors.darkTextSecondary;
    final border = isLight ? AppColors.border : AppColors.darkBorder;

    return Scaffold(
      backgroundColor: bg,
      body: Stack(
        children: [
          // 1. Peta Satelit + Labels.
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _selected,
              initialZoom: 15,
              onPositionChanged: (camera, hasGesture) {
                if (hasGesture) {
                  setState(() => _selected = camera.center);
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://server.arcgisonline.com/ArcGIS/rest/services/'
                    'World_Imagery/MapServer/tile/{z}/{y}/{x}',
                userAgentPackageName: 'com.kosanku.app',
                maxNativeZoom: 18,
                maxZoom: 19,
              ),
              TileLayer(
                urlTemplate:
                    'https://server.arcgisonline.com/ArcGIS/rest/services/'
                    'Reference/World_Boundaries_and_Places/MapServer/tile/'
                    '{z}/{y}/{x}',
                userAgentPackageName: 'com.kosanku.app',
                maxNativeZoom: 18,
                maxZoom: 19,
              ),
              RichAttributionWidget(
                alignment: AttributionAlignment.bottomLeft,
                attributions: [
                  TextSourceAttribution('Esri, Maxar, Earthstar Geographics'),
                ],
              ),
            ],
          ),

          // 2. Pin di Tengah Layar.
          const Positioned.fill(
            child: IgnorePointer(
              child: Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 40),
                  child: _CenterPin(),
                ),
              ),
            ),
          ),

          // 3. Header Top Bar: Back Button + Search Bar (Sejajar).
          SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: surface.withValues(alpha: 0.96),
                            border: Border.all(color: border),
                          ),
                          child: Icon(
                            Icons.arrow_back_rounded,
                            size: 18,
                            color: textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: _buildSearchBar(
                          surface: surface,
                          border: border,
                          textPrimary: textPrimary,
                          textSecondary: textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                // List Auto-Suggest (1-5 Hasil) di Bawah Search Bar.
                if (_suggestions.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                    ),
                    child: Container(
                      constraints: const BoxConstraints(maxHeight: 240),
                      decoration: BoxDecoration(
                        color: surface.withValues(alpha: 0.98),
                        borderRadius: AppRadius.radiusLg,
                        border: Border.all(color: border),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: AppRadius.radiusLg,
                        child: ListView.separated(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemCount: _suggestions.length,
                          separatorBuilder: (context, index) => Divider(
                            height: 1,
                            color: border.withValues(alpha: 0.5),
                          ),
                          itemBuilder: (context, i) {
                            final item = _suggestions[i];
                            return ListTile(
                              dense: true,
                              horizontalTitleGap: 8,
                              leading: FaIcon(
                                FontAwesomeIcons.locationDot,
                                size: 13,
                                color: scheme.primary,
                              ),
                              title: Text(
                                item.displayName,
                                style: AppTypography.labelSm.copyWith(
                                  color: textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              onTap: () => _selectSuggestion(item),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // 4. Bottom Bar: Tombol Konfirmasi Lokasi Peta (Lat/Lng Tersembunyi).
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.lg,
                AppSpacing.lg,
              ),
              decoration: BoxDecoration(
                color: surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppRadius.xl),
                ),
                border: Border(
                  top: BorderSide(color: border.withValues(alpha: 0.6)),
                ),
              ),
              child: SafeArea(
                top: false,
                child: GestureDetector(
                  onTap: _confirm,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.md,
                    ),
                    decoration: BoxDecoration(
                      color: scheme.primary,
                      borderRadius: AppRadius.radiusFull,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_confirming)
                          SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: scheme.onPrimary,
                            ),
                          )
                        else
                          FaIcon(
                            FontAwesomeIcons.check,
                            size: 13,
                            color: scheme.onPrimary,
                          ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          _confirming
                              ? 'Mengambil alamat...'
                              : 'Konfirmasi lokasi peta',
                          style: AppTypography.labelMd.copyWith(
                            color: scheme.onPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar({
    required Color surface,
    required Color border,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        color: surface.withValues(alpha: 0.96),
        borderRadius: AppRadius.radiusFull,
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          FaIcon(
            FontAwesomeIcons.magnifyingGlass,
            size: 14,
            color: textSecondary,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: TextField(
              controller: _searchCtrl,
              onChanged: _onSearchChanged,
              style: AppTypography.labelSm.copyWith(
                color: textPrimary,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                hintText: 'Cari nama daerah...',
                hintStyle: AppTypography.labelSm.copyWith(
                  color: textSecondary,
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 11,
                ),
              ),
            ),
          ),
          if (_searching)
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else if (_searchCtrl.text.isNotEmpty)
            GestureDetector(
              onTap: () {
                _searchCtrl.clear();
                setState(() => _suggestions = []);
              },
              child: Icon(
                Icons.close_rounded,
                size: 16,
                color: textSecondary,
              ),
            ),
        ],
      ),
    );
  }
}

/// Pin tengah layar — merah, ujung lancip menunjuk koordinat.
class _CenterPin extends StatelessWidget {
  const _CenterPin();

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final pinColor = isLight ? AppColors.error : AppColors.darkError;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: 2,
          ),
          decoration: BoxDecoration(
            color: pinColor,
            borderRadius: AppRadius.radiusFull,
          ),
          child: Text(
            'Kos di sini',
            style: AppTypography.labelXs.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 10,
            ),
          ),
        ),
        const SizedBox(height: 2),
        Icon(
          Icons.location_pin,
          size: 42,
          color: pinColor,
          shadows: const [
            Shadow(color: Colors.black38, blurRadius: 6),
          ],
        ),
      ],
    );
  }
}
