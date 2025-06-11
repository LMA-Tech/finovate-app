import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/widgets/custom_selection_field.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_strings.dart';
import '../signup_controller.dart';
import 'disclaimers.dart';

class SignupStep4 extends StatelessWidget {
  const SignupStep4({super.key});

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
                label: '', // No label since we have the title above
                title: 'E-mail',
                isSelected: controller.selectedVerificationMethod.value == VerificationMethod.email,
                isEnabled: true,
                onTap: () => controller.selectVerificationMethod(VerificationMethod.email),
              )),
              const SizedBox(height: FinSizes.defaultSpace),

              // SMS option (disabled)
              Obx(() => CustomSelectionField(
                label: '', // No label since we have the title above
                title: 'SMS',
                isSelected: controller.selectedVerificationMethod.value == VerificationMethod.sms,
                isEnabled: false, // Disabled as per requirement
                onTap: () {}, // No action for SMS
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

          // Send verification button
          Obx(() => Container(
            width: double.infinity,
            height: 48,
            decoration: ShapeDecoration(
              color: controller.canSendVerification()
                  ? const Color(0xFF1B6FFF)
                  : const Color(0xFF1B6FFF).withOpacity(0.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: controller.canSendVerification() && !controller.isLoading.value
                    ? () => controller.signUp()
                    : null,
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
                        const Text(
                          'Enviar código',
                          textAlign: TextAlign.center,
                          style: TextStyle(
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
          )),

          // Bottom padding for safe area
          const SizedBox(height: FinSizes.spaceBtwSections),
        ],
      ),
    );
  }
}