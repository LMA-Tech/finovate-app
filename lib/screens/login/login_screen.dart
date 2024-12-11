import 'package:finovate_app/common/styles/spacing_styles.dart';
import 'package:finovate_app/utils/constants/colors.dart';
import 'package:finovate_app/utils/constants/image_strings.dart';
import 'package:finovate_app/utils/constants/text_strings.dart';
import 'package:finovate_app/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../utils/constants/sizes.dart';

part 'login_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  createState() => _LoginScreen();
}

class _LoginScreen extends LoginController {
  @override
  Widget build(BuildContext context) {
    final dark = FinHelperFunctions.isDarkMode(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: FinSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image(
                    height: 150,
                    image: AssetImage(
                        dark ? FinImages.lightAppLogo : FinImages.darkAppLogo),
                  ),
                  Text(FinTexts.loginTitle,
                      style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: FinSizes.sm),
                  Text(FinTexts.loginSubTitle,
                      style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),

              /// Form
              Form(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: FinSizes.spaceBtwSections),
                  child: Column(
                    children: [
                      ///Email
                      TextFormField(
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Iconsax.direct_right),
                            labelText: FinTexts.email),
                      ),
                      const SizedBox(height: FinSizes.spaceBtwInputFields),

                      /// Password
                      TextFormField(
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
                              onPressed: () {},
                              child: const Text(FinTexts.signIn))),
                      const SizedBox(height: FinSizes.spaceBtwItems),

                      /// Create Account Button
                      SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                              onPressed: () {},
                              child: const Text(FinTexts.createAccount))),
                      const SizedBox(height: FinSizes.spaceBtwSections),
                    ],
                  ),
                ),
              ),
              /// Divider
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(child: Divider(color: dark ? FinColors.darkerGrey: FinColors.grey, thickness: 0.5, indent: 60, endIndent: 5)),
                  Text(FinTexts.orSignInWith.capitalize!, style: Theme.of(context).textTheme.labelMedium),
                  Flexible(child: Divider(color: dark ? FinColors.darkerGrey: FinColors.grey, thickness: 0.5, indent: 60, endIndent: 60)),
                ],
              )
              /// Footer
            ],
          ),
        ),
      ),
    );
  }
}
