import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../../core/widgets/page_title.dart';
import '../widgets/edit_kos_modal.dart';
import '../widgets/kelola_kamar_modal.dart';
import '../widgets/tambah_kos_modal.dart';

class KelolaListingPage extends StatefulWidget {
  const KelolaListingPage({super.key});

  static const routeName = '/kelola-listing';

  @override
  State<KelolaListingPage> createState() => _KelolaListingPageState();
}

class _KelolaListingPageState extends State<KelolaListingPage> {
  String _filter = 'all';

  final List<Map<String, dynamic>> _dummyKos = [
    {
      'id': 1,
      'name': 'KosanKu Urban Kemang',
      'price': 2450000,
      'address': 'Jl. Bangka Raya No. 12, Kemang, Jakarta Selatan',
      'type': 'Campur',
      'rating': 4.9,
      'reviews': 42,
      'rooms': 12,
      'available': 2,
      'facilities': ['WiFi 100Mbps', 'K. Mandi Dalam', 'AC Dingin', '+1'],
      'image':
          'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=800',
      'active': true,
      'featured': true,
    },
    {
      'id': 2,
      'name': 'KosanKu Kebayoran Suites',
      'price': 1950000,
      'address': 'Jl. Gandaria I No. 8, Kebayoran Baru, Jakarta Selatan',
      'type': 'Khusus Putri',
      'rating': 4.8,
      'reviews': 18,
      'rooms': 8,
      'available': 3,
      'facilities': ['WiFi', 'AC', 'Dapur Bersama'],
      'image':
          'https://images.unsplash.com/photo-1555854877-bab0e564b8d5?w=800',
      'active': true,
      'featured': false,
    },
  ];

