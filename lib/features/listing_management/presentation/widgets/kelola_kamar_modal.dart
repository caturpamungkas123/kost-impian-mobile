import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_toast.dart';

/// Bottom sheet "Kelola Kamar & Ketersediaan" — prd.md §3.6/§3.7.
/// Referensi: Stitch `Kelola Listing Kos (Mobile CRUD)` → MODAL 3
/// (openRoomModal/toggleRoomAvailable/updateRoomPrice/updateRoomEmpty/
/// validateAndAddNewRoom/saveRoomChanges).
///
/// Atur ketersediaan kamar kosong per tipe + tambah tipe kamar baru
/// (dengan foto wajib min. 1, maks. 3). UI-first: daftar tipe kamar dummy,
/// [onSave] mengembalikan daftar tipe kamar + total kamar kosong.
class KelolaKamarModal extends StatefulWidget {
  const KelolaKamarModal({
    super.key,
    required this.kos,
    required this.onSave,
  });

  final Map<String, dynamic> kos;
  final ValueChanged<Map<String, dynamic>> onSave;

  @override
  State<KelolaKamarModal> createState() => _KelolaKamarModalState();
}

class _KelolaKamarModalState extends State<KelolaKamarModal> {
  static const _maxPhotos = 3;

  late List<Map<String, dynamic>> _roomTypes;

  // Form tipe kamar baru.
  final _nameCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _sizeCtrl = TextEditingController(text: '3.5 x 4 m');
  final _emptyCtrl = TextEditingController(text: '1');
  final List<XFile> _newRoomPhotos = [];
  final ImagePicker _picker = ImagePicker();
  bool _pickingPhoto = false;
  bool _photoError = false;

