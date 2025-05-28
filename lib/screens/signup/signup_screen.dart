import 'package:finovate_app/common/widgets/login_signup/form_divider.dart';
import 'package:finovate_app/main.dart';
import 'package:finovate_app/utils/constants/text_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../utils/constants/colors.dart';
import '../../utils/constants/sizes.dart';
import '../../utils/helpers/helper_functions.dart';

part 'signup_controller.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  createState() => _SignupScreen();
}

class _SignupScreen extends SignupController {
  @override
  Widget build(BuildContext context) {
    final dark = FinHelperFunctions.isDarkMode(context);

    return Scaffold(
      ///App Bar and Back Button
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: FinHelperFunctions.isDarkMode(context)
                ? FinColors.white
                : FinColors.dark,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(FinSizes.defaultSpace),
          child: Column(
            children: [
              ///Title
              const Text(FinTexts.signupTitle,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    height: 1.60,
                    letterSpacing: -0.40,
                  )),
              const SizedBox(height: FinSizes.largeSpaceBtwSections),

              ///Form
              Form(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            expands: false,
                            decoration: const InputDecoration(
                                labelText: FinTexts.firstName,
                                prefixIcon: Icon(Iconsax.user)),
                          ),
                        ),
                        const SizedBox(height: FinSizes.spaceBtwInputFields),
                        Expanded(
                          child: TextFormField(
                            expands: false,
                            decoration: const InputDecoration(
                                labelText: FinTexts.lastName,
                                prefixIcon: Icon(Iconsax.user)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: FinSizes.spaceBtwInputFields),

                    /// Username
                    TextFormField(
                      expands: false,
                      decoration: const InputDecoration(
                          labelText: FinTexts.username,
                          prefixIcon: Icon(Iconsax.user_edit)),
                    ),
                    const SizedBox(height: FinSizes.spaceBtwInputFields),

                    /// Email
                    TextFormField(
                      expands: false,
                      decoration: const InputDecoration(
                          labelText: FinTexts.email,
                          prefixIcon: Icon(Iconsax.direct)),
                    ),
                    const SizedBox(height: FinSizes.spaceBtwInputFields),

                    /// Phone Number
                    TextFormField(
                      expands: false,
                      decoration: const InputDecoration(
                          labelText: FinTexts.phoneNo,
                          prefixIcon: Icon(Iconsax.call)),
                    ),
                    const SizedBox(height: FinSizes.spaceBtwInputFields),

                    /// Password
                    TextFormField(
                      expands: false,
                      decoration: const InputDecoration(
                        labelText: FinTexts.password,
                        prefixIcon: Icon(Iconsax.password_check),
                        suffixIcon: Icon(Iconsax.eye_slash),
                      ),
                    ),
                    const SizedBox(height: FinSizes.spaceBtwInputFields),

                    /// Terms & Conditions Check
                    Row(
                      children: [
                        SizedBox(
                            width: 24,
                            height: 24,
                            child:
                                Checkbox(value: true, onChanged: (value) {})),
                        const SizedBox(height: FinSizes.spaceBtwItems),
                        Text.rich(TextSpan(children: [
                          TextSpan(
                              text: ' ${FinTexts.iAgreeTo} ',
                              style: Theme.of(context).textTheme.bodySmall),
                          TextSpan(
                              text: '${FinTexts.privacyPolicy} ',
                              style:
                                  Theme.of(context).textTheme.bodyMedium!.apply(
                                        color: dark
                                            ? FinColors.white
                                            : FinColors.primary,
                                        decoration: TextDecoration.underline,
                                        decorationColor: dark
                                            ? FinColors.white
                                            : FinColors.primary,
                                      )),
                          TextSpan(
                              text: '${FinTexts.and} ',
                              style: Theme.of(context).textTheme.bodySmall),
                          TextSpan(
                              text: FinTexts.termsOfUse,
                              style:
                                  Theme.of(context).textTheme.bodyMedium!.apply(
                                        color: dark
                                            ? FinColors.white
                                            : FinColors.primary,
                                        decoration: TextDecoration.underline,
                                        decorationColor: dark
                                            ? FinColors.white
                                            : FinColors.primary,
                                      )),
                        ]))
                      ],
                    ),
                    const SizedBox(height: FinSizes.spaceBtwSections),

                    /// Sign Up Button
                    SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () {},
                            child: const Text(FinTexts.createAccount))),
                  ],
                ),
              ),
              const SizedBox(height: FinSizes.spaceBtwSections),

              /// Divider 
              FinFormDivider(dividerText: FinTexts.orSignUpWith.capitalize!),
            ],
          ),
        ),
      ),
    );
  }
}
