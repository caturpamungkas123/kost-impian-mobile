import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import 'kos_detail_data.dart';

/// Kumpulan widget kecil Detail Kos — flat tanpa shadow (DESIGN.md menang
/// atas prd §7.5), pill untuk CTA/badge, rounded 24-32 untuk gambar & card.
class DetailGallery extends StatelessWidget {
  const DetailGallery({
    super.key,
    required this.images,
    required this.index,
    required this.onIndexChanged,
    required this.badge,
    required this.remainingLabel,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.onBack,
  });

  final List<String> images;
  final int index;
  final ValueChanged<int> onIndexChanged;
  final String badge;
  final String remainingLabel;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    // Galeri full-bleed (di bawah poni), tapi tombol overlay wajib di bawah
    // safe-area supaya tidak tertutup poni/status bar tiap device.
    final safeTop = MediaQuery.of(context).padding.top;
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(AppRadius.xl),
            bottomRight: Radius.circular(AppRadius.xl),
          ),
          child: SizedBox(
            height: 320,
            width: double.infinity,
            child: PageView.builder(
              itemCount: images.length,
              onPageChanged: onIndexChanged,
              itemBuilder: (context, i) => Image.network(
                images[i],
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  color: Theme.of(context).brightness == Brightness.light
                      ? AppColors.tertiary
                      : AppColors.darkTertiary,
                  alignment: Alignment.center,
                  child: const FaIcon(FontAwesomeIcons.house, size: 48),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: safeTop + 12,
          left: 16,
          right: 16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _CircleGlassButton(
                icon: FontAwesomeIcons.chevronLeft,
                onTap: onBack,
              ),
              Row(
                children: [
                  _CircleGlassButton(
                    icon: FontAwesomeIcons.shareNodes,
                    onTap: () {},
                  ),
                  const SizedBox(width: 8),
                  _CircleGlassButton(
                    icon: isFavorite
                        ? FontAwesomeIcons.solidHeart
                        : FontAwesomeIcons.heart,
                    iconColor: isFavorite ? AppColors.error : null,
                    onTap: onFavoriteToggle,
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: safeTop + 64,
          left: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.92),
              borderRadius: AppRadius.radiusFull,
            ),
            child: Text(
              badge,
              style: AppTypography.labelSm.copyWith(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),
        Positioned(
          top: safeTop + 64,
          right: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: AppRadius.radiusFull,
            ),
            child: Text(
              remainingLabel,
              style: AppTypography.labelSm.copyWith(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 14,
          right: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.55),
              borderRadius: AppRadius.radiusFull,
            ),
            child: Text(
              '${index + 1}/${images.length} Foto',
              style: AppTypography.labelSm.copyWith(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CircleGlassButton extends StatelessWidget {
  const _CircleGlassButton({
    required this.icon,
    required this.onTap,
    this.iconColor,
  });

  final FaIconData icon;
  final VoidCallback onTap;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: 0.92),
        ),
        child: FaIcon(icon, size: 15, color: iconColor ?? AppColors.textPrimary),
      ),
    );
  }
}

/// Bento spesifikasi 4 kolom (prd §3.3) — rounded 16, flat.
class SpecBento extends StatelessWidget {
  const SpecBento({super.key});

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final muted =
        isLight ? AppColors.textSecondary : AppColors.darkTextSecondary;

    return Row(
      children: [
        for (var i = 0; i < dummySpecs.length; i++) ...[
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.all(
                  Radius.circular(AppRadius.md),
                ),
                border: Border.all(
                  color: isLight ? AppColors.border : AppColors.darkBorder,
                ),
              ),
              child: Column(
                children: [
                  FaIcon(dummySpecs[i].icon, size: 16, color: muted),
                  const SizedBox(height: 6),
                  Text(
                    dummySpecs[i].value,
                    style: AppTypography.labelSm.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    dummySpecs[i].label,
                    style: AppTypography.labelSm.copyWith(
                      fontSize: 10,
                      color: muted,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (i < dummySpecs.length - 1)
            const SizedBox(width: AppSpacing.sm),
        ],
      ],
    );
  }
}

/// Kartu pemilik + tombol "Chat di Aplikasi" (shortcut conversation
/// user_id/owner_id/kos_id — prd §3.5, bukan cari manual di inbox).
class OwnerCard extends StatelessWidget {
  const OwnerCard({super.key, required this.onChatTap});

  final VoidCallback onChatTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isLight = Theme.of(context).brightness == Brightness.light;
    final muted =
        isLight ? AppColors.textSecondary : AppColors.darkTextSecondary;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: const BorderRadius.all(Radius.circular(AppRadius.lg)),
        border: Border.all(
          color: isLight ? AppColors.border : AppColors.darkBorder,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: scheme.primary,
            ),
            child: Text(
              'BK',
              style: AppTypography.labelSm.copyWith(
                fontWeight: FontWeight.w800,
                color: scheme.onPrimary,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        'Berkah Kost',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.labelSm.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    FaIcon(
                      FontAwesomeIcons.circleCheck,
                      size: 13,
                      color: isLight
                          ? AppColors.success
                          : AppColors.darkSuccess,
                    ),
                  ],
                ),
                Text(
                  'Pemilik • Balas ~5 mnt',
                  style: AppTypography.labelSm.copyWith(
                    fontSize: 11,
                    color: muted,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onChatTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: scheme.primary,
                borderRadius: AppRadius.radiusFull,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FaIcon(
                    FontAwesomeIcons.message,
                    size: 12,
                    color: scheme.onPrimary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Chat',
                    style: AppTypography.labelSm.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: scheme.onPrimary,
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
}

class DetailSectionTitle extends StatelessWidget {
  const DetailSectionTitle({
    super.key,
    required this.title,
    this.trailing,
    this.onTrailingTap,
  });

  final String title;
  final String? trailing;
  final VoidCallback? onTrailingTap;

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final muted =
        isLight ? AppColors.textSecondary : AppColors.darkTextSecondary;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTypography.labelSm.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (trailing != null)
          GestureDetector(
            onTap: onTrailingTap,
            child: Text(
              trailing!,
              style: AppTypography.labelSm.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: muted,
              ),
            ),
          ),
      ],
    );
  }
}