  @override
  void initState() {
    super.initState();
    final existing = widget.kos['roomTypes'] as List?;
    if (existing != null && existing.isNotEmpty) {
      _roomTypes = existing
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
    } else {
      // Data dummy mengikuti Stitch MODAL 3.
      _roomTypes = [
        {
          'id': 101,
          'name': 'Tipe Deluxe Queen',
          'size': '3.5 x 4 m',
          'price': 2450000,
          'empty': 2,
          'isAvailable': true,
        },
        {
          'id': 102,
          'name': 'Tipe Superior Single',
          'size': '3 x 3 m',
          'price': 1850000,
          'empty': 0,
          'isAvailable': false,
        },
      ];
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    _sizeCtrl.dispose();
    _emptyCtrl.dispose();
    super.dispose();
  }

  /// Toggle ketersediaan — nonaktif memaksa kosong 0, aktif kembali ke 1
  /// bila sebelumnya 0 (mengikuti toggleRoomAvailable di Stitch).
  void _toggleRoom(int index, bool value) {
    setState(() {
      final room = _roomTypes[index];
      room['isAvailable'] = value;
      if (!value) {
        room['empty'] = 0;
      } else if ((room['empty'] as int? ?? 0) == 0) {
        room['empty'] = 1;
      }
    });
  }

  void _updateEmpty(int index, String value) {
    final parsed = int.tryParse(value.trim()) ?? 0;
    setState(() {
      final room = _roomTypes[index];
      room['empty'] = parsed < 0 ? 0 : parsed;
      // Kosong 0 → tipe dianggap penuh (updateRoomEmpty di Stitch).
      room['isAvailable'] = (room['empty'] as int) > 0;
    });
  }

  void _updatePrice(int index, String value) {
    final parsed = int.tryParse(value.trim()) ?? 0;
    setState(() => _roomTypes[index]['price'] = parsed);
  }

  Future<void> _addRoomPhoto() async {
    if (_pickingPhoto) return;
    if (_newRoomPhotos.length >= _maxPhotos) {
      AppToast.showWarning(
        context,
        title: 'Maksimal $_maxPhotos foto kamar',
        description: 'Hapus salah satu foto untuk menambah yang baru',
      );      return;
    }
    setState(() => _pickingPhoto = true);
    try {
      final picked = await _picker.pickMultiImage();
      if (picked.isEmpty) return;
      const allowed = {'jpg', 'jpeg', 'png'};
      final valid = picked
          .where((f) => allowed.contains(f.name.split('.').last.toLowerCase()))
          .toList();
      if (valid.isEmpty) {
        if (mounted) {
          AppToast.showWarning(
            context,
            title: 'Format tidak didukung',
            description: 'Hanya JPG, JPEG, dan PNG yang diterima',
          );
        }
        return;
      }
      final remaining = _maxPhotos - _newRoomPhotos.length;
      setState(() {
        _newRoomPhotos.addAll(valid.take(remaining));
        _photoError = false;
      });
    } finally {
      if (mounted) setState(() => _pickingPhoto = false);
    }
  }

  void _removeRoomPhoto(XFile file) {
    setState(() => _newRoomPhotos.remove(file));
  }

  /// Tambah & simpan tipe kamar — foto wajib (validateAndAddNewRoom).
  void _addRoomType() {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      AppToast.showError(
        context,
        title: 'Nama tipe kamar wajib diisi',
        description: 'Isi nama tipe kamar sebelum menyimpan',
      );
      return;
    }
    if (_newRoomPhotos.isEmpty) {
      setState(() => _photoError = true);
      AppToast.showError(
        context,
        title: 'Foto kamar wajib diunggah',
        description: 'Harap unggah minimal 1 foto kamar sebelum menyimpan',
      );
      return;
    }

    final price = int.tryParse(_priceCtrl.text.trim()) ?? 0;
    final empty = int.tryParse(_emptyCtrl.text.trim()) ?? 0;

    setState(() {
      _roomTypes.add({
        'id': DateTime.now().millisecondsSinceEpoch,
        'name': name,
        'size': _sizeCtrl.text.trim().isEmpty
            ? '3.5 x 4 m'
            : _sizeCtrl.text.trim(),
        'price': price,
        'empty': empty,
        'isAvailable': empty > 0,
        'photos': _newRoomPhotos.map((f) => f.path).toList(),
      });
      _nameCtrl.clear();
      _priceCtrl.clear();
      _newRoomPhotos.clear();
      _photoError = false;
    });

    AppToast.showSuccess(
      context,
      title: 'Tipe kamar "$name" ditambahkan',
      description: 'Ketersediaan langsung diperbarui',
    );
  }

