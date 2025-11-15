import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/constants/colors.dart';
import '../signup_controller.dart';

/// Reusable signup button that works for ALL steps
///
/// Two variants:
/// 1. With arrow (for form steps 1-4)
/// 2. Without arrow (for success/intro screens 5-7)
class SignupContinueButton extends StatelessWidget {
  /// Whether to show the arrow icon (default: true for form steps)
  final bool showArrow;

  /// Optional custom text (overrides controller.getButtonText())
  final String? customText;

  /// Optional custom onTap (overrides controller.nextStep())
  final VoidCallback? customOnTap;

  const SignupContinueButton({
    super.key,
    this.showArrow = true,
    this.customText,
    this.customOnTap,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SignupController>();

    return Obx(() {
      final isLoading = controller.isLoading.value;
      final buttonColor = customOnTap != null
          ? FinColors.primary // Always enabled for custom actions
          : controller.getButtonColor();

      return Container(
        width: double.infinity,
        height: 56, // Consistent height for all buttons
        decoration: ShapeDecoration(
          color: buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isLoading
                ? null
                : (customOnTap ?? controller.getButtonAction()),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Center(
                child: isLoading
                    ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                    : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      customText ?? controller.getButtonText(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        height: 1.50,
                        letterSpacing: -0.32,
                      ),
                    ),
                    if (showArrow) ...[
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 24,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}