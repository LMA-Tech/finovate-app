import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_strings.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../forgot_password_controller.dart';
import 'forgot_password_button.dart';

class ForgotPasswordStep2 extends StatelessWidget {
  const ForgotPasswordStep2({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ForgotPasswordController>();

    return Padding(
      padding: const EdgeInsets.all(FinSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          const Text(
            FinTexts.forgotPasswordCheckEmailTitle,
            style: TextStyle(
              fontSize: FinSizes.fontSizeLg + 6, // 24px
              fontWeight: FontWeight.w600,
              height: 1.33,
              letterSpacing: -0.48,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: FinSizes.spaceBtwSections),

          // Subtitle with masked email
          Obx(() => SizedBox(
            width: double.infinity, // Force full width
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  color: Color(0xFFDFDFE0), // Neutral-gray-200
                  fontSize: FinSizes.fontSizeSm,
                  fontWeight: FontWeight.w400,
                  height: 1.50,
                  letterSpacing: -0.16,
                ),
                children: [
                  const TextSpan(text: 'Enviamos', style: TextStyle(fontWeight: FontWeight.w600)), // Bold
                  const TextSpan(text: ' um código de redefinição para '),
                  TextSpan(
                    text: controller.getMaskedEmail(),
                    style: const TextStyle(fontWeight: FontWeight.w600), // Bold email
                  ),
                  const TextSpan(text: '. Digite o código de 6 dígitos para redefinir sua senha.'),
                ],
              ),
            ),
          )),
          const SizedBox(height: FinSizes.spaceBtwSections),

          // PIN Input
          Center(
            child: Pinput(
              length: 6, // 6 digits for reset code
              onChanged: controller.onCodeChanged,
              onCompleted: (code) => controller.verifyResetCode(),
              defaultPinTheme: PinTheme(
                width: 48,
                height: 56,
                textStyle: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF2D3245),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFE3EBFF).withOpacity(0.3),
                    width: 1,
                  ),
                ),
              ),
              focusedPinTheme: PinTheme(
                width: 48,
                height: 56,
                textStyle: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF2D3245),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFE3EBFF),
                    width: 1,
                  ),
                ),
              ),
              submittedPinTheme: PinTheme(
                width: 48,
                height: 56,
                textStyle: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF2D3245),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF1B6FFF),
                    width: 1,
                  ),
                ),
              ),
              keyboardType: TextInputType.number,
              separatorBuilder: (index) => const SizedBox(width: 12),
            ),
          ),
          const SizedBox(height: FinSizes.spaceBtwSections),

          // Resend timer disclaimer
          Center(
            child: Obx(() => RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: const TextStyle(
                  color: Color(0xFFDFDFE0), // Regular text color
                  fontSize: FinSizes.fontSizeSm,
                  fontWeight: FontWeight.w400,
                  height: 1.29,
                ),
                children: [
                  const TextSpan(
                    text: FinTexts.resendCode,
                  ),
                  TextSpan(
                    text: controller.formattedTimer,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFBADBC1), // Green timer color
                    ),
                  ),
                ],
              ),
            )),
          ),
          const SizedBox(height: FinSizes.spaceBtwInputFields),

          // Resend button (when timer expires)
          Center(
            child: Obx(() => controller.canResendCode.value
                ? TextButton(
              onPressed: () {
                // Resend code logic
                controller.resendResetCode();
              },
              child: const Text(
                FinTexts.forgotPasswordResendCode,
                style: TextStyle(
                  color: FinColors.white,
                  fontSize: FinSizes.fontSizeMd,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
                : const SizedBox.shrink()),
          ),

          // Dynamic spacer - takes up all remaining space
          const Expanded(child: SizedBox()),

          // Bottom section - button always at bottom
          FinHelperFunctions.getBottomSafeArea(
            child: const ForgotPasswordButton( buttonText: FinTexts.forgotPasswordContinueButton),
            minimumPadding: FinSizes.spaceBtwSections,
          ),
        ],
      ),
    );
  }
}