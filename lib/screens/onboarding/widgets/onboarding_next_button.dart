import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../onboarding_controller.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/device/device_utility.dart';
import '../../../utils/helpers/helper_functions.dart';

class OnboardingNextButton extends StatelessWidget {
  const OnboardingNextButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = FinHelperFunctions.isDarkMode(context);
    return Positioned(
      right: FinSizes.defaultSpace,
      bottom: FinDeviceUtils.getBottomNavigationBarHeight() + 8,
      child: ElevatedButton(
        onPressed: () => OnBoardingController.instance.nextPage(
          const Duration(seconds: 5), // Full duration for the next animation
        ),
        style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            backgroundColor: dark ? FinColors.white : Colors.black),
        child: Icon(
          Iconsax.arrow_right_3,
          color: dark ? FinColors.black : Colors.white, // Set the icon color to black
        ),
      ),
    );
  }
}
