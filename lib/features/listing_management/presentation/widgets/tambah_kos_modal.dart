import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_toast.dart';
import '../pages/peta_pilih_lokasi_page.dart';

/// Bottom sheet "Tambah Listing Kos Baru" — prd.md §3.6 / §4 langkah 5.
/// Referensi: Stitch `Kelola Listing Kos (Mobile CRUD)` → MODAL 1
/// (openAddKosModal/submitAddKos): cek kuota di page, validasi
/// nama + harga + alamat, GPS pin, foto min. 1 (maks. 5),
/// fasilitas checklist, tipe kamar pertama, lalu simpan & terbitkan.
///
/// UI-first: [onSave] meneruskan Map data kos baru ke page
/// (page yang insert ke list + tampilkan toast sukses).
class TambahKosModal extends StatefulWidget {
  const TambahKosModal({super.key, required this.onSave});

  final ValueChanged<Map<String, dynamic>> onSave;

  @override
  State<TambahKosModal> createState() => _TambahKosModalState();
}

class _TambahKosModalState extends State<TambahKosModal> {
  static const _genders = ['Campur', 'Khusus Putra', 'Khusus Putri'];
  static const _maxPhotos = 5;

  late final TextEditingController _nameCtrl;
  late final TextEditingController _priceCtrl;
  late final TextEditingController _addressCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _roomTypeCtrl;
  late final TextEditingController _roomTotalCtrl;

  String _gender = _genders[0];
  LatLng? _location;

  /// Foto properti: file asli dari galeri (JPG/JPEG/PNG, maks. 5).
  /// Entri pertama otomatis jadi sampul utama.
  final List<XFile> _photos = [];
  final ImagePicker _picker = ImagePicker();
  bool _pickingPhoto = false;

  final Map<String, bool> _facilities = {
    'WiFi 100Mbps': true,
    'AC Dingin': true,
    'K. Mandi Dalam': true,
    'Dapur Bersama': true,
    'CCTV 24 Jam': true,
    'Parkir Motor': false,
  };

  @override
  void initState() {
    super.initState();
    // Prefill mengikuti Stitch openAddKosModal().
    _nameCtrl = TextEditingController();
    _priceCtrl = TextEditingController();
    _addressCtrl = TextEditingController();
    _phoneCtrl = TextEditingController(text: '+62 812-9876-5432');
    _roomTypeCtrl = TextEditingController(text: 'Tipe Superior Cozy');
    _roomTotalCtrl = TextEditingController(text: '4');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    _addressCtrl.dispose();
    _phoneCtrl.dispose();
    _roomTypeCtrl.dispose();
    _roomTotalCtrl.dispose();
    super.dispose();
  }

  /// Buka peta satelit untuk menentukan titik kos; hasilnya lat/lng +
  /// alamat lengkap yang langsung mengisi field "Alamat Lengkap".
  /// [rootNavigator: true] agar peta tampil fullscreen di luar bottom nav shell.
  Future<void> _pickGpsLocation() async {
    final result = await Navigator.of(context, rootNavigator: true)
        .push<PetaLokasiHasil>(
      MaterialPageRoute(
        builder: (_) => PetaPilihLokasiPage(initial: _location),
      ),
    );
    if (result == null || !mounted) return;
    setState(() {
      _location = result.point;
      if (result.address.isNotEmpty) {
        _addressCtrl.text = result.address;
      }
    });
  }

