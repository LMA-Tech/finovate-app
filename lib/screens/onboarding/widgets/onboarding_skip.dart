import 'package:flutter/material.dart';

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
    final dark = FinHelperFunctions.isDarkMode(context);
    return Positioned(
      bottom: FinDeviceUtils.getBottomNavigationBarHeight() + 8,
      left: FinSizes.defaultSpace,
      child: TextButton(
        onPressed: () => OnBoardingController.instance.skipPage(),
        child: Text(
          'Pular',
          style: TextStyle(
              color: dark ? FinColors.light : FinColors.dark,
              fontSize: FinSizes.fontSizeMd,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
