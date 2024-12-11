import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
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

    return Positioned(
      bottom: FinDeviceUtils.getBottomNavigationBarHeight() + 25,
      left: FinSizes.defaultSpace,
      child: SmoothPageIndicator(
        count: 3,
        controller:  onboardingCon.pageController,
        onDotClicked: onboardingCon.dotNavigationClick,
        effect: ExpandingDotsEffect(
            activeDotColor: dark ? FinColors.light : FinColors.dark,
            dotHeight: 6),
      ),
    );
  }
}