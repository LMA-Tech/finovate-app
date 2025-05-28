import 'package:finovate_app/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_strings.dart';
import '../login_controller.dart';

class FinLoginForm extends StatelessWidget {
  const FinLoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Initialize controller using GetX
    final controller = Get.put(LoginController());

    return Form(
      child: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: FinSizes.spaceBtwSections),
        child: Column(
          children: [
            ///Email
            TextFormField(
              controller: controller.emailController,
              decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.direct_right),
                  labelText: FinTexts.email),
            ),
            const SizedBox(height: FinSizes.spaceBtwInputFields),

            /// Password
            TextFormField(
              controller: controller.passwordController,
              decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.password_check),
                  labelText: FinTexts.password,
                  suffixIcon: Icon(Iconsax.eye_slash)),
            ),
            const SizedBox(height: FinSizes.spaceBtwInputFields / 2),

            /// Remember Me & Forget Password
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// Remember Me
                Row(
                  children: [
                    Checkbox(value: true, onChanged: (value) {}),
                    const Text(FinTexts.rememberMe),
                  ],
                ),

                ///  Forget Password
                TextButton(
                    onPressed: () {},
                    child: const Text(FinTexts.forgetPassword)),
              ],
            ),
            const SizedBox(height: FinSizes.spaceBtwSections),

            ///  Sign In Button
            SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () => controller.login(context),
                    child: const Text(FinTexts.signIn))),
            const SizedBox(height: FinSizes.spaceBtwItems),

            /// Create Account Button
            // SizedBox(
            //     width: double.infinity,
            //     child: OutlinedButton(
            //         onPressed: () {},
            //         child: const Text(FinTexts.createAccount))),
            // const SizedBox(height: FinSizes.spaceBtwItems),
          ],
        ),
      ),
    );
  }
}