  void _showUpgradeModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _UpgradeModal(),
    );
  }

  void _showDeleteModal(BuildContext context, int kosId) {
    showDialog(
      context: context,
      builder: (context) => _DeleteConfirmationDialog(
        kosId: kosId,
        onConfirm: () {
          setState(() {
            _dummyKos.removeWhere((k) => k['id'] == kosId);
          });
          Navigator.of(context).pop();
          AppToast.showSuccess(
            context,
            title: 'Kos berhasil dihapus',
            description: 'Data kos telah dihapus dari listing Anda',
          );
        },
      ),
    );
  }

  void _showTambahKosModal() {
    // Cek kuota mengikuti Stitch openAddKosModal() (PRD 4.1 Step 2).
    const quotaLimit = 5;
    if (_dummyKos.length >= quotaLimit) {
      AppToast.showWarning(
        context,
        title: 'Limit listing tercapai ($quotaLimit kos)',
        description: 'Silakan upgrade paket untuk menambah listing baru',
      );
      return;
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
        ),
        child: TambahKosModal(
          onSave: (newKos) {
            setState(() => _dummyKos.insert(0, newKos));
            AppToast.showSuccess(
              context,
              title: 'Kos "${newKos['name']}" berhasil diterbitkan!',
              description: 'Listing baru sudah aktif dan tampil di Explore',
            );
          },
        ),
      ),
    );
  }

  void _handleEditKos(int kosId) {
    final index = _dummyKos.indexWhere((k) => k['id'] == kosId);
    if (index == -1) return;
    final kos = _dummyKos[index];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
        ),
        child: EditKosModal(
          kos: kos,
          onSave: (updatedKos) {
            setState(() => _dummyKos[index] = updatedKos);
            AppToast.showSuccess(
              context,
              title: 'Perubahan disimpan!',
              description: 'Data kos "${updatedKos['name']}" telah diperbarui',
            );
          },
        ),
      ),
    );
  }

  void _handleKelolaKamar(int kosId) {
    final index = _dummyKos.indexWhere((k) => k['id'] == kosId);
    if (index == -1) return;
    final kos = _dummyKos[index];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
        ),
        child: KelolaKamarModal(
          kos: kos,
          onSave: (updatedKos) {
            setState(() => _dummyKos[index] = updatedKos);
            AppToast.showSuccess(
              context,
              title: 'Ketersediaan kamar berhasil diperbarui!',
              description:
                  '${updatedKos['available']} kamar kosong untuk "${updatedKos['name']}"',
            );
          },
        ),
      ),
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

    final filtered = _filter == 'all'
        ? _dummyKos
        : _dummyKos.where((k) => k['active'] == true).toList();

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.lg,
                AppSpacing.sm,
              ),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: PageTitle('Kelola Listing Kos'),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.only(
                  left: AppSpacing.lg,
                  right: AppSpacing.lg,
                  bottom: 120,
                ),
                children: [
                  _buildSubscriptionCard(
                    scheme,
                    isLight,
                    surface,
                    border,
                    textPrimary,
                    textSecondary,
                  ),
                  SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: border.withValues(alpha: 0.5),
                          borderRadius: AppRadius.radiusFull,
                        ),
                        child: Row(
                          children: [
                            _buildFilterChip(
                              'Semua (${_dummyKos.length})',
                              _filter == 'all',
                              () => setState(() => _filter = 'all'),
                              scheme,
                              textPrimary,
                              textSecondary,
                            ),
                            _buildFilterChip(
                              'Aktif (${_dummyKos.where((k) => k['active'] == true).length})',
                              _filter == 'active',
                              () => setState(() => _filter = 'active'),
                              scheme,
                              textPrimary,
                              textSecondary,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: GestureDetector(
                          onTap: _showTambahKosModal,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: AppSpacing.sm,
                              horizontal: AppSpacing.md,
                            ),
                            decoration: BoxDecoration(
                              color: scheme.primary,
                              borderRadius: AppRadius.radiusFull,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.plus,
                                  size: 14,
                                  color: scheme.onPrimary,
                                ),
                                SizedBox(width: AppSpacing.xs),
                                Text(
                                  'Tambah Kos',
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
                  SizedBox(height: AppSpacing.md),
                  ...filtered.map(
                    (kos) => Padding(
                      padding: EdgeInsets.only(bottom: AppSpacing.md),
                      child: _buildKosCard(
                        kos,
                        scheme,
                        isLight,
                        surface,
                        border,
                        textPrimary,
                        textSecondary,
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
  }

  Widget _buildSubscriptionCard(
    ColorScheme scheme,
    bool isLight,
    Color surface,
    Color border,
    Color textPrimary,
    Color textSecondary,
  ) {
    final warning = isLight ? AppColors.warning : AppColors.darkWarning;
    final success = isLight ? AppColors.success : AppColors.darkSuccess;

    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: AppRadius.radius3xl,
        border: Border.all(color: border.withValues(alpha: 0.7)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: warning.withValues(alpha: 0.1),
                      borderRadius: AppRadius.radiusLg,
                    ),
                    child: Icon(
                      Icons.workspace_premium_rounded,
                      color: warning,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'PAKET LANGGANAN',
                            style: AppTypography.labelXs.copyWith(
                              color: textSecondary,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(width: AppSpacing.xs),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSpacing.xs,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: success.withValues(alpha: 0.15),
                              borderRadius: AppRadius.radiusFull,
                            ),
                            child: Text(
                              'Aktif',
                              style: AppTypography.labelXs.copyWith(
                                color: success,
                                fontWeight: FontWeight.w700,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Paket Pro Bisnis',
                        style: AppTypography.labelMd.copyWith(
                          color: textPrimary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: scheme.primary,
                          borderRadius: AppRadius.radiusFull,
                        ),
                        child: GestureDetector(
                          onTap: () => _showUpgradeModal(context),
                          child: Text(
                            '+ Upgrade',
                            style: AppTypography.labelXs.copyWith(
                              color: scheme.onPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '2 dari 5 Kuota Listing',
                    style: AppTypography.labelSm.copyWith(
                      color: textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '40% Terpakai',
                    style: AppTypography.labelSm.copyWith(
                      color: textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.xs),
              ClipRRect(
                borderRadius: AppRadius.radiusFull,
                child: LinearProgressIndicator(
                  value: 0.4,
                  backgroundColor: border.withValues(alpha: 0.3),
                  valueColor: AlwaysStoppedAnimation(scheme.primary),
                  minHeight: 10,
                ),
              ),
              SizedBox(height: AppSpacing.xs),
              Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.solidCircleCheck,
                    size: 12,
                    color: success,
                  ),
                  SizedBox(width: AppSpacing.xs),
                  Text(
                    'Sisa 3 kuota listing aktif siap ditambahkan.',
                    style: AppTypography.labelXs.copyWith(
                      color: textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    String label,
    bool active,
    VoidCallback onTap,
    ColorScheme scheme,
    Color textPrimary,
    Color textSecondary,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: active ? scheme.primary : Colors.transparent,
          borderRadius: AppRadius.radiusFull,
        ),
        child: Text(
          label,
          style: AppTypography.labelSm.copyWith(
            color: active ? scheme.onPrimary : textSecondary,
            fontWeight: active ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildKosCard(
    Map<String, dynamic> kos,
    ColorScheme scheme,
    bool isLight,
    Color surface,
    Color border,
    Color textPrimary,
    Color textSecondary,
  ) {
    final success = isLight ? AppColors.success : AppColors.darkSuccess;
    final warning = isLight ? AppColors.warning : AppColors.darkWarning;

    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: AppRadius.radius3xl,
        border: Border.all(color: border.withValues(alpha: 0.7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppRadius.radius3xl.topLeft.x),
                ),
                child: Container(
                  height: 176,
                  decoration: BoxDecoration(
                    color: border.withValues(alpha: 0.2),
                  ),
                  child: Image.network(
                    kos['image'],
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: border.withValues(alpha: 0.2),
                    ),
                  ),
                ),
              ),
              Container(
                height: 176,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(AppRadius.radius3xl.topLeft.x),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.2),
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.6),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Row(
                  children: [
                    if (kos['active'])
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: success,
                          borderRadius: AppRadius.radiusFull,
                        ),
                        child: Text(
                          'AKTIF',
                          style: AppTypography.labelXs.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 10,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    if (kos['featured']) ...[
                      SizedBox(width: AppSpacing.xs),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: warning,
                          borderRadius: AppRadius.radiusFull,
                        ),
                        child: Row(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.solidStar,
                              size: 9,
                              color: Colors.black,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'UNGGULAN',
                              style: AppTypography.labelXs.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w800,
                                fontSize: 10,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: GestureDetector(
                  onTap: () => _showDeleteModal(context, kos['id'] as int),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withValues(alpha: 0.5),
                    ),
                    child: Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 12,
                left: 12,
                right: 12,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: AppRadius.radiusFull,
                      ),
                      child: Text(
                        kos['type'],
                        style: AppTypography.labelXs.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        borderRadius: AppRadius.radiusFull,
                      ),
                      child: Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.solidStar,
                            size: 10,
                            color: warning,
                          ),
                          SizedBox(width: 4),
                          Text(
                            '${kos['rating']}',
                            style: AppTypography.labelXs.copyWith(
                              color: textPrimary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(width: 2),
                          Text(
                            '(${kos['reviews']})',
                            style: AppTypography.labelXs.copyWith(
                              color: textSecondary,
                              fontWeight: FontWeight.w400,
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
          Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        kos['name'],
                        style: AppTypography.h4.copyWith(
                          color: textPrimary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    SizedBox(width: AppSpacing.sm),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Rp ${(kos['price'] / 1000).toStringAsFixed(0)}rb',
                          style: AppTypography.labelMd.copyWith(
                            color: textPrimary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          '/ bulan',
                          style: AppTypography.labelXs.copyWith(
                            color: textSecondary,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.xs),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.locationDot,
                      size: 11,
                      color: textSecondary,
                    ),
                    SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: Text(
                        kos['address'],
                        style: AppTypography.labelSm.copyWith(
                          color: textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: (kos['facilities'] as List<String>)
                      .map(
                        (f) => Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.xs,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: border.withValues(alpha: 0.3),
                            borderRadius: AppRadius.radiusSm,
                          ),
                          child: Text(
                            f,
                            style: AppTypography.labelXs.copyWith(
                              color: textSecondary,
                              fontWeight: FontWeight.w500,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                SizedBox(height: AppSpacing.sm),
                Container(
                  padding: EdgeInsets.only(top: AppSpacing.sm),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: border.withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.doorOpen,
                            size: 14,
                            color: textSecondary,
                          ),
                          SizedBox(width: AppSpacing.xs),
                          Text(
                            '${kos['rooms']} Total Kamar',
                            style: AppTypography.labelSm.copyWith(
                              color: textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: success.withValues(alpha: 0.15),
                          borderRadius: AppRadius.radiusFull,
                        ),
                        child: Text(
                          '• ${kos['available']} Kamar Kosong',
                          style: AppTypography.labelXs.copyWith(
                            color: success,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _handleEditKos(kos['id'] as int),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: AppSpacing.sm,
                          ),
                          decoration: BoxDecoration(
                            color: surface,
                            border: Border.all(color: border),
                            borderRadius: AppRadius.radiusFull,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FaIcon(
                                FontAwesomeIcons.penToSquare,
                                size: 14,
                                color: textPrimary,
                              ),
                              SizedBox(width: AppSpacing.xs),
                              Text(
                                'Edit Data Kos',
                                style: AppTypography.labelSm.copyWith(
                                  color: textPrimary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _handleKelolaKamar(kos['id'] as int),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: AppSpacing.sm,
                          ),
                          decoration: BoxDecoration(
                            color: scheme.primary,
                            borderRadius: AppRadius.radiusFull,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FaIcon(
                                FontAwesomeIcons.key,
                                size: 14,
                                color: scheme.onPrimary,
                              ),
                              SizedBox(width: AppSpacing.xs),
                              Text(
                                'Kelola Kamar',
                                style: AppTypography.labelSm.copyWith(
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DeleteConfirmationDialog extends StatelessWidget {
  const _DeleteConfirmationDialog({
    required this.kosId,
    required this.onConfirm,
  });

  final int kosId;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final surface = isLight ? AppColors.surface : AppColors.darkSurface;
    final textPrimary =
        isLight ? AppColors.textPrimary : AppColors.darkTextPrimary;
    final textSecondary =
        isLight ? AppColors.textSecondary : AppColors.darkTextSecondary;
    final error = isLight ? AppColors.error : AppColors.darkError;

    return Dialog(
      backgroundColor: surface,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.radiusXl,
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.delete_outline_rounded,
                color: error,
                size: 28,
              ),
            ),
            SizedBox(height: AppSpacing.md),
            Text(
              'Hapus Listing Kos?',
              style: AppTypography.h4.copyWith(
                color: textPrimary,
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.xs),
            Text(
              'Data kos akan dihapus permanen dan tidak dapat dikembalikan.',
              style: AppTypography.bodyMd.copyWith(
                color: textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: surface,
                        border: Border.all(
                          color: isLight ? AppColors.border : AppColors.darkBorder,
                        ),
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
                SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: GestureDetector(
                    onTap: onConfirm,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: error,
                        borderRadius: AppRadius.radiusFull,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Hapus',
                        style: AppTypography.labelMd.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _UpgradeModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isLight = Theme.of(context).brightness == Brightness.light;
    final surface = isLight ? AppColors.surface : AppColors.darkSurface;
    final textPrimary =
        isLight ? AppColors.textPrimary : AppColors.darkTextPrimary;
    final textSecondary =
        isLight ? AppColors.textSecondary : AppColors.darkTextSecondary;
    final warning = isLight ? AppColors.warning : AppColors.darkWarning;

    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.xl),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isLight
                  ? AppColors.border
                  : AppColors.darkBorder,
              borderRadius: AppRadius.radiusFull,
            ),
          ),
          SizedBox(height: AppSpacing.lg),
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: warning.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.workspace_premium_rounded,
              color: warning,
              size: 32,
            ),
          ),
          SizedBox(height: AppSpacing.md),
          Text(
            'Upgrade ke Paket Pro',
            style: AppTypography.h2.copyWith(
              color: textPrimary,
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacing.xs),
          Text(
            'Dapatkan listing tanpa batas, fitur Kos Unggulan, dan prioritas customer support.',
            style: AppTypography.bodyMd.copyWith(
              color: textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacing.lg),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
              AppToast.showInfo(
                context,
                title: 'Langganan',
                description: 'Navigasi ke halaman paket langganan',
              );
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
              decoration: BoxDecoration(
                color: scheme.primary,
                borderRadius: AppRadius.radiusFull,
              ),
              alignment: Alignment.center,
              child: Text(
                'Lihat Paket Langganan',
                style: AppTypography.labelMd.copyWith(
                  color: scheme.onPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
              alignment: Alignment.center,
              child: Text(
                'Nanti Saja',
                style: AppTypography.labelMd.copyWith(
                  color: textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
