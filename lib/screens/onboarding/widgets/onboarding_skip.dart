import 'package:finovate_app/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../onboarding_controller.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/device/device_utility.dart';
import '../../../utils/helpers/helper_functions.dart';

class OnboardingSkip extends StatelessWidget {
  const OnboardingSkip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = OnBoardingController.instance;
    final dark = FinHelperFunctions.isDarkMode(context);

    // Don't show skip button on the last page
    return Obx(() {
      final isLastPage = controller.currentPageIndex.value == OnBoardingController.pageCount - 1;

      if (isLastPage) {
        return const SizedBox.shrink(); // Hide the button on the last page
      }

      return Positioned(
        bottom: FinDeviceUtils.getBottomNavigationBarHeight() + 8,
        left: FinSizes.defaultSpace,
        child: OutlinedButton(
          onPressed: () => controller.skipPage(),
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            side: BorderSide(
              color: dark ? FinColors.light.withOpacity(0.5) : FinColors.dark.withOpacity(0.5),
              width: 1.0,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            backgroundColor: Colors.transparent,
          ),
          child: const Text(
            FinTexts.skip,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white /* Neutral-gray-00 */,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              height: 1.40,
              letterSpacing: -0.32,
            ),
          ),
        ),
      );
    });
  }
}