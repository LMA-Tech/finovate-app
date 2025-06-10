import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../signup_controller.dart';

class SignupContinueButton extends StatelessWidget {
  const SignupContinueButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SignupController>();

    return Obx(() {
      return Container(
        width: double.infinity,
        height: 48,
        decoration: ShapeDecoration(
          color: controller.getButtonColor(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              if (controller.getButtonAction() != null) {
                controller.nextStep();
              }
            },
            borderRadius: BorderRadius.circular(6),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (controller.isLoading.value)
                    const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  else ...[
                    Text(
                      controller.getButtonText(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFFEFEFF0),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        height: 1.50,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.arrow_forward,
                      color: Color(0xFFEFEFF0),
                      size: 24,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}