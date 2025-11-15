import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_strings.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../signup_controller.dart';

/// Final Welcome Screen (Step 11 - After questionnaire completion)
/// Matches the format of SignupStep6 (success screen) exactly
/// Button calls submitQuestionnaire() directly to navigate to home
class SignupStepQuestionnaireFinal extends StatelessWidget {
  const SignupStepQuestionnaireFinal({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SignupController>();

    // Get user's first name for personalized welcome
    final firstName = controller.step2Form.control('firstName').value ?? 'usuário';

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
                    // Plane logo (using dark app logo like in your Figma)
                    SvgPicture.asset(
                      FinImages.darkAppLogo,
                      height: FinHelperFunctions.screenHeight() * 0.35,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: FinSizes.spaceBtwSections),

                    // Welcome title with user's name (matches Step 6 format)
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        FinTexts.questionnaireWelcomeTitle.replaceAll('{NAME}', firstName),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: FinSizes.fontSizeLg + 6, // 24px
                          fontWeight: FontWeight.w600,
                          height: 1.33,
                          letterSpacing: -0.48,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: FinSizes.spaceBtwItems),

                    // Welcome subtitle (matches Step 6 format)
                    const Text(
                      FinTexts.questionnaireWelcomeSubtitle,
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
                    // Final button - Calls submitQuestionnaire() directly
                    Obx(() => Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: controller.isLoading.value
                            ? null
                            : () => controller.submitQuestionnaire(),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 56, vertical: 12),
                          decoration: ShapeDecoration(
                            color: controller.isLoading.value
                                ? const Color(0xFF1B6FFF).withValues(alpha: 0.4)
                                : const Color(0xFF1B6FFF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Center(
                            child: controller.isLoading.value
                                ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                                : const Text(
                              FinTexts.signupFinalbutton, // "Finalizar Cadastro"
                              textAlign: TextAlign.center,
                              style: TextStyle(
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