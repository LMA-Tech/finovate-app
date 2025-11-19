import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_strings.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../signup_controller.dart';
import 'signup_continue_button.dart';

/// Step 7: Questionnaire Introduction
class SignupStep7 extends StatelessWidget {
  const SignupStep7({super.key});

  @override
  Widget build(BuildContext context) {

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
              // Small logo at the top
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

              // Flexible content section
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Questionnaire intro image (ONLY CHANGE FROM STEP 6)
                    SvgPicture.asset(
                      FinImages.questionnaireStart,
                      height: FinHelperFunctions.screenHeight() * 0.35,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: FinSizes.spaceBtwSections),

                    // Title
                    const SizedBox(
                      width: double.infinity,
                      child: Text(
                        FinTexts.questionnaireIntroTitle,
                        style: TextStyle(
                          fontSize: FinSizes.fontSizeXXLg,
                          fontWeight: FontWeight.w600,
                          height: 1.33,
                          letterSpacing: -0.48,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    const SizedBox(height: FinSizes.spaceBtwItems),

                    // Subtitle
                    const Text(
                      FinTexts.questionnaireIntroSubtitle,
                      style: TextStyle(
                        color: Color(0xFFDFDFE0),
                        fontSize: FinSizes.fontSizeLg,
                        fontWeight: FontWeight.w400,
                        height: 1.50,
                        letterSpacing: -0.32,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: FinSizes.spaceBtwItems),

              // Reusable button (no arrow)
              Column(
                children: [
                  const SignupContinueButton(showArrow: false),
                  const SizedBox(height: FinSizes.spaceBtwSections),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}