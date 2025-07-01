import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/constants/colors.dart';
import '../forgot_password_controller.dart';

class ForgotPasswordButton extends StatelessWidget {
  final String buttonText;

  const ForgotPasswordButton({
    super.key,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ForgotPasswordController>();

    return Obx(() => Container(
      width: double.infinity,
      height: 48,
      decoration: ShapeDecoration(
        color: controller.canProceedReactive.value && !controller.isLoading.value
            ? FinColors.primary
            : FinColors.primary.withOpacity(0.4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: controller.canProceedReactive.value && !controller.isLoading.value
              ? () => controller.nextStep()
              : null,
          borderRadius: BorderRadius.circular(6),
          child: Center(
            child: controller.isLoading.value
                ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
                : Text(
              buttonText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                height: 1.50,
              ),
            ),
          ),
        ),
      ),
    ));
  }
}