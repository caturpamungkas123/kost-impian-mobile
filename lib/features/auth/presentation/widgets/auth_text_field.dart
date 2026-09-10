import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';

/// Field teks auth — mengikuti token DESIGN.md `input`:
/// background surface, teks primary, full pill, padding 14/20.
/// Ikon prefix opsional, aksi suffix opsional (mis. toggle password).
/// Validasi lokal via [validator] (wajib-isi + tipe data),
/// dieksekusi oleh Form induk saat CTA ditekan.
class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    this.label,
    required this.hint,
    required this.prefixIcon,
    this.suffix,
    this.keyboardType,
    this.obscureText = false,
    this.controller,
    this.validator,
    this.textInputAction,
  });

  final String? label;
  final String hint;
  final FaIconData prefixIcon;
  final Widget? suffix;
  final TextInputType? keyboardType;
  final bool obscureText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final border = isLight ? AppColors.border : AppColors.darkBorder;
    final muted =
        isLight ? AppColors.textSecondary : AppColors.darkTextSecondary;
    final labelText = label;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null && labelText.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              labelText,
              style: AppTypography.labelSm.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 4),
        ],
        TextFormField(
          controller: controller,
          validator: validator,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          style: AppTypography.bodyMd,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTypography.bodyMd.copyWith(color: muted),
            errorStyle: AppTypography.labelSm.copyWith(fontSize: 11),
            prefixIcon: SizedBox(
              width: 48,
              child: Center(
                child: FaIcon(prefixIcon, size: 18, color: muted),
              ),
            ),
            suffixIcon: suffix,
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 20,
            ),
            border: OutlineInputBorder(
              borderRadius: AppRadius.radiusFull,
              borderSide: BorderSide(color: border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.radiusFull,
              borderSide: BorderSide(color: border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadius.radiusFull,
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
