import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_strings.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../signup_controller.dart';

/// Questionnaire Introduction Screen (Step 6)
/// Matches the format of SignupStep6 (success screen) exactly
class SignupStepQuestionnaireIntro extends StatelessWidget {
  const SignupStepQuestionnaireIntro({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SignupController>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            top: FinSizes.sm,
            left: FinSizes.defaultSpace,
            right: FinSizes.defaultSpace,
            bottom: FinSizes.defaultSpace,
          ),
          child: Column(
            children: [
              // Small logo at the top (matches Step 6)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    FinImages.tealStripWhite,
                    width: 40,
                    height: 40,
                    fit: BoxFit.contain,
                  ),
                ],
              ),

              const SizedBox(height: FinSizes.spaceBtwItems),

              // Flexible content section (matches Step 6)
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Trophy illustration (same as success screen)
                    SvgPicture.asset(
                      FinImages.trophySuccess,
                      height: FinHelperFunctions.screenHeight() * 0.35,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: FinSizes.spaceBtwSections),

                    // Title (matches Step 6 format)
                    const SizedBox(
                      width: double.infinity,
                      child: Text(
                        FinTexts.questionnaireIntroTitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: FinSizes.fontSizeLg + 6, // 24px
                          fontWeight: FontWeight.w600,
                          height: 1.33,
                          letterSpacing: -0.48,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: FinSizes.spaceBtwItems),

                    // Subtitle (matches Step 6 format)
                    const Text(
                      FinTexts.questionnaireIntroSubtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFDFDFE0), // Neutral-gray-200
                        fontSize: FinSizes.fontSizeMd,
                        fontWeight: FontWeight.w400,
                        height: 1.50,
                        letterSpacing: -0.16,
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom button section (matches Step 6)
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Button (matches Step 6 format)
                    Obx(() => Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: controller.getButtonAction(),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 56, vertical: 12),
                          decoration: ShapeDecoration(
                            color: controller.getButtonColor(),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              controller.getButtonText(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                height: 1.50,
                                letterSpacing: -0.32,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )),

                    const SizedBox(height: FinSizes.spaceBtwSections),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}