import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/widgets/custom_selection_field.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_strings.dart';
import '../signup_controller.dart';
import 'disclaimers.dart';
import 'signup_continue_button.dart';

class SignupVerificationMethod extends StatelessWidget {
  const SignupVerificationMethod({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SignupController>();

    return Padding(
      padding: const EdgeInsets.all(FinSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          const Text(
            FinTexts.signupTitle3,
            style: TextStyle(
              fontSize: FinSizes.fontSizeLg + 6, // 24px
              fontWeight: FontWeight.w600,
              height: 1.33,
              letterSpacing: -0.48,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: FinSizes.spaceBtwSections),

          // Verification options
          Column(
            children: [
              // Email option
              Obx(() => CustomSelectionField(
                label: '',
                title: 'E-mail',
                isSelected: controller.selectedVerificationMethod.value == VerificationMethod.email,
                isEnabled: true,
                onTap: () => controller.selectVerificationMethod(VerificationMethod.email),
              )),
              const SizedBox(height: FinSizes.defaultSpace),

              // SMS option (disabled temporarily)
              Obx(() => CustomSelectionField(
                label: '',
                title: 'SMS (Em breve)',
                isSelected: controller.selectedVerificationMethod.value == VerificationMethod.sms,
                isEnabled: false,
                onTap: () {},
              )),
            ],
          ),
          const SizedBox(height: FinSizes.spaceBtwSections),

          // Verification disclaimer
          Obx(() => controller.currentStep.value == 3
              ? const DisclaimerWidget(type: DisclaimerType.verification)
              : const SizedBox.shrink()),

          // Spacer to push button to bottom
          const Spacer(),

          // Reusable button - calls controller.nextStep() which triggers signUp()
          const SignupContinueButton(showArrow: true),

          // Bottom padding for safe area
          const SizedBox(height: FinSizes.spaceBtwSections),
        ],
      ),
    );
  }
}