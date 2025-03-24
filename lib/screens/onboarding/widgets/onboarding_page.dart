import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/theme/widget_themes/text_theme.dart';
import '../onboarding_controller.dart';
import '../../../utils/constants/sizes.dart';

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
    return Padding(
      padding: const EdgeInsets.all(FinSizes.defaultSpace),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // Centers content vertically
        crossAxisAlignment: CrossAxisAlignment.start,
        // Centers content horizontally
        children: [
          Image.asset(
            imagePath,
            width: imageWidth,
            height: imageHeight,
            fit: BoxFit.contain, // Ensure it scales proportionally
          ),
          const SizedBox(height: FinSizes.spaceBtwSections),
          // Spacing between image and title
          Text(
            title,
            style: const TextStyle(
              color: Colors.white /* Neutral-gray-00 */,
              fontSize: 30,
              fontWeight: FontWeight.w500,
              height: 1.33,
              letterSpacing: -0.60,
            ),
            textAlign: TextAlign.left, // Left-align the title
          ),
          const SizedBox(height: FinSizes.spaceBtwSections),
          // Spacing between title and subtitle
          Text(
            subTitle,
            style: const TextStyle(
              color: Colors.white /* Neutral-gray-00 */,
              fontSize: 16,
              fontWeight: FontWeight.w400,
              height: 1.50,
              letterSpacing: -0.32,
            ),
            textAlign: TextAlign.left, // Left-align the subtitle
          ),
          const SizedBox(height: FinSizes.spaceBtwSections),
        ],
      ),
    );
  }
}
