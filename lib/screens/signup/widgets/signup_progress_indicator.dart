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
        children: List.generate(SignupController.totalProgressLevels, (index) { // Use totalProgressLevels
          final isActive = index <= controller.progressLevel; // Use progressLevel getter

          return Expanded(
            child: Container(
              height: 6,
              margin: EdgeInsets.only(
                right: index < SignupController.totalProgressLevels - 1 ? 8 : 0, // Use totalProgressLevels
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: isActive
                    ? FinColors.primary
                    : FinColors.accent.withValues(alpha: 0.3),
              ),
            ),
          );
        }),
      )),
    );
  }
}