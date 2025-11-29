import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../common/widgets/custom_text_field.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_strings.dart';
import '../signup_controller.dart';
import '../widgets/signup_continue_button.dart';
import 'disclaimers.dart';

class SignupFormName extends StatelessWidget {
  const SignupFormName({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SignupController>();

    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top -
              kToolbarHeight, // Account for status bar and app bar
        ),
        child: IntrinsicHeight(
          child: Padding(
            padding: const EdgeInsets.all(FinSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                const Text(
                  FinTexts.signupTitle2,
                  style: TextStyle(
                    fontSize: FinSizes.fontSizeLg + 6, // 24px
                    fontWeight: FontWeight.w600,
                    height: 1.33,
                    letterSpacing: -0.48,
                  ),
                ),
                const SizedBox(height: FinSizes.sm),

                // Subtitle
                const Text(
                  FinTexts.signupSubtitle2,
                  style: TextStyle(
                    color: Color(0xFFDFDFE0), // Neutral-gray-200
                    fontSize: FinSizes.fontSizeMd,
                    fontWeight: FontWeight.w400,
                    height: 1.50,
                    letterSpacing: -0.16,
                  ),
                ),
                const SizedBox(height: FinSizes.spaceBtwSections),

                // Form section - wrapped with ReactiveForm for automatic validation
                ReactiveForm(
                    formGroup: controller.step2Form,
                    child: Column(
                      children: [
                        // First Name Field
                        CustomTextFieldReactive(
                          formControlName: 'firstName',
                          label: FinTexts.firstName,
                          hintText: 'Maria',
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          validationMessages: {
                            ValidationMessage.required: (_) =>
                            FinTexts.signupValidationFirstNameRequired,
                            ValidationMessage.minLength: (_) =>
                            FinTexts.signupValidationFirstNameMinLength,
                          },
                        ),
                        const SizedBox(height: FinSizes.spaceBtwInputFields),

                        // Last Name Field
                        CustomTextFieldReactive(
                          formControlName: 'lastName',
                          label: FinTexts.lastName,
                          hintText: 'Clara',
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.done,
                          validationMessages: {
                            ValidationMessage.required: (_) =>
                            FinTexts.signupValidationLastNameRequired,
                            ValidationMessage.minLength: (_) =>
                            FinTexts.signupValidationLastNameMinLength,
                          },
                        ),
                        const SizedBox(height: FinSizes.spaceBtwSections),
                      ],
                    )),

                // Identity document disclaimer
                Obx(() => controller.currentStep.value == 1
                    ? const DisclaimerWidget(type: DisclaimerType.identityDocument)
                    : const SizedBox.shrink()),

                const SizedBox(height: FinSizes.spaceBtwInputFields),

                // Button inside the scrollable area
                const SignupContinueButton(),

                // Extra bottom padding for keyboard space
                const SizedBox(height: FinSizes.spaceBtwSections),
              ],
            ),
          ),
        ),
      ),
    );
  }
}