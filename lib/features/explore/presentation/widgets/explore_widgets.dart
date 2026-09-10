import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';

/// Header Explore: lokasi + judul di kiri, notifikasi + avatar di kanan.
class ExploreHeader extends StatelessWidget {
  const ExploreHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isLight = Theme.of(context).brightness == Brightness.light;
    final border = isLight ? AppColors.border : AppColors.darkBorder;
    final muted =
        isLight ? AppColors.textSecondary : AppColors.darkTextSecondary;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                FaIcon(FontAwesomeIcons.locationDot, size: 12, color: muted),
                const SizedBox(width: 2),
                Text(
                  'Jakarta Selatan',
                  style: AppTypography.labelSm.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: muted,
                  ),
                ),
                FaIcon(FontAwesomeIcons.chevronDown, size: 11, color: muted),
              ],
            ),
            const SizedBox(height: 2),
            Text('Explore Kos', style: AppTypography.h2),
          ],
        ),
        Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: scheme.surface,
                    border: Border.all(color: border),
                  ),
                  child: const FaIcon(
                    FontAwesomeIcons.bell,
                    size: 17,
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isLight
                          ? AppColors.error
                          : AppColors.darkError,
                      border: Border.all(
                        color: scheme.surface,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: scheme.primary,
                border: Border.all(color: border),
              ),
              child: FaIcon(
                FontAwesomeIcons.user,
                size: 17,
                color: scheme.onPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Search bar pill + tombol filter lingkaran (DESIGN.md: full pill).
class ExploreSearchBar extends StatelessWidget {
  const ExploreSearchBar({
    super.key,
    required this.onChanged,
    required this.onFilterTap,
  });

  final ValueChanged<String> onChanged;
  final VoidCallback onFilterTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isLight = Theme.of(context).brightness == Brightness.light;
    final border = isLight ? AppColors.border : AppColors.darkBorder;
    final muted =
        isLight ? AppColors.textSecondary : AppColors.darkTextSecondary;

    return Row(
      children: [
        Expanded(
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: AppRadius.radiusFull,
              border: Border.all(color: border),
            ),
            child: Row(
              children: [
                FaIcon(FontAwesomeIcons.magnifyingGlass, size: 17, color: muted),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    onChanged: onChanged,
                    style: AppTypography.bodyMd,
                    decoration: InputDecoration(
                      hintText: 'Cari nama kos, area, kampus...',
                      hintStyle:
                          AppTypography.bodyMd.copyWith(color: muted),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: onFilterTap,
          child: Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: scheme.surface,
              border: Border.all(color: border),
            ),
            child: const FaIcon(FontAwesomeIcons.sliders, size: 18),
          ),
        ),
      ],
    );
  }
}

/// Deretan filter pill horizontal — active = primary (DESIGN.md).
class FilterPills extends StatelessWidget {
  const FilterPills({
    super.key,
    required this.filters,
    required this.selected,
    required this.onSelected,
  });

  final List<String> filters;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isLight = Theme.of(context).brightness == Brightness.light;
    final border = isLight ? AppColors.border : AppColors.darkBorder;
    final muted =
        isLight ? AppColors.textSecondary : AppColors.darkTextSecondary;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var i = 0; i < filters.length; i++) ...[
            GestureDetector(
              onTap: () => onSelected(filters[i]),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: filters[i] == selected
                      ? scheme.primary
                      : scheme.surface,
                  borderRadius: AppRadius.radiusFull,
                  border: filters[i] == selected
                      ? null
                      : Border.all(color: border),
                ),
                child: Text(
                  filters[i],
                  style: AppTypography.labelSm.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: filters[i] == selected
                        ? scheme.onPrimary
                        : muted,
                  ),
                ),
              ),
            ),
            if (i < filters.length - 1) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

/// Judul section + aksi kanan ("Lihat semua" / info).
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.trailing,
    this.proTag = false,
  });

  final String title;
  final String? trailing;
  final bool proTag;

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final muted =
        isLight ? AppColors.textSecondary : AppColors.darkTextSecondary;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              title,
              style: AppTypography.labelSm.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (proTag) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: isLight
                      ? AppColors.success.withValues(alpha: 0.15)
                      : AppColors.darkSuccess.withValues(alpha: 0.2),
                  borderRadius: AppRadius.radiusFull,
                ),
                child: Text(
                  'PRO',
                  style: AppTypography.labelSm.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: isLight
                        ? AppColors.success
                        : AppColors.darkSuccess,
                  ),
                ),
              ),
            ],
          ],
        ),
        if (trailing != null)
          Text(
            trailing!,
            style: AppTypography.labelSm.copyWith(
              fontSize: 12,
              color: muted,
            ),
          ),
      ],
    );
  }
}
