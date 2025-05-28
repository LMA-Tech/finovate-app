import 'package:finovate_app/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'onboarding_controller.dart';
import 'package:get/get.dart';
import 'package:finovate_app/screens/onboarding/widgets/onboarding_dot_navigation.dart';
import 'package:finovate_app/screens/onboarding/widgets/onboarding_next_button.dart';
import 'package:finovate_app/utils/constants/image_strings.dart';
import 'package:finovate_app/utils/constants/text_strings.dart';

import 'widgets/onboarding_page.dart';
import 'widgets/onboarding_skip.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller using GetX
    final controller = Get.put(OnBoardingController());

    // Calculate responsive image dimensions
    final double screenHeight = FinHelperFunctions.screenHeight();
    final double imageHeight = screenHeight * 0.4;
    final double imageWidth = screenHeight * 0.8;

    return Scaffold(
        body: Stack(
          children: [
            // Page content
            PageView(
              controller: controller.pageController,
              onPageChanged: controller.updatePageIndicator,
              children: [
                OnBoardingPage(
                  imagePath: FinImages.onboardingImage1,
                  title: FinTexts.onboardingTitle1,
                  subTitle: FinTexts.onboardingSubTitle1,
                  imageWidth: imageWidth,
                  imageHeight: imageHeight,
                ),
                OnBoardingPage(
                  imagePath: FinImages.onboardingImage2,
                  title: FinTexts.onboardingTitle2,
                  subTitle: FinTexts.onboardingSubTitle2,
                  imageWidth: imageWidth * 1.1, // Slightly wider image
                  imageHeight: imageHeight,
                ),
                OnBoardingPage(
                  imagePath: FinImages.onboardingImage3,
                  title: FinTexts.onboardingTitle3,
                  subTitle: FinTexts.onboardingSubTitle3,
                  imageWidth: imageWidth,
                  imageHeight: imageHeight,
                ),
              ],
            ),

            // Navigation controls
            const OnboardingSkip(),
            const OnboardingDotNavigation(),
            const OnboardingNextButton(),
          ],
        )
    );
  }
}