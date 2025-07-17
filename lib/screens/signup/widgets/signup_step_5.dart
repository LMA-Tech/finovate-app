import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_strings.dart';
import '../signup_controller.dart';

class SignupStep5 extends StatelessWidget {
  const SignupStep5({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SignupController>();

    return Padding(
      padding: const EdgeInsets.all(FinSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title - full width up to progress bars
          const Text(
            'Digite seu código de verificação',
            style: TextStyle(
              fontSize: FinSizes.fontSizeLg + 6, // 24px
              fontWeight: FontWeight.w600,
              height: 1.33,
              letterSpacing: -0.48,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: FinSizes.spaceBtwSections),

          // Subtitle with bold text - full width
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
                  const TextSpan(text: 'Enviamos'),
                  TextSpan(
                    text: controller.selectedVerificationMethod.value == VerificationMethod.email
                        ? ' um Email com um '
                        : ' um SMS com um ',
                  ),
                  const TextSpan(text: 'código de verificação', style: TextStyle(fontWeight: FontWeight.w600)),
                  TextSpan(
                    text: controller.selectedVerificationMethod.value == VerificationMethod.email
                        ? ' para o email ${controller.step1Form.control('email').value}.'
                        : ' para o número ${controller.step3Form.control('phone').value}.',
                  ),
                ],
              ),
            ),
          )),
          const SizedBox(height: FinSizes.spaceBtwSections),

          // PIN Input
          Center(
            child: Pinput(
              length: 6,
              onChanged: controller.onCodeChanged,
              onCompleted: (code) => controller.verifyCode(),
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
                      color: Color(0xFFBADBC1), // Only the timer numbers in green
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
                controller.resendCode();
              },
              child: const Text(
                'Reenviar código',
                style: TextStyle(
                  color: FinColors.white,
                  fontSize: FinSizes.fontSizeMd,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
                : const SizedBox.shrink()),
          ),

          // Spacer to push button to bottom
          const Spacer(),

          // Verify button
          Obx(() => Container(
            width: double.infinity,
            height: 48,
            decoration: ShapeDecoration(
              color: controller.verificationCode.value.length == 6 && !controller.isLoading.value
                  ? const Color(0xFF1B6FFF)
                  : const Color(0xFF1B6FFF).withOpacity(0.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: controller.verificationCode.value.length == 6 && !controller.isLoading.value
                    ? () => controller.verifyCode()
                    : null,
                borderRadius: BorderRadius.circular(6),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Center(
                    child: controller.isLoading.value
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                        : const Text(
                      'Verificar código',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: FinColors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        height: 1.50,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )),

          // Bottom padding
          const SizedBox(height: FinSizes.spaceBtwSections),
        ],
      ),
    );
  }
}