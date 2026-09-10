import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../theme/app_radius.dart';
import '../theme/app_typography.dart';

/// Tombol pill reusable — full pill (9999px) wajib per DESIGN.md.
/// Varian primary memakai token primary (di-invert otomatis di dark mode
/// lewat Theme.of(context).colorScheme).
class PillButton extends StatelessWidget {
  const PillButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.trailing,
    this.backgroundColor,
    this.foregroundColor,
  });

  final String label;
  final VoidCallback onPressed;
  final Widget? trailing;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? scheme.surface,
          foregroundColor: foregroundColor ?? scheme.primary,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.radiusFull,
          ),
          padding: const EdgeInsets.only(left: 28, right: 10),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: AppTypography.ctaLabel.copyWith(
                  color: foregroundColor ?? scheme.primary,
                ),
              ),
            ),
            if (trailing case final Widget widget) widget,
          ],
        ),
      ),
    );
  }
}

/// Lingkaran panah hitam di dalam CTA putih (sesuai referensi Stitch).
class CircleArrow extends StatelessWidget {
  const CircleArrow({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isLight =
        Theme.of(context).brightness == Brightness.light;
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isLight ? const Color(0xFF1A1A1A) : scheme.primary,
      ),
      child: FaIcon(
        FontAwesomeIcons.arrowRight,
        size: 16,
        color: isLight ? Colors.white : scheme.onPrimary,
      ),
    );
  }
}