  /// Buka galeri dan ambil file gambar (hanya JPG/JPEG/PNG).
  Future<void> _addPhoto() async {
    if (_pickingPhoto) return;
    final remaining = _maxPhotos - _photos.length;
    if (remaining <= 0) {
      AppToast.showWarning(
        context,
        title: 'Maksimal $_maxPhotos foto',
        description: 'Hapus salah satu foto untuk menambah yang baru',
      );
      return;
    }
    setState(() => _pickingPhoto = true);
    try {
      final picked = await _picker.pickMultiImage();
      if (picked.isEmpty) return;
      const allowed = {'jpg', 'jpeg', 'png'};
      final valid = <XFile>[];
      var rejected = 0;
      for (final file in picked) {
        final ext = file.name.split('.').last.toLowerCase();
        if (allowed.contains(ext)) {
          valid.add(file);
        } else {
          rejected++;
        }
      }
      if (rejected > 0 && mounted) {
        AppToast.showWarning(
          context,
          title: '$rejected file ditolak',
          description: 'Hanya format JPG, JPEG, dan PNG yang diterima',
        );
      }
      final accepted = valid.take(remaining).toList();
      if (accepted.isEmpty) return;
      setState(() => _photos.addAll(accepted));
    } finally {
      if (mounted) setState(() => _pickingPhoto = false);
    }
  }

  void _removePhoto(XFile file) {
    setState(() => _photos.remove(file));
  }

