import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_strings.dart';
import '../signup_controller.dart';

class SignupContinueButton extends StatelessWidget {
  const SignupContinueButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SignupController>();

    return Padding(
      padding: const EdgeInsets.all(FinSizes.defaultSpace),
      child: Column(
        children: [
          // Privacy text for step 1 only
          Obx(() => controller.currentStep.value == 0
              ? Padding(
            padding: const EdgeInsets.only(bottom: FinSizes.md),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: FinTexts.privacyAgreement,
                    style: TextStyle(
                      fontSize: FinSizes.fontSizeSm,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  TextSpan(
                    text: FinTexts.privacyPolicy,
                    style: TextStyle(
                      fontSize: FinSizes.fontSizeSm,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  TextSpan(
                    text: ' ${FinTexts.and} ',
                    style: TextStyle(
                      fontSize: FinSizes.fontSizeSm,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  TextSpan(
                    text: FinTexts.termsOfUse,
                    style: TextStyle(
                      fontSize: FinSizes.fontSizeSm,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  TextSpan(
                    text: ' da Finovate.',
                    style: TextStyle(
                      fontSize: FinSizes.fontSizeSm,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          )
              : const SizedBox.shrink()),

          // Continue button
          Obx(() {
            print('DEBUG: Button rebuild - canProceed: ${controller.canProceedReactive.value}, step: ${controller.currentStep.value}');
            return Container(
              width: double.infinity,
              height: 48,
              decoration: ShapeDecoration(
                color: controller.getButtonColor(),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    print('DEBUG: Button tapped! canProceed: ${controller.canProceedReactive.value}');
                    if (controller.getButtonAction() != null) {
                      print('DEBUG: Calling nextStep()');
                      controller.nextStep();
                    } else {
                      print('DEBUG: Button action is null - button disabled');
                    }
                  },
                  borderRadius: BorderRadius.circular(6),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (controller.isLoading.value)
                          const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        else ...[
                          Text(
                            controller.getButtonText(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFFEFEFF0),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              height: 1.50,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.arrow_forward,
                            color: Color(0xFFEFEFF0),
                            size: 24,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}