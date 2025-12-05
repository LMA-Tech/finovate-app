import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../common/widgets/custom_text_field.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_strings.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../forgot_password_controller.dart';
import 'forgot_password_button.dart';

class ForgotPasswordStep1 extends StatelessWidget {
  const ForgotPasswordStep1({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ForgotPasswordController>();
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(FinSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top content section - responsive text with constraints
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title with responsive sizing
              LayoutBuilder(
                builder: (context, constraints) {
                  return ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: screenHeight * 0.12, // Max 12% of screen height
                      maxWidth: constraints.maxWidth,
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        FinTexts.forgotPasswordTitle,
                        style: TextStyle(
                          fontSize: screenWidth < 360 ? 22 : (FinSizes.fontSizeLg + 6), // Responsive
                          fontWeight: FontWeight.w600,
                          height: 1.33,
                          letterSpacing: -0.48,
                          color: FinColors.textWhite,
                        ),
                        maxLines: 2,
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: FinSizes.sm),

              // Subtitle with responsive sizing
              LayoutBuilder(
                builder: (context, constraints) {
                  return ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: screenHeight * 0.15, // Max 15% of screen height
                      maxWidth: constraints.maxWidth,
                    ),
                    child: Text(
                      FinTexts.forgotPasswordSubtitle,
                      style: TextStyle(
                        color: FinColors.textGray200,
                        fontSize: screenWidth < 360 ? 14 : FinSizes.fontSizeMd, // Responsive
                        fontWeight: FontWeight.w400,
                        height: 1.50,
                        letterSpacing: -0.16,
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                  );
                },
              ),

              const SizedBox(height: FinSizes.spaceBtwSections),

              // Form section
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
                  ],
                ),
              ),
            ],
          ),

          // Dynamic spacer - takes up all remaining space
          const Expanded(child: SizedBox()),

          // Bottom section - button always at bottom
          FinHelperFunctions.getBottomSafeArea(
            child: const ForgotPasswordButton(buttonText: FinTexts.resetPassword),
            minimumPadding: FinSizes.spaceBtwSections,
          ),
        ],
      ),
    );
  }
}