  void _submit() {
    final name = _nameCtrl.text.trim();
    final price = int.tryParse(_priceCtrl.text.trim()) ?? 0;
    final address = _addressCtrl.text.trim();
    final phone = _phoneCtrl.text.trim();
    final roomType = _roomTypeCtrl.text.trim().isEmpty
        ? 'Tipe Standar'
        : _roomTypeCtrl.text.trim();
    final roomTotal = int.tryParse(_roomTotalCtrl.text.trim()) ?? 4;

    // Validasi mengikuti Stitch submitAddKos().
    if (name.isEmpty) {
      AppToast.showError(
        context,
        title: 'Nama kos wajib diisi',
        description: 'Harap isi Nama Properti Kos!',
      );
      return;
    }
    if (price <= 0) {
      AppToast.showError(
        context,
        title: 'Harga tidak valid',
        description: 'Harap masukkan harga sewa bulanan yang valid!',
      );
      return;
    }
    if (address.isEmpty) {
      AppToast.showError(
        context,
        title: 'Alamat wajib diisi',
        description: 'Harap masukkan alamat lengkap kos!',
      );
      return;
    }
    if (_location == null) {
      AppToast.showError(
        context,
        title: 'Titik lokasi wajib ditentukan',
        description: 'Buka peta dan tentukan pin lokasi kos terlebih dahulu',
      );
      return;
    }
    if (_photos.isEmpty) {
      AppToast.showError(
        context,
        title: 'Foto properti wajib',
        description: 'Unggah minimal 1 foto kos (maks. 5)',
      );
      return;
    }

    final selectedFacilities = _facilities.entries
        .where((e) => e.value)
        .map((e) => e.key)
        .toList();

    widget.onSave({
      'id': DateTime.now().millisecondsSinceEpoch,
      'name': name,
      'price': price,
      'address': address,
      'phone': phone.isEmpty ? '+62 812-3344-5566' : phone,
      'type': _gender,
      'rating': 5.0,
      'reviews': 0,
      'rooms': roomTotal,
      'available': roomTotal,
      'roomType': roomType,
      'latitude': _location!.latitude,
      'longitude': _location!.longitude,
      'facilities': selectedFacilities,
      'image': 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=800',
      'active': true,
      'featured': false,
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isLight = Theme.of(context).brightness == Brightness.light;
    final bg = isLight ? AppColors.background : AppColors.darkBackground;
    final surface = isLight ? AppColors.surface : AppColors.darkSurface;
    final fill = isLight ? AppColors.tertiary : AppColors.darkTertiary;
    final textPrimary =
        isLight ? AppColors.textPrimary : AppColors.darkTextPrimary;
    final textSecondary =
        isLight ? AppColors.textSecondary : AppColors.darkTextSecondary;
    final border = isLight ? AppColors.border : AppColors.darkBorder;
    final success = isLight ? AppColors.success : AppColors.darkSuccess;
    final warning = isLight ? AppColors.warning : AppColors.darkWarning;
    final error = isLight ? AppColors.error : AppColors.darkError;

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.7,
      maxChildSize: 1.0,
      expand: false,
      builder: (context, scrollController) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppRadius.xl),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: bg,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header (includes top handle).
                Container(
                  color: surface,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: AppSpacing.sm,
                          bottom: AppSpacing.xs,
                        ),
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: border,
                            borderRadius: AppRadius.radiusFull,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.lg,
                          AppSpacing.xs,
                          AppSpacing.lg,
                          AppSpacing.sm,
                        ),
                        decoration: BoxDecoration(
                          color: surface,
                          border: Border(
                            bottom: BorderSide(
                              color: border.withValues(alpha: 0.6),
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: fill,
                                ),
                                child: Icon(
                                  Icons.close_rounded,
                                  size: 16,
                                  color: textPrimary,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Tambah Listing Kos Baru',
                                    style: AppTypography.labelMd.copyWith(
                                      color: textPrimary,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  Text(
                                    'Lengkapi data kos untuk diterbitkan',
                                    style: AppTypography.labelXs.copyWith(
                                      color: textSecondary,
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
                // Form body.
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.md,
                      AppSpacing.lg,
                      AppSpacing.md,
                    ),
                    children: [
                      _buildInfoCard(
                        scheme: scheme,
                        isLight: isLight,
                        surface: surface,
                        fill: fill,
                        border: border,
                        textPrimary: textPrimary,
                        textSecondary: textSecondary,
                        success: success,
                        warning: warning,
                        error: error,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _buildPhotoCard(
                        scheme: scheme,
                        surface: surface,
                        fill: fill,
                        border: border,
                        textPrimary: textPrimary,
                        textSecondary: textSecondary,
                        warning: warning,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _buildRoomCard(
                        surface: surface,
                        fill: fill,
                        border: border,
                        textPrimary: textPrimary,
                        textSecondary: textSecondary,
                      ),
                    ],
                  ),
                ),
                // Bottom actions.
                Container(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.sm,
                    AppSpacing.lg,
                    AppSpacing.lg,
                  ),
                  decoration: BoxDecoration(
                    color: surface,
                    border: Border(
                      top: BorderSide(color: border.withValues(alpha: 0.6)),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: AppSpacing.md,
                            ),
                            decoration: BoxDecoration(
                              color: fill,
                              borderRadius: AppRadius.radiusFull,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Batal',
                              style: AppTypography.labelMd.copyWith(
                                color: textPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: _submit,
                          child: Container(
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
                                FaIcon(
                                  FontAwesomeIcons.check,
                                  size: 13,
                                  color: scheme.onPrimary,
                                ),
                                const SizedBox(width: AppSpacing.xs),
                                Text(
                                  'Simpan & Terbitkan Kos',
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ---------- section: informasi dasar ----------

  Widget _buildInfoCard({
    required ColorScheme scheme,
    required bool isLight,
    required Color surface,
    required Color fill,
    required Color border,
    required Color textPrimary,
    required Color textSecondary,
    required Color success,
    required Color warning,
    required Color error,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: AppRadius.radius3xl,
        border: Border.all(color: border.withValues(alpha: 0.7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'INFORMASI DASAR KOS',
            style: AppTypography.labelXs.copyWith(
              color: textPrimary,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _fieldLabel('Nama Kos', required: true, color: textSecondary),
          const SizedBox(height: AppSpacing.xs),
          _textInput(
            controller: _nameCtrl,
            hint: 'Contoh: KosanKu Kebayoran Baru',
            fill: fill,
            border: border,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _fieldLabel('Tipe Penghuni', color: textSecondary),
                    const SizedBox(height: AppSpacing.xs),
                    DropdownButtonFormField<String>(
                      initialValue: _gender,
                      items: _genders
                          .map(
                            (g) => DropdownMenuItem(
                              value: g,
                              child: Text(
                                g,
                                style: AppTypography.labelSm.copyWith(
                                  color: textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (v) {
                        if (v != null) setState(() => _gender = v);
                      },
                      decoration: _inputDecoration(
                        fill: fill,
                        border: border,
                        textSecondary: textSecondary,
                      ),
                      dropdownColor: surface,
                      icon: FaIcon(
                        FontAwesomeIcons.chevronDown,
                        size: 12,
                        color: textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _fieldLabel('Harga Mulai (Rp)', color: textSecondary),
                    const SizedBox(height: AppSpacing.xs),
                    _textInput(
                      controller: _priceCtrl,
                      hint: '2000000',
                      fill: fill,
                      border: border,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          _fieldLabel('Alamat Lengkap', required: true, color: textSecondary),
          const SizedBox(height: AppSpacing.xs),
          _textInput(
            controller: _addressCtrl,
            hint: 'Jl. Gandaria No. 10, Jakarta Selatan',
            fill: fill,
            border: border,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
            maxLines: 2,
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildGpsSection(
            scheme: scheme,
            fill: fill,
            border: border,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
            success: success,
            warning: warning,
          ),
          const SizedBox(height: AppSpacing.sm),
          _fieldLabel('Nomor WhatsApp Pengelola',
              required: true, color: textSecondary),
          const SizedBox(height: AppSpacing.xs),
          _textInput(
            controller: _phoneCtrl,
            hint: '081298765432',
            fill: fill,
            border: border,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Tampil otomatis sebagai tombol WA di halaman Detail Kos.',
            style: AppTypography.labelXs.copyWith(
              color: textSecondary,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGpsSection({
    required ColorScheme scheme,
    required Color fill,
    required Color border,
    required Color textPrimary,
    required Color textSecondary,
    required Color success,
    required Color warning,
  }) {
    final pinned = _location != null;
    final coordsText = pinned
        ? '${_location!.latitude.toStringAsFixed(5)}, '
            '${_location!.longitude.toStringAsFixed(5)}'
        : 'Koordinat belum disematkan';

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: fill,
        borderRadius: AppRadius.radiusMd,
        border: Border.all(color: border.withValues(alpha: 0.6)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.locationDot,
                    size: 12,
                    color: textPrimary,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    'Titik Lokasi GPS & Peta *',
                    style: AppTypography.labelSm.copyWith(
                      color: textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xs,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: (pinned ? success : warning).withValues(alpha: 0.15),
                  borderRadius: AppRadius.radiusFull,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: pinned ? success : warning,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      pinned ? 'Pin Terpasang' : 'Belum Ditentukan',
                      style: AppTypography.labelXs.copyWith(
                        color: pinned ? success : warning,
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            height: 112,
            decoration: BoxDecoration(
              color: border.withValues(alpha: 0.25),
              borderRadius: AppRadius.radiusSm,
              border: Border.all(color: border.withValues(alpha: 0.6)),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: pinned ? scheme.primary : fill,
                      border: Border.all(color: border),
                    ),
                    child: Icon(
                      Icons.location_pin,
                      size: 20,
                      color: pinned ? scheme.onPrimary : textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: fill,
                      borderRadius: AppRadius.radiusFull,
                      border:
                          Border.all(color: border.withValues(alpha: 0.6)),
                    ),
                    child: Text(
                      coordsText,
                      style: AppTypography.labelXs.copyWith(
                        color: textSecondary,
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.compass,
                    size: 11,
                    color: textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Akurasi GPS < 5m',
                    style: AppTypography.labelXs.copyWith(
                      color: textSecondary,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: _pickGpsLocation,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: scheme.primary,
                    borderRadius: AppRadius.radiusFull,
                  ),
                  child: Row(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.crosshairs,
                        size: 11,
                        color: scheme.onPrimary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        pinned
                            ? 'Ubah Pin GPS'
                            : 'Buka Peta & Tentukan Pin',
                        style: AppTypography.labelXs.copyWith(
                          color: scheme.onPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------- section: foto & fasilitas ----------

  Widget _buildPhotoCard({
    required ColorScheme scheme,
    required Color surface,
    required Color fill,
    required Color border,
    required Color textPrimary,
    required Color textSecondary,
    required Color warning,
  }) {
    final tiles = <Widget>[
      ..._photos.asMap().entries.map(
            (e) => _photoTile(
              file: e.value,
              label: 'Foto ${e.key + 1}',
              isCover: e.key == 0,
              scheme: scheme,
              fill: fill,
              border: border,
              textPrimary: textPrimary,
              warning: warning,
            ),
          ),
      if (_photos.length < _maxPhotos)
        GestureDetector(
          onTap: _addPhoto,
          child: Container(
            decoration: BoxDecoration(
              color: fill,
              borderRadius: AppRadius.radiusMd,
              border: Border.all(color: border),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: border.withValues(alpha: 0.5),
                  ),
                  child: _pickingPhoto
                      ? Padding(
                          padding: const EdgeInsets.all(8),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: textPrimary,
                          ),
                        )
                      : Icon(
                          Icons.add_rounded,
                          size: 18,
                          color: textPrimary,
                        ),
                ),
                const SizedBox(height: 4),
                Text(
                  _pickingPhoto ? 'Membuka galeri...' : 'Tambah Foto',
                  style: AppTypography.labelXs.copyWith(
                    color: textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                  ),
                ),
                Text(
                  'JPG / JPEG / PNG',
                  style: AppTypography.labelXs.copyWith(
                    color: textSecondary,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
        ),
    ];

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: AppRadius.radius3xl,
        border: Border.all(color: border.withValues(alpha: 0.7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'FOTO PROPERTI',
                style: AppTypography.labelXs.copyWith(
                  color: textPrimary,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xs,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: fill,
                  borderRadius: AppRadius.radiusFull,
                ),
                child: Text(
                  'Wajib Min. 1 Foto (Maks. 5)',
                  style: AppTypography.labelXs.copyWith(
                    color: textSecondary,
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Unggah minimal 1 foto fasad atau area kos (maksimal 5 foto, format JPG/JPEG/PNG maks 2MB per file). Foto pertama otomatis menjadi foto sampul utama.',
            style: AppTypography.labelXs.copyWith(
              color: textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: tiles.length,
            itemBuilder: (context, i) => tiles[i],
          ),
          const SizedBox(height: AppSpacing.xs),
          Center(
            child: Text(
              '${_photos.length}/$_maxPhotos Foto',
              style: AppTypography.labelXs.copyWith(
                color: textSecondary,
                fontWeight: FontWeight.w500,
                fontSize: 10,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.only(top: AppSpacing.sm),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: border.withValues(alpha: 0.4)),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Fasilitas Bersama Kos',
                      style: AppTypography.labelSm.copyWith(
                        color: textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Pilih fasilitas yang tersedia',
                      style: AppTypography.labelXs.copyWith(
                        color: textSecondary,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 6,
                    mainAxisSpacing: 6,
                    mainAxisExtent: 40,
                  ),
                  itemCount: _facilities.length,
                  itemBuilder: (context, i) {
                    final name = _facilities.keys.elementAt(i);
                    final checked = _facilities[name]!;
                    return GestureDetector(
                      onTap: () => setState(
                        () => _facilities[name] = !checked,
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: fill,
                          borderRadius: AppRadius.radiusSm,
                          border: Border.all(
                            color: checked
                                ? textPrimary
                                : border.withValues(alpha: 0.7),
                          ),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: Checkbox(
                                value: checked,
                                onChanged: (v) => setState(
                                  () => _facilities[name] = v ?? false,
                                ),
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              ),
                            ),
                            const SizedBox(width: 4),
                            FaIcon(
                              _facilityIcon(name),
                              size: 12,
                              color: textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                name,
                                style: AppTypography.labelXs.copyWith(
                                  color: textPrimary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  FaIconData _facilityIcon(String name) {
    switch (name) {
      case 'WiFi 100Mbps':
        return FontAwesomeIcons.wifi;
      case 'AC Dingin':
        return FontAwesomeIcons.snowflake;
      case 'K. Mandi Dalam':
        return FontAwesomeIcons.shower;
      case 'Dapur Bersama':
        return FontAwesomeIcons.kitchenSet;
      case 'CCTV 24 Jam':
        return FontAwesomeIcons.shieldHalved;
      case 'Parkir Motor':
        return FontAwesomeIcons.motorcycle;
      default:
        return FontAwesomeIcons.circleCheck;
    }
  }

  Widget _photoTile({
    required XFile file,
    required String label,
    required bool isCover,
    required ColorScheme scheme,
    required Color fill,
    required Color border,
    required Color textPrimary,
    required Color warning,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: AppRadius.radiusMd,
        border: Border.all(
          color: isCover ? textPrimary : border.withValues(alpha: 0.7),
          width: isCover ? 2 : 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: AppRadius.radiusMd,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.file(
              File(file.path),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: fill,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.image,
                        size: 22,
                        color: textPrimary.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        label,
                        style: AppTypography.labelXs.copyWith(
                          color: textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (isCover)
              Positioned(
                bottom: 6,
                left: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xs,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: scheme.primary,
                    borderRadius: AppRadius.radiusFull,
                  ),
                  child: Row(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.solidStar,
                        size: 8,
                        color: warning,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        'SAMPUL',
                        style: AppTypography.labelXs.copyWith(
                          color: scheme.onPrimary,
                          fontWeight: FontWeight.w800,
                          fontSize: 8,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: () => _removePhoto(file),
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: textPrimary.withValues(alpha: 0.7),
                  ),
                  child: Icon(
                    Icons.close_rounded,
                    size: 12,
                    color: fill,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- section: tipe kamar ----------

  Widget _buildRoomCard({
    required Color surface,
    required Color fill,
    required Color border,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: AppRadius.radius3xl,
        border: Border.all(color: border.withValues(alpha: 0.7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'TIPE KAMAR PERTAMA',
                style: AppTypography.labelXs.copyWith(
                  color: textPrimary,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xs,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: fill,
                  borderRadius: AppRadius.radiusFull,
                ),
                child: Text(
                  'Wajib 1 Tipe',
                  style: AppTypography.labelXs.copyWith(
                    color: textSecondary,
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _fieldLabel('Nama Tipe', color: textSecondary),
                    const SizedBox(height: AppSpacing.xs),
                    _textInput(
                      controller: _roomTypeCtrl,
                      hint: 'Deluxe Queen',
                      fill: fill,
                      border: border,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _fieldLabel('Jumlah Kamar', color: textSecondary),
                    const SizedBox(height: AppSpacing.xs),
                    _textInput(
                      controller: _roomTotalCtrl,
                      hint: '5',
                      fill: fill,
                      border: border,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------- small builders ----------

  Widget _fieldLabel(
    String text, {
    bool required = false,
    required Color color,
  }) {
    return RichText(
      text: TextSpan(
        text: text,
        style: AppTypography.labelSm.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
        children: required
            ? const [
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red),
                ),
              ]
            : null,
      ),
    );
  }

  InputDecoration _inputDecoration({
    required Color fill,
    required Color border,
    required Color textSecondary,
    String? hint,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTypography.labelSm.copyWith(color: textSecondary),
      filled: true,
      fillColor: fill,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      border: OutlineInputBorder(
        borderRadius: AppRadius.radiusMd,
        borderSide: BorderSide(color: border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppRadius.radiusMd,
        borderSide: BorderSide(color: border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppRadius.radiusMd,
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    );
  }

  Widget _textInput({
    required TextEditingController controller,
    required String hint,
    required Color fill,
    required Color border,
    required Color textPrimary,
    required Color textSecondary,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: AppTypography.labelSm.copyWith(
        color: textPrimary,
        fontWeight: FontWeight.w500,
      ),
      decoration: _inputDecoration(
        fill: fill,
        border: border,
        textSecondary: textSecondary,
        hint: hint,
      ),
    );
  }
}
