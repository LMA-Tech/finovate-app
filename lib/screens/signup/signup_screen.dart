import 'package:finovate_app/common/widgets/login_signup/form_divider.dart';
import 'package:finovate_app/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../utils/constants/colors.dart';
import '../../utils/constants/sizes.dart';
import '../../utils/helpers/helper_functions.dart';
import 'signup_controller.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());
    final dark = FinHelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: dark ? FinColors.white : FinColors.dark,
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
              // Title
              const Text(
                FinTexts.signupTitle,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  height: 1.60,
                  letterSpacing: -0.40,
                ),
              ),
              const SizedBox(height: FinSizes.largeSpaceBtwSections),

              // Form
              Obx(() => Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    // First Name & Last Name Row
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: controller.firstNameController,
                            validator: controller.validateFirstName,
                            decoration: const InputDecoration(
                              labelText: FinTexts.firstName,
                              prefixIcon: Icon(Iconsax.user),
                            ),
                          ),
                        ),
                        const SizedBox(width: FinSizes.spaceBtwInputFields),
                        Expanded(
                          child: TextFormField(
                            controller: controller.lastNameController,
                            validator: controller.validateLastName,
                            decoration: const InputDecoration(
                              labelText: FinTexts.lastName,
                              prefixIcon: Icon(Iconsax.user),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: FinSizes.spaceBtwInputFields),

                    // Middle Name
                    TextFormField(
                      controller: controller.middleNameController,
                      decoration: const InputDecoration(
                        labelText: FinTexts.middleName,
                        prefixIcon: Icon(Iconsax.user),
                      ),
                    ),
                    const SizedBox(height: FinSizes.spaceBtwInputFields),

                    // Email
                    TextFormField(
                      controller: controller.emailController,
                      validator: controller.validateEmail,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: FinTexts.email,
                        prefixIcon: Icon(Iconsax.direct),
                      ),
                    ),
                    const SizedBox(height: FinSizes.spaceBtwInputFields),

                    // Phone Number
                    TextFormField(
                      controller: controller.phoneController,
                      validator: controller.validatePhone,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: FinTexts.phoneNo,
                        prefixIcon: Icon(Iconsax.call),
                        hintText: '(11) 99999-9999',
                      ),
                    ),
                    const SizedBox(height: FinSizes.spaceBtwInputFields),

                    // CPF
                    TextFormField(
                      controller: controller.cpfController,
                      validator: controller.validateCPF,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: FinTexts.cpf,
                        prefixIcon: Icon(Iconsax.card),
                        hintText: '000.000.000-00',
                      ),
                    ),
                    const SizedBox(height: FinSizes.spaceBtwInputFields),

                    // Birthdate
                    TextFormField(
                      controller: controller.birthdateController,
                      validator: controller.validateBirthdate,
                      readOnly: true,
                      onTap: () => controller.selectBirthdate(context),
                      decoration: const InputDecoration(
                        labelText: FinTexts.birthDate,
                        prefixIcon: Icon(Iconsax.calendar),
                        hintText: FinTexts.selectBirthDate,
                        suffixIcon: Icon(Iconsax.arrow_down_1),
                      ),
                    ),
                    const SizedBox(height: FinSizes.spaceBtwInputFields),

                    // Password
                    TextFormField(
                      controller: controller.passwordController,
                      validator: controller.validatePassword,
                      obscureText: controller.hidePassword.value,
                      decoration: InputDecoration(
                        labelText: FinTexts.password,
                        prefixIcon: const Icon(Iconsax.password_check),
                        suffixIcon: IconButton(
                          onPressed: controller.togglePassword,
                          icon: Icon(
                            controller.hidePassword.value
                                ? Iconsax.eye_slash
                                : Iconsax.eye,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: FinSizes.spaceBtwInputFields),

                    // Terms & Conditions Check
                    Row(
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
                                  text: ' ${FinTexts.iAgreeTo} ',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                TextSpan(
                                  text: '${FinTexts.privacyPolicy} ',
                                  style: Theme.of(context).textTheme.bodyMedium!.apply(
                                    color: dark ? FinColors.white : FinColors.primary,
                                    decoration: TextDecoration.underline,
                                    decorationColor: dark ? FinColors.white : FinColors.primary,
                                  ),
                                ),
                                TextSpan(
                                  text: '${FinTexts.and} ',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                TextSpan(
                                  text: FinTexts.termsOfUse,
                                  style: Theme.of(context).textTheme.bodyMedium!.apply(
                                    color: dark ? FinColors.white : FinColors.primary,
                                    decoration: TextDecoration.underline,
                                    decorationColor: dark ? FinColors.white : FinColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: FinSizes.spaceBtwSections),

                    // Sign Up Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: controller.isLoading.value ? null : controller.signUp,
                        child: controller.isLoading.value
                            ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                            : const Text(FinTexts.createAccount),
                      ),
                    ),
                  ],
                ),
              )),
              const SizedBox(height: FinSizes.spaceBtwSections),

              // Divider
              // FinFormDivider(dividerText: FinTexts.orSignUpWith.capitalize!),
            ],
          ),
        ),
      ),
    );
  }
}