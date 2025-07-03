import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../common/widgets/custom_text_field.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_strings.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../forgot_password_controller.dart';
import 'forgot_password_button.dart';

class ForgotPasswordStep3 extends StatelessWidget {
  const ForgotPasswordStep3({super.key});

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
                  'Defina uma nova senha',
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
                  'Crie uma nova senha, mas certifique de que ela seja diferente das anteriores por questões de segurança.',
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
                  formGroup: controller.step3Form,
                  child: Column(
                    children: [
                      // New Password Field
                      Obx(() => CustomTextFieldReactive(
                        formControlName: 'password',
                        label: 'Nova senha',
                        obscureText: controller.hidePassword.value,
                        textInputAction: TextInputAction.next,
                        validationMessages: {
                          ValidationMessage.required: (_) => 'Nova senha é obrigatória',
                          ValidationMessage.minLength: (_) => 'Senha deve ter pelo menos 6 caracteres',
                        },
                        suffixIcon: IconButton(
                          onPressed: controller.togglePassword,
                          icon: Icon(
                            controller.hidePassword.value ? Iconsax.eye_slash : Iconsax.eye,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      )),
                      const SizedBox(height: FinSizes.spaceBtwInputFields),

                      // Confirm New Password Field
                      Obx(() => CustomTextFieldReactive(
                        formControlName: 'confirmPassword',
                        label: 'Confirmar nova senha',
                        obscureText: controller.hideConfirmPassword.value,
                        textInputAction: TextInputAction.done,
                        validationMessages: {
                          ValidationMessage.required: (_) => 'Confirmação de senha é obrigatória',
                          ValidationMessage.mustMatch: (_) => 'Senhas não coincidem',
                        },
                        suffixIcon: IconButton(
                          onPressed: controller.toggleConfirmPassword,
                          icon: Icon(
                            controller.hideConfirmPassword.value ? Iconsax.eye_slash : Iconsax.eye,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      )),
                      const SizedBox(height: FinSizes.spaceBtwSections),
                    ],
                  ),
                ),

                // Password requirements info
                Container(
                  padding: const EdgeInsets.all(FinSizes.md),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D3245).withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFFE3EBFF).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.white.withOpacity(0.7),
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Requisitos da senha:',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '• Pelo menos 6 caracteres\n'
                            '• Use uma combinação de letras, números e símbolos\n'
                            '• Evite informações pessoais óbvias',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),

                // Dynamic spacer - takes up all remaining space
                const Expanded(child: SizedBox()),

                // Bottom section - button always at bottom
                FinHelperFunctions.getBottomSafeArea(
                  child: const ForgotPasswordButton( buttonText: FinTexts.resetPassword),
                  minimumPadding: FinSizes.spaceBtwSections,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}