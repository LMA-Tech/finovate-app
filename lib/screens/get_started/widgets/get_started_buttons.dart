import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/constants/text_strings.dart';
import '../get_started_controller.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';

class GetStartedButtons extends StatelessWidget {
  const GetStartedButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GetStartedController>();

    return Row(
      children: [
        // Login button
        Expanded(
          child: OutlinedButton(
            onPressed: controller.navigateToLogin,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: FinColors.white),
              padding: const EdgeInsets.symmetric(vertical: FinSizes.buttonHeight),
            ),
            child: const Text(FinTexts.signIn),
          ),
        ),

        const SizedBox(width: FinSizes.spaceBtwItems),

        // Register button
        Expanded(
          child: ElevatedButton(
            onPressed: controller.navigateToSignup,
            style: ElevatedButton.styleFrom(
              backgroundColor: FinColors.primary,
              padding: const EdgeInsets.symmetric(vertical: FinSizes.buttonHeight),
            ),
            child: const Text(FinTexts.createAccount),
          ),
        ),
      ],
    );
  }
}