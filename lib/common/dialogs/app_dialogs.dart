import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/sizes.dart';
import '../../utils/constants/text_strings.dart'; // Add this import

/// Centralized dialog system for consistent error/success/confirmation handling
class AppDialogs {
  AppDialogs._(); // Private constructor to prevent instantiation

  // ═══════════════════════════════════════════════════════════════════════════
  // ERROR DIALOGS - For critical errors requiring user acknowledgment
  // ═══════════════════════════════════════════════════════════════════════════

  /// Show error dialog with single dismiss button
  /// Use for: Login failures, validation errors, network errors
  static Future<void> showError({
    required String title,
    required String message,
    String dismissLabel = FinTexts.dialogDismiss,
    VoidCallback? onDismiss,
  }) async {
    return Get.dialog(
      _BaseDialog(
        icon: Icons.error_outline,
        iconColor: FinColors.error,
        title: title,
        message: message,
        actions: [
          _DialogButton(
            label: dismissLabel,
            onPressed: () {
              Get.back();
              onDismiss?.call();
            },
            isPrimary: true,
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  /// Show error dialog with retry action
  /// Use for: Network failures, API errors that can be retried
  static Future<bool> showErrorWithRetry({
    required String title,
    required String message,
    String retryLabel = FinTexts.dialogRetry,
    String cancelLabel = FinTexts.dialogCancel,
  }) async {
    final result = await Get.dialog<bool>(
      _BaseDialog(
        icon: Icons.error_outline,
        iconColor: FinColors.error,
        title: title,
        message: message,
        actions: [
          _DialogButton(
            label: cancelLabel,
            onPressed: () => Get.back(result: false),
            isPrimary: false,
          ),
          _DialogButton(
            label: retryLabel,
            onPressed: () => Get.back(result: true),
            isPrimary: true,
          ),
        ],
      ),
      barrierDismissible: false,
    );
    return result ?? false;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SUCCESS DIALOGS - For important successful operations
  // ═══════════════════════════════════════════════════════════════════════════

  /// Show success dialog
  /// Use for: Account creation, password changes, important updates
  static Future<void> showSuccess({
    required String title,
    required String message,
    String dismissLabel = FinTexts.dialogDismiss,
    VoidCallback? onDismiss,
  }) async {
    return Get.dialog(
      _BaseDialog(
        icon: Icons.check_circle_outline,
        iconColor: FinColors.success,
        title: title,
        message: message,
        actions: [
          _DialogButton(
            label: dismissLabel,
            onPressed: () {
              Get.back();
              onDismiss?.call();
            },
            isPrimary: true,
          ),
        ],
      ),
      barrierDismissible: true,
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // CONFIRMATION DIALOGS - For actions requiring user confirmation
  // ═══════════════════════════════════════════════════════════════════════════

  /// Show confirmation dialog with yes/no options
  /// Use for: Logout, delete account, destructive actions
  static Future<bool> showConfirmation({
    required String title,
    required String message,
    String confirmLabel = FinTexts.dialogConfirm,
    String cancelLabel = FinTexts.dialogCancel,
    bool isDestructive = false,
  }) async {
    final result = await Get.dialog<bool>(
      _BaseDialog(
        icon: isDestructive ? Icons.warning_outlined : Icons.help_outline,
        iconColor: isDestructive ? FinColors.warning : FinColors.info,
        title: title,
        message: message,
        actions: [
          _DialogButton(
            label: cancelLabel,
            onPressed: () => Get.back(result: false),
            isPrimary: false,
          ),
          _DialogButton(
            label: confirmLabel,
            onPressed: () => Get.back(result: true),
            isPrimary: true,
            isDestructive: isDestructive,
          ),
        ],
      ),
      barrierDismissible: true,
    );
    return result ?? false;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // INFO DIALOGS - For informational messages
  // ═══════════════════════════════════════════════════════════════════════════

  /// Show info dialog
  /// Use for: Feature explanations, tips, notices
  static Future<void> showInfo({
    required String title,
    required String message,
    String dismissLabel = FinTexts.dialogUnderstood,
    VoidCallback? onDismiss,
  }) async {
    return Get.dialog(
      _BaseDialog(
        icon: Icons.info_outline,
        iconColor: FinColors.info,
        title: title,
        message: message,
        actions: [
          _DialogButton(
            label: dismissLabel,
            onPressed: () {
              Get.back();
              onDismiss?.call();
            },
            isPrimary: true,
          ),
        ],
      ),
      barrierDismissible: true,
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // LOADING DIALOG - For blocking operations
  // ═══════════════════════════════════════════════════════════════════════════

  /// Show loading dialog (non-dismissible)
  /// Remember to call Get.back() when operation completes
  static void showLoading({String message = FinTexts.dialogLoadingMessage}) {
    Get.dialog(
      WillPopScope(
        onWillPop: () async => false,
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(FinSizes.defaultSpace),
            decoration: BoxDecoration(
              color: const Color(0xFF2D3245),
              borderRadius: BorderRadius.circular(FinSizes.borderRadiusLg),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(color: FinColors.primary),
                const SizedBox(height: FinSizes.spaceBtwItems),
                Text(
                  message,
                  style: const TextStyle(color: FinColors.white),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// PRIVATE WIDGETS - Internal dialog components
// ═══════════════════════════════════════════════════════════════════════════════

/// Base dialog widget with consistent styling
class _BaseDialog extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String message;
  final List<Widget> actions;

  const _BaseDialog({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.message,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF2D3245),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(FinSizes.borderRadiusLg),
      ),
      contentPadding: const EdgeInsets.all(FinSizes.defaultSpace),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon
          Icon(
            icon,
            size: 56,
            color: iconColor,
          ),
          const SizedBox(height: FinSizes.spaceBtwItems),

          // Title
          Text(
            title,
            style: const TextStyle(
              color: FinColors.white,
              fontSize: FinSizes.fontSizeLg,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: FinSizes.spaceBtwInputFields),

          // Message
          Text(
            message,
            style: TextStyle(
              color: FinColors.white.withOpacity(0.8),
              fontSize: FinSizes.fontSizeMd,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: FinSizes.spaceBtwSections),

          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: actions
                .expand((action) => [action, const SizedBox(width: FinSizes.spaceBtwInputFields)])
                .toList()
              ..removeLast(), // Remove last spacer
          ),
        ],
      ),
    );
  }
}

/// Dialog button with consistent styling
class _DialogButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isPrimary;
  final bool isDestructive;

  const _DialogButton({
    required this.label,
    required this.onPressed,
    this.isPrimary = false,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isDestructive
        ? FinColors.error
        : isPrimary
        ? FinColors.primary
        : Colors.transparent;

    final foregroundColor = isPrimary || isDestructive ? FinColors.white : FinColors.primary;

    final border = !isPrimary && !isDestructive
        ? BorderSide(color: FinColors.primary, width: 1)
        : BorderSide.none;

    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          padding: const EdgeInsets.symmetric(vertical: FinSizes.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(FinSizes.buttonRadius),
            side: border,
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: FinSizes.fontSizeMd,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}