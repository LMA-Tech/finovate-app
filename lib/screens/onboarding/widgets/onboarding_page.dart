import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lottie/lottie.dart';

import '../onboarding_controller.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({
    super.key,
    required this.lottiePath,
    required this.title,
    required this.subTitle,
  });

  final String lottiePath, title, subTitle;

  @override
  Widget build(BuildContext context) {
    final onboardingCon = Get.find<OnBoardingController>();
    return Padding(
      padding: const EdgeInsets.all(FinSizes.defaultSpace),
      child: Column(
        children: [
          Lottie.asset(
            lottiePath,
            controller: onboardingCon.animationController,
            width: FinHelperFunctions.screenWidth() * 0.8,
            //80% of screen width
            height: FinHelperFunctions.screenHeight() * 0.5,
            //50% of screen height
            fit: BoxFit.contain,
            onLoaded: (composition) {
              onboardingCon.playAnimation(composition.duration);
            },
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: FinSizes.spaceBtwItems),
          Text(
            subTitle,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }
}
