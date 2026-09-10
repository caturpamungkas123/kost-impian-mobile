import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import 'favorite_data.dart';

/// Kartu favorit — badge gelap + badge urgensi merah, hati merah
/// (tap = hapus dari favorit), rating, dan aksi Chat/Detail.
/// Flat tanpa shadow per DESIGN.md; ikon FA selalu ter-center.
class FavoriteKosCard extends StatelessWidget {
  const FavoriteKosCard({
    super.key,
    required this.item,
    required this.onRemove,
  });

  final FavoriteKos item;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isLight = Theme.of(context).brightness == Brightness.light;
    final border = isLight ? AppColors.border : AppColors.darkBorder;
    final muted =
        isLight ? AppColors.textSecondary : AppColors.darkTextSecondary;
    final chipBg = isLight ? AppColors.background : AppColors.darkBackground;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: const BorderRadius.all(Radius.circular(AppRadius.xl)),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(AppRadius.lg),
                ),
                child: Image.network(
                  item.imageUrl,
                  height: 192,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    height: 192,
                    color: chipBg,
                    alignment: Alignment.center,
                    child: FaIcon(
                      FontAwesomeIcons.house,
                      size: 40,
                      color: muted,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.8),
                        borderRadius: AppRadius.radiusFull,
                      ),
                      child: Text(
                        item.badge.toUpperCase(),
                        style: AppTypography.labelSm.copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    if (item.urgencyBadge != null) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isLight
                              ? AppColors.error
                              : AppColors.darkError,
                          borderRadius: AppRadius.radiusFull,
                        ),
                        child: Text(
                          item.urgencyBadge!,
                          style: AppTypography.labelSm.copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
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
                  onTap: onRemove,
                  child: Container(
                    width: 36,
                    height: 36,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: FaIcon(
                      FontAwesomeIcons.solidHeart,
                      size: 15,
                      color: isLight
                          ? AppColors.error
                          : AppColors.darkError,
                      semanticLabel: 'Hapus dari favorit',
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 10, 4, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: AppTypography.labelSm.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.locationDot,
                            size: 12,
                            color: muted,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              item.location,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.labelSm.copyWith(
                                fontSize: 12,
                                color: muted,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      item.price,
                      style: AppTypography.labelSm.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      '/ bulan',
                      style: AppTypography.labelSm.copyWith(
                        fontSize: 11,
                        color: muted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            children: [
              for (final amenity in item.amenities)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: chipBg,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(AppRadius.sm),
                    ),
                  ),
                  child: Text(
                    amenity,
                    style: AppTypography.labelSm.copyWith(
                      fontSize: 11,
                      color: muted,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Divider(height: 1, color: border),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.solidStar,
                    size: 13,
                    color: isLight
                        ? AppColors.warning
                        : AppColors.darkWarning,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${item.rating}',
                    style: AppTypography.labelSm.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '(${item.reviewCount} ulasan)',
                    style: AppTypography.labelSm.copyWith(
                      fontSize: 12,
                      color: muted,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  if (item.showChatAction) ...[
                    _ActionPill(
                      label: 'Chat Pemilik',
                      filled: false,
                      onTap: () {},
                    ),
                    const SizedBox(width: 8),
                  ],
                  _ActionPill(
                    label: 'Lihat Detail',
                    filled: true,
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionPill extends StatelessWidget {
  const _ActionPill({
    required this.label,
    required this.filled,
    required this.onTap,
  });

  final String label;
  final bool filled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isLight = Theme.of(context).brightness == Brightness.light;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: filled
              ? scheme.primary
              : (isLight ? AppColors.background : AppColors.darkBackground),
          borderRadius: AppRadius.radiusFull,
        ),
        child: Text(
          label,
          style: AppTypography.labelSm.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: filled ? scheme.onPrimary : scheme.primary,
          ),
        ),
      ),
    );
  }
}
