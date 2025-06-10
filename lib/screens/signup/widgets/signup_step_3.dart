import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_strings.dart';
import '../signup_controller.dart';

class SignupStep3 extends StatelessWidget {
  const SignupStep3({super.key});

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
            const SizedBox(height: FinSizes.spaceBtwSections),

            // Form
            Form(
              key: controller.step3FormKey,
              child: Column(
                children: [
                  // CPF
                  TextFormField(
                    controller: controller.cpfController,
                    validator: controller.validateCPF,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Seu CPF',
                      prefixIcon: Icon(Iconsax.card),
                      hintText: '000.000.000-00',
                    ),
                  ),
                  const SizedBox(height: FinSizes.spaceBtwInputFields),

                  // Birthdate
                  TextFormField(
                    controller: controller.birthdateController,
                    readOnly: true,
                    onTap: () => controller.selectBirthdate(context),
                    decoration: const InputDecoration(
                      labelText: 'Sua data de nascimento',
                      prefixIcon: Icon(Iconsax.calendar),
                      suffixIcon: Icon(Iconsax.arrow_down_1),
                    ),
                  ),
                  const SizedBox(height: FinSizes.spaceBtwInputFields),

                  // Phone Number
                  TextFormField(
                    controller: controller.phoneController,
                    validator: controller.validatePhone,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      labelText: 'Número do seu celular',
                      prefixIcon: Icon(Iconsax.call),
                      hintText: '(11) 99999-9999',
                    ),
                  ),
                  const SizedBox(height: FinSizes.spaceBtwSections * 2),

                  // Security notice
                  Container(
                    padding: const EdgeInsets.all(FinSizes.md),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(FinSizes.borderRadiusMd),
                    ),
                    child: Text(
                      'Coletamos informações para garantir sua segurança e cumprir obrigações legais de proteção de dados.',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 1.43,
                        letterSpacing: -0.28,
                        color: Colors.white.withOpacity(0.8),
                      ),
                      textAlign: TextAlign.center,
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