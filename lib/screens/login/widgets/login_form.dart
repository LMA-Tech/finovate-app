import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_strings.dart';
import '../login_controller.dart';

class FinLoginForm extends StatelessWidget {
  const FinLoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    return Obx(() => Form(
      key: controller.formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: FinSizes.spaceBtwSections),
        child: Column(
          children: [
            // Email Field
            TextFormField(
              controller: controller.emailController,
              validator: controller.validateEmail,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.direct_right),
                labelText: FinTexts.email,
              ),
            ),
            const SizedBox(height: FinSizes.spaceBtwInputFields),

            // Password Field
            TextFormField(
              controller: controller.passwordController,
              validator: controller.validatePassword,
              obscureText: controller.hidePassword.value,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => controller.login(),
              decoration: InputDecoration(
                prefixIcon: const Icon(Iconsax.password_check),
                labelText: FinTexts.password,
                suffixIcon: IconButton(
                  onPressed: controller.togglePassword,
                  icon: Icon(
                    controller.hidePassword.value ? Iconsax.eye_slash : Iconsax.eye,
                  ),
                ),
              ),
            ),
            const SizedBox(height: FinSizes.spaceBtwInputFields / 2),

            // Remember Me & Forget Password
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Remember Me
                Row(
                  children: [
                    Checkbox(
                      value: controller.rememberMe.value,
                      onChanged: controller.toggleRememberMe,
                    ),
                    const Text(FinTexts.rememberMe),
                  ],
                ),

                // Forget Password
                TextButton(
                  onPressed: controller.isLoading.value ? null : controller.resetPassword,
                  child: const Text(FinTexts.forgetPassword),
                ),
              ],
            ),
            const SizedBox(height: FinSizes.spaceBtwSections),

            // Sign In Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.isLoading.value ? null : controller.login,
                child: controller.isLoading.value
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                    : const Text(FinTexts.signIn),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}