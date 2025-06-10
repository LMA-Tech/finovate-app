import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../signup_controller.dart';

class SignupProgressIndicator extends StatelessWidget {
  const SignupProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SignupController>();

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: FinSizes.defaultSpace,
        vertical: FinSizes.md,
      ),
      child: Obx(() => Row(
        children: List.generate(SignupController.totalSteps, (index) {
          final isActive = index <= controller.currentStep.value;
          final isCompleted = index < controller.currentStep.value;

          return Expanded(
            child: Container(
              height: 6,
              margin: EdgeInsets.only(
                right: index < SignupController.totalSteps - 1 ? 8 : 0,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: isActive
                    ? FinColors.primary
                    : FinColors.accent.withOpacity(0.3),
              ),
            ),
          );
        }),
      )),
    );
  }
}