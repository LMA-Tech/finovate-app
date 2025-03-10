import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../onboarding_controller.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/device/device_utility.dart';
import '../../../utils/helpers/helper_functions.dart';

class OnboardingDotNavigation extends StatelessWidget {
  const OnboardingDotNavigation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final onboardingCon = OnBoardingController.instance;
    final dark = FinHelperFunctions.isDarkMode(context);

    // Variables
    const barWidth = 108.0;
    const barHeight = 6.0;
    const spacing = 17.0;
    const totalBars = 3;
    const barRadius = 6.0;

    return Positioned(
      top: FinDeviceUtils.getAppBarHeight(),
      left: 0, // Ensure full-width container
      right: 0,
      child: Align(
        alignment: Alignment.center, // Center the indicator horizontally
        child: SmoothPageIndicator(
          count: totalBars,
          controller: onboardingCon.pageController,
          onDotClicked: onboardingCon.dotNavigationClick,
          effect: CustomizableEffect(
            activeDotDecoration: DotDecoration(
              width: barWidth,
              height: barHeight,
              color: dark ? FinColors.primary : FinColors.dark, // Active bar color
              borderRadius: BorderRadius.circular(barRadius),
            ),
            dotDecoration: DotDecoration(
              width: barWidth,
              height: barHeight,
              color: (dark ? FinColors.accent : FinColors.dark), // Inactive bar color
              borderRadius: BorderRadius.circular(barRadius),
            ),
            spacing: spacing,
          ),
        ),
      ),
    );
  }
}
