import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';

/// Bottom nav floating pill — glassmorphism + blur (satu-satunya
/// pengecualian shadow/blur per DESIGN.md). Active item: lingkaran
/// primary dengan ikon terang; inactive: ikon muted.
///
/// Ikon: FontAwesome (outline/regular saat non-aktif, solid saat aktif),
/// mengikuti gaya ikon tipis di referensi Stitch.
/// Ditaruh di core karena dipakai lintas tab (Home, Peta, Favorit,
/// Chat, Profil — sesuai prd.md §7.5).
class KosankuBottomNav extends StatelessWidget {
  const KosankuBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.unreadChatCount = 0,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  /// Badge angka pesan belum dibaca di ikon Chat (prd.md §3.5).
  final int unreadChatCount;

  static const _items = [
    (FontAwesomeIcons.house, FontAwesomeIcons.house, 'Explore'),
    (FontAwesomeIcons.map, FontAwesomeIcons.solidMap, 'Peta'),
    (FontAwesomeIcons.heart, FontAwesomeIcons.solidHeart, 'Favorit'),
    (FontAwesomeIcons.message, FontAwesomeIcons.solidMessage, 'Chat'),
    (FontAwesomeIcons.user, FontAwesomeIcons.solidUser, 'Profil'),
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isLight = Theme.of(context).brightness == Brightness.light;
    final muted =
        isLight ? AppColors.textSecondary : AppColors.darkTextSecondary;

    return ClipRRect(
      borderRadius: AppRadius.radiusFull,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isLight
                ? Colors.white.withValues(alpha: 0.88)
                : const Color(0xFF1F1D1A).withValues(alpha: 0.8),
            borderRadius: AppRadius.radiusFull,
            border: Border.all(
              color: isLight ? AppColors.border : AppColors.darkBorder,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(_items.length, (i) {
              final active = i == currentIndex;
              final (outline, filled, label) = _items[i];
              return GestureDetector(
                onTap: () => onTap(i),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: active ? scheme.primary : Colors.transparent,
                      ),
                      child: FaIcon(
                        active ? filled : outline,
                        size: 19,
                        color: active ? scheme.onPrimary : muted,
                        semanticLabel: label,
                      ),
                    ),
                    if (i == 3 && unreadChatCount > 0)
                      Positioned(
                        right: 6,
                        top: 6,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isLight
                                ? AppColors.success
                                : AppColors.darkSuccess,
                          ),
                          child: Text(
                            '$unreadChatCount',
                            style: const TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