  void _save() {
    final totalEmpty = _roomTypes.fold<int>(
      0,
      (sum, r) => sum + ((r['isAvailable'] as bool? ?? false)
          ? (r['empty'] as int? ?? 0)
          : 0),
    );
    widget.onSave({
      ...widget.kos,
      'roomTypes': _roomTypes,
      'available': totalEmpty,
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
            decoration: BoxDecoration(color: bg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header.
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
                                    'Kelola Kamar & Ketersediaan',
                                    style: AppTypography.labelMd.copyWith(
                                      color: textPrimary,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  Text(
                                    widget.kos['name'] as String? ?? '',
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
                // Body.
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
                      Text(
                        'Atur ketersediaan kamar kosong secara instan untuk memperbarui status di hasil pencarian penyewa.',
                        style: AppTypography.labelSm.copyWith(
                          color: textSecondary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      ..._roomTypes.asMap().entries.map(
                            (e) => Padding(
                              padding: const EdgeInsets.only(
                                bottom: AppSpacing.sm,
                              ),
                              child: _buildRoomCard(
                                index: e.key,
                                room: e.value,
                                scheme: scheme,
                                surface: surface,
                                fill: fill,
                                border: border,
                                textPrimary: textPrimary,
                                textSecondary: textSecondary,
                                success: success,
                              ),
                            ),
                          ),
                      const SizedBox(height: AppSpacing.xs),
                      _buildNewRoomCard(
                        scheme: scheme,
                        surface: surface,
                        fill: fill,
                        border: border,
                        textPrimary: textPrimary,
                        textSecondary: textSecondary,
                        error: error,
                      ),
                    ],
                  ),
                ),
                // Bottom action.
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
                  child: GestureDetector(
                    onTap: _save,
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
                          FaIcon(
                            FontAwesomeIcons.check,
                            size: 13,
                            color: scheme.onPrimary,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            'Selesai Atur Kamar',
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
        );
      },
    );
  }

  /// Kartu satu tipe kamar: nama + ukuran, toggle, tarif & kamar kosong.
  Widget _buildRoomCard({
    required int index,
    required Map<String, dynamic> room,
    required ColorScheme scheme,
    required Color surface,
    required Color fill,
    required Color border,
    required Color textPrimary,
    required Color textSecondary,
    required Color success,
  }) {
    final available = room['isAvailable'] as bool? ?? false;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: AppRadius.radiusLg,
        border: Border.all(color: border.withValues(alpha: 0.7)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    room['name'] as String? ?? 'Tipe Kamar',
                    style: AppTypography.labelMd.copyWith(
                      color: textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    room['size'] as String? ?? '',
                    style: AppTypography.labelXs.copyWith(
                      color: textSecondary,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
              Switch(
                value: available,
                onChanged: (v) => _toggleRoom(index, v),
                activeThumbColor: Colors.white,
                activeTrackColor: success,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.only(top: AppSpacing.sm),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: border.withValues(alpha: 0.4)),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tarif per Bulan',
                        style: AppTypography.labelXs.copyWith(
                          color: textSecondary,
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      _numberInput(
                        value: (room['price'] ?? 0).toString(),
                        onChanged: (v) => _updatePrice(index, v),
                        fill: fill,
                        border: border,
                        textPrimary: textPrimary,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Kamar Kosong',
                        style: AppTypography.labelXs.copyWith(
                          color: textSecondary,
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      _numberInput(
                        value: (room['empty'] ?? 0).toString(),
                        onChanged: (v) => _updateEmpty(index, v),
                        fill: fill,
                        border: border,
                        textPrimary: textPrimary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Form "Tambah Tipe Kamar" baru + foto wajib min. 1.
  Widget _buildNewRoomCard({
    required ColorScheme scheme,
    required Color surface,
    required Color fill,
    required Color border,
    required Color textPrimary,
    required Color textSecondary,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.add_circle_outline_rounded,
                    size: 16,
                    color: textPrimary,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    'TAMBAH TIPE KAMAR',
                    style: AppTypography.labelXs.copyWith(
                      color: textPrimary,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
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
                  color: fill,
                  borderRadius: AppRadius.radiusFull,
                ),
                child: Text(
                  'Form Kamar Baru',
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
                child: _labeledField(
                  label: 'Nama Tipe Kamar',
                  child: _textInput(
                    controller: _nameCtrl,
                    hint: 'Contoh: Deluxe Balcony',
                    fill: fill,
                    border: border,
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _labeledField(
                  label: 'Tarif / Bulan (Rp)',
                  child: _textInput(
                    controller: _priceCtrl,
                    hint: '2200000',
                    fill: fill,
                    border: border,
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: _labeledField(
                  label: 'Ukuran Kamar',
                  child: _textInput(
                    controller: _sizeCtrl,
                    hint: '3.5 x 4 m',
                    fill: fill,
                    border: border,
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _labeledField(
                  label: 'Jumlah Kamar Kosong',
                  child: _textInput(
                    controller: _emptyCtrl,
                    hint: '1',
                    fill: fill,
                    border: border,
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  text: 'Foto Kamar',
                  style: AppTypography.labelSm.copyWith(
                    color: textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                  children: const [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
              Text(
                '(Wajib min 1 foto, maks 3 foto)',
                style: AppTypography.labelXs.copyWith(
                  color: textSecondary,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          // Thumbnail foto kamar baru.
          if (_newRoomPhotos.isNotEmpty)
            SizedBox(
              height: 80,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _newRoomPhotos.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(width: AppSpacing.sm),
                itemBuilder: (context, i) {
                  final file = _newRoomPhotos[i];
                  return Container(
                    width: 80,
                    decoration: BoxDecoration(
                      borderRadius: AppRadius.radiusMd,
                      border: Border.all(color: border),
                    ),
                    child: ClipRRect(
                      borderRadius: AppRadius.radiusMd,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.file(
                            File(file.path),
                            fit: BoxFit.cover,
                            errorBuilder: (context, err, stack) => Container(
                              color: fill,
                              child: Icon(
                                Icons.image_outlined,
                                color: textSecondary,
                              ),
                            ),
                          ),
                          if (i == 0)
                            Positioned(
                              bottom: 4,
                              left: 4,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.xs,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: scheme.primary
                                      .withValues(alpha: 0.85),
                                  borderRadius: AppRadius.radiusFull,
                                ),
                                child: Text(
                                  'FOTO UTAMA',
                                  style: AppTypography.labelXs.copyWith(
                                    color: scheme.onPrimary,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 8,
                                  ),
                                ),
                              ),
                            ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () => _removeRoomPhoto(file),
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
                },
              ),
            ),
          const SizedBox(height: AppSpacing.xs),
          GestureDetector(
            onTap: _addRoomPhoto,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              decoration: BoxDecoration(
                color: fill,
                borderRadius: AppRadius.radiusMd,
                border: Border.all(
                  color: _photoError ? error : border,
                  width: _photoError ? 1.5 : 1,
                ),
              ),
              child: Column(
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
                    '+ Unggah Foto Kamar',
                    style: AppTypography.labelSm.copyWith(
                      color: textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'Format JPG, JPEG atau PNG (Maks. 3 foto)',
                    style: AppTypography.labelXs.copyWith(
                      color: textSecondary,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_photoError)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: error.withValues(alpha: 0.1),
                  borderRadius: AppRadius.radiusSm,
                ),
                child: Row(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.triangleExclamation,
                      size: 11,
                      color: error,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: Text(
                        'Harap unggah minimal 1 foto kamar sebelum menyimpan',
                        style: AppTypography.labelXs.copyWith(
                          color: error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: AppSpacing.md),
          GestureDetector(
            onTap: _addRoomType,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              decoration: BoxDecoration(
                color: scheme.primary,
                borderRadius: AppRadius.radiusFull,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(
                    FontAwesomeIcons.plus,
                    size: 12,
                    color: scheme.onPrimary,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    'Tambah & Simpan Tipe Kamar',
                    style: AppTypography.labelSm.copyWith(
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
    );
  }

  Widget _labeledField({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Builder(
          builder: (context) {
            final isLight =
                Theme.of(context).brightness == Brightness.light;
            return Text(
              label,
              style: AppTypography.labelXs.copyWith(
                color: isLight
                    ? AppColors.textSecondary
                    : AppColors.darkTextSecondary,
                fontWeight: FontWeight.w600,
                fontSize: 10,
              ),
            );
          },
        ),
        const SizedBox(height: AppSpacing.xs),
        child,
      ],
    );
  }

  Widget _numberInput({
    required String value,
    required ValueChanged<String> onChanged,
    required Color fill,
    required Color border,
    required Color textPrimary,
  }) {
    final controller = TextEditingController(text: value)
      ..selection = TextSelection.collapsed(offset: value.length);
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      onChanged: onChanged,
      style: AppTypography.labelSm.copyWith(
        color: textPrimary,
        fontWeight: FontWeight.w700,
      ),
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: fill,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.sm,
        ),
        border: OutlineInputBorder(
          borderRadius: AppRadius.radiusSm,
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.radiusSm,
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.radiusSm,
          borderSide: const BorderSide(color: AppColors.primary),
        ),
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
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: AppTypography.labelSm.copyWith(
        color: textPrimary,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTypography.labelSm.copyWith(color: textSecondary),
        isDense: true,
        filled: true,
        fillColor: fill,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
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
      ),
    );
  }
}
