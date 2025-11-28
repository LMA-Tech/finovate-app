import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_strings.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../signup_controller.dart';

/// Final Welcome Screen (Step 11 - After questionnaire completion)
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    FinImages.tealStripWhite,
                    height: FinHelperFunctions.screenHeight() * 0.15,
                    fit: BoxFit.contain,
                  ),
                ],
              ),

              const SizedBox(height: FinSizes.spaceBtwSections),

              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(flex: 1),
                    // Title
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        FinTexts.questionnaireWelcomeTitle.replaceAll('{NAME}', firstName),
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          fontSize: FinSizes.fontSizeXXLg,
                          fontWeight: FontWeight.w600,
                          height: 1.67,
                          letterSpacing: -0.48,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: FinSizes.spaceBtwItems),

                    // Subtitle
                    const Text(
                      FinTexts.questionnaireWelcomeSubtitle,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Color(0xFFDFDFE0), // Neutral-gray-200
                        fontSize: FinSizes.fontSizeMd,
                        fontWeight: FontWeight.w400,
                        height: 1.50,
                        letterSpacing: -0.32,
                      ),
                    ),
                  ],
                ),
              ),

              // Button
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Final button - Calls submitQuestionnaire() with loading state
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
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                                : const Text(
                              FinTexts.questionnaireWelcomeButton,
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