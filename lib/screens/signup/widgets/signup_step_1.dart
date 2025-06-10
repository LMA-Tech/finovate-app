import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_strings.dart';
import '../../../common/widgets/custom_text_field.dart';
import '../signup_controller.dart';
import '../widgets/signup_continue_button.dart';
import 'disclaimers.dart';

class SignupStep1 extends StatelessWidget {
  const SignupStep1({super.key});

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
                  FinTexts.signupTitle,
                  style: TextStyle(
                    fontSize: FinSizes.fontSizeLg + 6, // 24px
                    fontWeight: FontWeight.w600,
                    height: 1.33,
                    letterSpacing: -0.48,
                  ),
                ),
                const SizedBox(height: FinSizes.spaceBtwSections),

                // Form Container

                Form(
                    key: controller.step1FormKey,
                    child: Column(
                      children: [
                        // Email Field
                        CustomTextField(
                          controller: controller.emailController,
                          validator: controller.validateEmail,
                          label: FinTexts.email,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: FinSizes.spaceBtwInputFields),

                        // Password Field
                        Obx(() => CustomTextField(
                              controller: controller.passwordController,
                              validator: controller.validatePassword,
                              label: FinTexts.password,
                              obscureText: controller.hidePassword.value,
                              textInputAction: TextInputAction.next,
                              suffixIcon: IconButton(
                                onPressed: controller.togglePassword,
                                icon: Icon(
                                  controller.hidePassword.value
                                      ? Iconsax.eye_slash
                                      : Iconsax.eye,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            )),
                        const SizedBox(height: FinSizes.spaceBtwInputFields),

                        // Confirm Password Field
                        Obx(() => CustomTextField(
                              controller: controller.confirmPasswordController,
                              validator: controller.validateConfirmPassword,
                              label: FinTexts.confirmPassword,
                              obscureText: controller.hidePassword.value,
                              textInputAction: TextInputAction.done,
                              suffixIcon: IconButton(
                                onPressed: controller.toggleConfirmPassword,
                                icon: Icon(
                                  controller.hideConfirmPassword.value
                                      ? Iconsax.eye_slash
                                      : Iconsax.eye,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            )),
                        const SizedBox(height: FinSizes.spaceBtwInputFields),

                        // Save Information Checkbox
                        Obx(() => Row(
                              children: [
                                SizedBox(
                                  width: 12,
                                  height: 12,
                                  child: Checkbox(
                                    value: controller.saveInfo.value,
                                    onChanged: controller.toggleSaveInfo,
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                          width: 1.20,
                                          color: FinColors.neutralGray),
                                      borderRadius: BorderRadius.circular(2.40),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  FinTexts.keepInfoSaved,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    height: 1.50,
                                    letterSpacing: -0.13,
                                  ),
                                ),
                              ],
                            )),
                        const SizedBox(height: FinSizes.spaceBtwSections),
                      ],
                    )),
                const Spacer(), // This will push disclaimer/button to bottom
                // Privacy disclaimer
                Obx(() => controller.currentStep.value == 0
                    ? const DisclaimerWidget(type: DisclaimerType.privacy)
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
