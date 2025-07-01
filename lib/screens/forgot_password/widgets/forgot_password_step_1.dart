import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../common/widgets/custom_text_field.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_strings.dart';
import '../forgot_password_controller.dart';
import 'forgot_password_button.dart';

class ForgotPasswordStep1 extends StatelessWidget {
  const ForgotPasswordStep1({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ForgotPasswordController>();

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
                  FinTexts.forgotPasswordTitle,
                  style: TextStyle(
                    fontSize: FinSizes.fontSizeLg + 6, // 24px
                    fontWeight: FontWeight.w600,
                    height: 1.33,
                    letterSpacing: -0.48,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: FinSizes.sm),

                // Subtitle
                const Text(
                  FinTexts.forgotPasswordSubtitle,
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
                  formGroup: controller.step1Form,
                  child: Column(
                    children: [
                      // Email Field
                      CustomTextFieldReactive(
                        formControlName: 'email',
                        label: FinTexts.email,
                        hintText: FinTexts.emailHint,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        validationMessages: {
                          ValidationMessage.required: (_) =>
                          FinTexts.loginValidationEmailRequired,
                          ValidationMessage.email: (_) =>
                          FinTexts.loginValidationEmailInvalid,
                        },
                      ),
                      const SizedBox(height: FinSizes.spaceBtwSections),
                    ],
                  ),
                ),

                // Spacer to push button to bottom
                const Spacer(),

                // Continue Button
                const ForgotPasswordButton(buttonText: FinTexts.resetPassword),

                // Bottom padding for safe area
                const SizedBox(height: FinSizes.spaceBtwSections),
              ],
            ),
          ),
        ),
      ),
    );
  }
}