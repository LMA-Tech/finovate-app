import 'package:finovate_app/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../onboarding_controller.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/device/device_utility.dart';
import '../../../utils/helpers/helper_functions.dart';

class OnboardingNextButton extends StatelessWidget {
  const OnboardingNextButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = OnBoardingController.instance;
    // Dark mode check available for future styling
    // ignore: unused_local_variable
    final bool _ = FinHelperFunctions.isDarkMode(context);

    return Obx(() {
      final isLastPage = controller.currentPageIndex.value == OnBoardingController.pageCount - 1;

      if (isLastPage) {
        // Figma-style "Get Started" button for the last page
        return Positioned(
          left: FinSizes.defaultSpace,
          right: FinSizes.defaultSpace,
          bottom: FinDeviceUtils.getBottomNavigationBarHeight() + 8,
          child: Container(
            width: 342,
            height: 56,
            decoration: ShapeDecoration(
              color: FinColors.primary, // brand-primary-main
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: TextButton(
              onPressed: () => controller.nextPage(),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 56, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                FinTexts.continueText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white, // Neutral-gray-00
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  height: 1.50,
                  letterSpacing: -0.32,
                ),
              ),
            ),
          ),
        );
      } else {
        // Arrow button for other pages
        return Positioned(
          right: FinSizes.defaultSpace,
          bottom: FinDeviceUtils.getBottomNavigationBarHeight() + 8,
          child: ElevatedButton(
            onPressed: () => controller.nextPage(),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(FinSizes.borderRadiusLg),
              ),
              backgroundColor: FinColors.primary,
              padding: const EdgeInsets.all(FinSizes.md),
              minimumSize: const Size(24, 24),
              elevation: 0,
            ),
            child: const Icon(
              Icons.arrow_forward,
              color: Colors.white,
              size: 24,
            ),
          ),
        );
      }
    });
  }
}