import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

import '../theme/app_colors.dart';

class AppToast {
  const AppToast._();

  static void showSuccess(
    BuildContext context, {
    required String title,
    String? description,
    Duration duration = const Duration(seconds: 3),
  }) {
    toastification.show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.flatColored,
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
      ),
      description: description != null
          ? Text(
              description,
              style: const TextStyle(fontSize: 13),
            )
          : null,
      autoCloseDuration: duration,
      primaryColor: AppColors.success,
      backgroundColor: AppColors.success.withValues(alpha: 0.1),
      foregroundColor: AppColors.success,
      borderRadius: BorderRadius.circular(16),
      showProgressBar: false,
      closeButton: const ToastCloseButton(
        showType: CloseButtonShowType.onHover,
      ),
      dragToClose: true,
    );
  }

  static void showError(
    BuildContext context, {
    required String title,
    String? description,
    Duration duration = const Duration(seconds: 4),
  }) {
    toastification.show(
      context: context,
      type: ToastificationType.error,
      style: ToastificationStyle.flatColored,
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
      ),
      description: description != null
          ? Text(
              description,
              style: const TextStyle(fontSize: 13),
            )
          : null,
      autoCloseDuration: duration,
      primaryColor: AppColors.error,
      backgroundColor: AppColors.error.withValues(alpha: 0.1),
      foregroundColor: AppColors.error,
      borderRadius: BorderRadius.circular(16),
      showProgressBar: false,
      closeButton: const ToastCloseButton(
        showType: CloseButtonShowType.onHover,
      ),
      dragToClose: true,
    );
  }

  static void showWarning(
    BuildContext context, {
    required String title,
    String? description,
    Duration duration = const Duration(seconds: 3),
  }) {
    toastification.show(
      context: context,
      type: ToastificationType.warning,
      style: ToastificationStyle.flatColored,
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
      ),
      description: description != null
          ? Text(
              description,
              style: const TextStyle(fontSize: 13),
            )
          : null,
      autoCloseDuration: duration,
      primaryColor: AppColors.warning,
      backgroundColor: AppColors.warning.withValues(alpha: 0.1),
      foregroundColor: AppColors.warning,
      borderRadius: BorderRadius.circular(16),
      showProgressBar: false,
      closeButton: const ToastCloseButton(
        showType: CloseButtonShowType.onHover,
      ),
      dragToClose: true,
    );
  }

  static void showInfo(
    BuildContext context, {
    required String title,
    String? description,
    Duration duration = const Duration(seconds: 3),
  }) {
    toastification.show(
      context: context,
      type: ToastificationType.info,
      style: ToastificationStyle.flatColored,
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
      ),
      description: description != null
          ? Text(
              description,
              style: const TextStyle(fontSize: 13),
            )
          : null,
      autoCloseDuration: duration,
      primaryColor: AppColors.primary,
      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
      foregroundColor: AppColors.primary,
      borderRadius: BorderRadius.circular(16),
      showProgressBar: false,
      closeButton: const ToastCloseButton(
        showType: CloseButtonShowType.onHover,
      ),
      dragToClose: true,
    );
  }
}
