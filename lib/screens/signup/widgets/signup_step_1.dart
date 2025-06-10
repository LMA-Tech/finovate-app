import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_strings.dart';
import '../../../common/widgets/custom_text_field.dart';
import '../signup_controller.dart';
import '../widgets/signup_continue_button.dart';

class SignupStep1 extends StatelessWidget {
  const SignupStep1({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SignupController>();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(FinSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              FinTexts.signupTitle,
              style: TextStyle(
                fontSize: FinSizes.fontSizeLg + 6, // 24px
                fontWeight: FontWeight.w600,
                height: 1.33,
                letterSpacing: -0.48,
              ),
            ),
            const SizedBox(height: FinSizes.spaceBtwSections),

            // Form Container - matches Figma structure
            Form(
              key: controller.step1FormKey,
              child: Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Form Fields Container
                    Container(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Email Field
                          FinCustomTextField(
                            label: FinTexts.email,
                            controller: controller.emailController,
                            validator: controller.validateEmail,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: FinSizes.md),

                          // Password Field
                          Obx(() => FinCustomTextField(
                            label: FinTexts.password,
                            controller: controller.passwordController,
                            validator: controller.validatePassword,
                            obscureText: controller.hidePassword.value,
                            textInputAction: TextInputAction.next,
                            suffixIcon: IconButton(
                              onPressed: controller.togglePassword,
                              icon: Icon(
                                controller.hidePassword.value
                                    ? Iconsax.eye_slash
                                    : Iconsax.eye,
                                color: const Color(0xFFE3EBFF),
                                size: FinSizes.iconSm,
                              ),
                            ),
                          )),
                          const SizedBox(height: FinSizes.md),

                          // Confirm Password Field
                          Obx(() => FinCustomTextField(
                            label: 'Confirmar senha', // Add this to FinTexts if you want
                            controller: controller.confirmPasswordController,
                            validator: controller.validateConfirmPassword,
                            obscureText: controller.hideConfirmPassword.value,
                            textInputAction: TextInputAction.done,
                            suffixIcon: IconButton(
                              onPressed: controller.toggleConfirmPassword,
                              icon: Icon(
                                controller.hideConfirmPassword.value
                                    ? Iconsax.eye_slash
                                    : Iconsax.eye,
                                color: const Color(0xFFE3EBFF),
                                size: FinSizes.iconSm,
                              ),
                            ),
                          )),
                        ],
                      ),
                    ),
                    const SizedBox(height: FinSizes.xs),

                    // Checkbox Section - matches Figma exactly
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Save Info Checkbox
                          Obx(() => Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: ShapeDecoration(
                                  color: controller.saveInfo.value
                                      ? FinColors.primary
                                      : Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      width: 1.2,
                                      color: controller.saveInfo.value
                                          ? FinColors.primary
                                          : const Color(0xFFEFEFF0),
                                    ),
                                    borderRadius: BorderRadius.circular(2.4),
                                  ),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () => controller.toggleSaveInfo(!controller.saveInfo.value),
                                    borderRadius: BorderRadius.circular(2.4),
                                    child: controller.saveInfo.value
                                        ? const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 8,
                                    )
                                        : null,
                                  ),
                                ),
                              ),
                              const SizedBox(width: FinSizes.xs / 2), // 6px spacing
                              const Text(
                                'Manter informações salvas',
                                style: TextStyle(
                                  color: Color(0xFFEFEFF0),
                                  fontSize: FinSizes.fontSizeSm - 1, // 13px
                                  fontWeight: FontWeight.w500,
                                  height: 1.50,
                                  letterSpacing: -0.13,
                                ),
                              ),
                            ],
                          )),

                          // Invisible "Forgot password" for spacing
                          const Opacity(
                            opacity: 0,
                            child: Text(
                              'Esqueci minha senha',
                              style: TextStyle(
                                color: Color(0xFF1B6FFF),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                height: 1.40,
                                letterSpacing: -0.13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Add some bottom spacing so button doesn't feel cramped
            const SizedBox(height: FinSizes.spaceBtwSections),

            // Button inside the scrollable area
            const SignupContinueButton(),

            // Extra bottom padding for keyboard space
            const SizedBox(height: FinSizes.spaceBtwSections),
          ],
        ),
      ),
    );
  }
}