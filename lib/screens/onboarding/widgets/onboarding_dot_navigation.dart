import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../onboarding_controller.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/device/device_utility.dart';
import '../../../utils/helpers/helper_functions.dart';

class OnboardingDotNavigation extends StatelessWidget {
  const OnboardingDotNavigation({
    super.key,
  });

  // Constants
  static const double barWidth = 108.0;
  static const double barHeight = 6.0;
  static const double spacing = 17.0;
  static const int totalBars = 3;
  static const double barRadius = 6.0;

  @override
  Widget build(BuildContext context) {
    final onboardingCon = OnBoardingController.instance;
    // Dark mode check available for future styling
    // ignore: unused_local_variable
    final _ = FinHelperFunctions.isDarkMode(context);

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
              color: FinColors.primary, // Active bar color
              borderRadius: BorderRadius.circular(barRadius),
            ),
            dotDecoration: DotDecoration(
              width: barWidth,
              height: barHeight,
              color: FinColors.accent.withValues(alpha: 0.6), // Inactive bar color
              borderRadius: BorderRadius.circular(barRadius),
            ),
            spacing: spacing,
          ),
        ),
      ),
    );
  }
}
