import 'package:finovate_app/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import '../../common/styles/dark_mode_bg.dart';
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
    final onboardingCon = Get.put(OnBoardingController());

    return Scaffold(
        body: Stack(
        children: [
        /// If dark mode, apply background theme
        const FinDarkBg(),

        /// Horizontal Scrollable Pages
        PageView(
          controller: onboardingCon.pageController,
          onPageChanged: (index) {
            /// Trigger the animation for the new page
            OnBoardingController.instance.updatePageIndicator(
              index,
              const Duration(seconds: 5), // Adjust the full animation duration
            );
          },
          children: [
            OnBoardingPage(
                imagePath: FinImages.onboardingImage1,
                title: FinTexts.onboardingTitle1,
                subTitle: FinTexts.onboardingSubTitle1,
                imageWidth: FinHelperFunctions.screenHeight() * 0.8,
                imageHeight: FinHelperFunctions.screenHeight()* 0.4,
            ),
            OnBoardingPage(
                imagePath: FinImages.onboardingImage2,
                title: FinTexts.onboardingTitle2,
                subTitle: FinTexts.onboardingSubTitle2,
                imageWidth: FinHelperFunctions.screenHeight() * 0.9,
                imageHeight: FinHelperFunctions.screenHeight() * 0.4,
            ),
            OnBoardingPage(
                imagePath: FinImages.onboardingImage3,
                title: FinTexts.onboardingTitle3,
                subTitle: FinTexts.onboardingSubTitle3,
                imageWidth: FinHelperFunctions.screenHeight() * 0.8,
                imageHeight: FinHelperFunctions.screenHeight()* 0.4,
            ),
          ],
        ),

        /// Skip Button
        const OnboardingSkip(),

        /// Dot Navigation SmoothPageIndicator
        const OnboardingDotNavigation(),

        /// Circular Button
        const OnboardingNextButton(),
      ],
    ));
  }
}
