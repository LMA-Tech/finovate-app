import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../common/widgets/app_background.dart';
import '../../common/widgets/custom_text_field.dart';
import '../../services/activity_tracker.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/sizes.dart';
import '../../utils/constants/text_strings.dart';
import 'forgot_password_controller.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgotPasswordController());
    final activityTracker = Get.find<ActivityTracker>();

    return GestureDetector(
      onTap: () => activityTracker.recordActivity(),
      child: AppBackground(
        child: Scaffold(
          // App Bar with back button
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(
                Icons.chevron_left,
                color: Colors.white,
              ),
              onPressed: () => Get.back(),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: SafeArea(
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

                  // Form
                  ReactiveForm(
                    formGroup: controller.forgotPasswordForm,
                    child: Obx(() => Column(
                      children: [
                        // Email Field
                        CustomTextFieldReactive(
                          formControlName: 'email',
                          label: FinTexts.email,
                          hintText: FinTexts.emailHint,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.done,
                          validationMessages: {
                            ValidationMessage.required: (_) => FinTexts.loginValidationEmailRequired,
                            ValidationMessage.email: (_) => FinTexts.loginValidationEmailInvalid,
                          },
                        ),
                        const SizedBox(height: FinSizes.spaceBtwSections),

                        // Reset Password Button
                        Container(
                          width: double.infinity,
                          height: FinSizes.buttonHeight * 2.7,
                          decoration: ShapeDecoration(
                            color: controller.canResetPasswordReactive.value && !controller.isLoading.value  // Changed this line
                                ? FinColors.primary
                                : FinColors.primary.withOpacity(0.4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(FinSizes.buttonRadius / 2),
                            ),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: controller.canResetPasswordReactive.value && !controller.isLoading.value  // Changed this line
                                  ? () => controller.sendResetCode()
                                  : null,
                              borderRadius: BorderRadius.circular(FinSizes.buttonRadius / 2),
                              child: Center(
                                child: controller.isLoading.value
                                    ? const SizedBox(
                                  height: FinSizes.iconSm,
                                  width: FinSizes.iconSm,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(FinColors.white),
                                  ),
                                )
                                    : const Text(
                                  FinTexts.resetPassword,
                                  style: TextStyle(
                                    color: FinColors.white,
                                    fontSize: FinSizes.fontSizeMd,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}