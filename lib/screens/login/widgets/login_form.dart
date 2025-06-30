import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../../../common/widgets/custom_text_field.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_strings.dart';
import '../../../utils/constants/colors.dart';
import '../login_controller.dart';

class FinLoginForm extends StatelessWidget {
  const FinLoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    return ReactiveForm(
      formGroup: controller.loginForm,
      child: Obx(() => Padding(
        padding: const EdgeInsets.symmetric(vertical: FinSizes.spaceBtwSections),
        child: Column(
          children: [
            // Email Field
            CustomTextFieldReactive(
              formControlName: 'email',
              label: FinTexts.email,
              hintText: FinTexts.emailHint,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validationMessages: {
                ValidationMessage.required: (_) => FinTexts.loginValidationEmailRequired,
                ValidationMessage.email: (_) => FinTexts.loginValidationEmailInvalid,
              },
            ),
            const SizedBox(height: FinSizes.spaceBtwInputFields),

            // Password Field
            CustomTextFieldReactive(
              formControlName: 'password',
              label: FinTexts.password,
              obscureText: controller.hidePassword.value,
              textInputAction: TextInputAction.done,
              validationMessages: {
                ValidationMessage.required: (_) => FinTexts.loginValidationPasswordRequired,
                ValidationMessage.minLength: (_) => FinTexts.loginValidationPasswordMinLength,
              },
              suffixIcon: IconButton(
                onPressed: controller.togglePassword,
                icon: Icon(
                  controller.hidePassword.value ? Iconsax.eye_slash : Iconsax.eye,
                  color: FinColors.white,
                  size: FinSizes.iconSm,
                ),
              ),
            ),
            const SizedBox(height: FinSizes.spaceBtwInputFields / 2),

            // Forget Password (right-aligned)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: controller.isLoading.value ? null : controller.resetPassword,
                  style: TextButton.styleFrom(
                    foregroundColor: FinColors.white,
                  ),
                  child: const Text(FinTexts.forgetPassword),
                ),
              ],
            ),
            const SizedBox(height: FinSizes.spaceBtwSections),

            // Sign In Button with reactive validation
            Container(
              width: double.infinity,
              height: FinSizes.buttonHeight * 2.7, // Use constant from sizes
              decoration: ShapeDecoration(
                color: controller.canLoginReactive.value && !controller.isLoading.value
                    ? FinColors.primary
                    : FinColors.primary.withOpacity(0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(FinSizes.buttonRadius / 2), // Use constant
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: controller.canLoginReactive.value && !controller.isLoading.value
                      ? () => controller.login()
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
                      FinTexts.signIn,
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
        ),
      )),
    );
  }
}