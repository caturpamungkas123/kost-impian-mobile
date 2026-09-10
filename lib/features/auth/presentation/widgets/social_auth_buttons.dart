import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';

/// Tombol login sosial pill — Google & Apple (UI-first, dummy action).
class SocialAuthButtons extends StatelessWidget {
  const SocialAuthButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isLight = Theme.of(context).brightness == Brightness.light;
    final border = isLight ? AppColors.border : AppColors.darkBorder;

    Widget button(FaIconData icon, String label) {
      return Expanded(
        child: OutlinedButton.icon(
          onPressed: () {},
          icon: FaIcon(icon, size: 15),
          label: Text(
            label,
            style: AppTypography.labelSm.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: scheme.primary,
            side: BorderSide(color: border),
            shape: const RoundedRectangleBorder(
              borderRadius: AppRadius.radiusFull,
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      );
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(color: border)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'ATAU LANJUTKAN DENGAN',
                style: AppTypography.labelSm.copyWith(
                  fontSize: 11,
                  color: isLight
                      ? AppColors.textSecondary
                      : AppColors.darkTextSecondary,
                ),
              ),
            ),
            Expanded(child: Divider(color: border)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            button(FontAwesomeIcons.google, 'Google'),
            const SizedBox(width: 12),
            button(FontAwesomeIcons.apple, 'Apple'),
          ],
        ),
      ],
    );
  }
}
