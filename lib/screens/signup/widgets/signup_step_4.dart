import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_strings.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../signup_controller.dart';

class SignupStep4 extends StatelessWidget {
  const SignupStep4({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SignupController>();
    final dark = FinHelperFunctions.isDarkMode(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(FinSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Text(
              'Termos e Condições',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                height: 1.33,
                letterSpacing: -0.48,
              ),
            ),
            const SizedBox(height: FinSizes.spaceBtwSections),

            // Summary card
            Container(
              padding: const EdgeInsets.all(FinSizes.lg),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(FinSizes.borderRadiusLg),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Resumo das suas informações:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: FinSizes.md),

                  Obx(() =>
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow(
                              'Email:', controller.emailController.text),
                          _buildInfoRow('Nome:',
                              '${controller.firstNameController
                                  .text} ${controller.lastNameController
                                  .text}'),
                          if (controller.cpfController.text.isNotEmpty)
                            _buildInfoRow(
                                'CPF:', controller.cpfController.text),
                          if (controller.phoneController.text.isNotEmpty)
                            _buildInfoRow(
                                'Telefone:', controller.phoneController.text),
                          if (controller.birthdateController.text.isNotEmpty)
                            _buildInfoRow('Data de nascimento:',
                                controller.birthdateController.text),
                        ],
                      )),
                ],
              ),
            ),
            const SizedBox(height: FinSizes.spaceBtwSections),

            // Terms & Conditions
            Obx(() =>
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: controller.acceptTerms.value,
                        onChanged: controller.toggleTerms,
                      ),
                    ),
                    const SizedBox(width: FinSizes.spaceBtwItems),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '.. ',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                            TextSpan(
                              text: '${FinTexts.privacyPolicy} ',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: FinColors.primary,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            TextSpan(
                              text: '${FinTexts.and} ',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                            TextSpan(
                              text: FinTexts.termsOfUse,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: FinColors.primary,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            TextSpan(
                              text: ' da Finovate.',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
            const SizedBox(height: FinSizes.spaceBtwSections),

            // Security notice
            Container(
              padding: const EdgeInsets.all(FinSizes.md),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(FinSizes.borderRadiusMd),
                border: Border.all(
                  color: Colors.blue.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.security,
                    color: Colors.blue,
                    size: 20,
                  ),
                  const SizedBox(width: FinSizes.sm),
                  Expanded(
                    child: Text(
                      'Suas informações estão protegidas com criptografia de ponta a ponta.',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: FinSizes.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? 'Não informado' : value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}