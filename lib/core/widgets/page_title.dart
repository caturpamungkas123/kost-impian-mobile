import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class PageTitle extends StatelessWidget {
  const PageTitle(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final textPrimary =
        isLight ? AppColors.textPrimary : AppColors.darkTextPrimary;

    return Text(
      title,
      style: AppTypography.h2.copyWith(color: textPrimary),
    );
  }
}
