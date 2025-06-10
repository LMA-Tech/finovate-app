import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_strings.dart';
import '../signup_controller.dart';

class SignupStep2 extends StatelessWidget {
  const SignupStep2({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SignupController>();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(FinSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Text(
              'Informações pessoais',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                height: 1.33,
                letterSpacing: -0.48,
              ),
            ),
            const SizedBox(height: FinSizes.sm),

            // Subtitle
            Text(
              'Conforme os documentos',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                height: 1.50,
                letterSpacing: -0.32,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: FinSizes.spaceBtwSections),

            // Form
            Form(
              key: controller.step2FormKey,
              child: Column(
                children: [
                  // First Name
                  TextFormField(
                    controller: controller.firstNameController,
                    validator: controller.validateFirstName,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: FinTexts.firstName,
                      prefixIcon: Icon(Iconsax.user),
                    ),
                  ),
                  const SizedBox(height: FinSizes.spaceBtwInputFields),

                  // Last Name
                  TextFormField(
                    controller: controller.lastNameController,
                    validator: controller.validateLastName,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      labelText: FinTexts.lastName,
                      prefixIcon: Icon(Iconsax.user),
                    ),
                  ),
                  const SizedBox(height: FinSizes.spaceBtwSections),

                  // Helper text
                  Text(
                    'Digite seu nome completo exatamente como consta em seu documento de identidade oficial.',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 1.43,
                      letterSpacing: -0.28,
                      color: Colors.white.withOpacity(0.7),
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
}