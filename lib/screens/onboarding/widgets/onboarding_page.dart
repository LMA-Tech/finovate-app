import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../onboarding_controller.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subTitle,
    required this.imageWidth,
    required this.imageHeight,
  });

  final String imagePath, title, subTitle;
  final double imageWidth, imageHeight;

  @override
  Widget build(BuildContext context) {
    final onboardingCon = Get.find<OnBoardingController>();
    return Padding(
      padding: const EdgeInsets.all(FinSizes.defaultSpace),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Centers content vertically
        crossAxisAlignment: CrossAxisAlignment.start, // Centers content horizontally
        children: [
          Image.asset(
            imagePath,
            width: imageWidth,
            height: imageHeight,
            fit: BoxFit.contain, // Ensure it scales proportionally
          ),
          const SizedBox(height: FinSizes.spaceBtwSections), // Spacing between image and title
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.left, // Left-align the title
          ),
          const SizedBox(height: FinSizes.spaceBtwSections), // Spacing between title and subtitle
          Text(
            subTitle,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.left, // Left-align the subtitle
          ),
          const SizedBox(height: FinSizes.spaceBtwSections),
        ],
      ),
    );
  }
}