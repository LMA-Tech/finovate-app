import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:intl/intl.dart';

import '../../../common/widgets/custom_text_field.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_strings.dart';
import '../signup_controller.dart';
import '../widgets/signup_continue_button.dart';
import 'disclaimers.dart';

class SignupStep3 extends StatelessWidget {
  const SignupStep3({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SignupController>();

    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top -
              kToolbarHeight,
        ),
        child: IntrinsicHeight(
          child: Padding(
            padding: const EdgeInsets.all(FinSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                const Text(
                  FinTexts.signupTitle2, // Same title as step 2
                  style: TextStyle(
                    fontSize: FinSizes.fontSizeLg + 6, // 24px
                    fontWeight: FontWeight.w600,
                    height: 1.33,
                    letterSpacing: -0.48,
                  ),
                ),
                const SizedBox(height: FinSizes.sm),

                // Subtitle
                const Text(
                  FinTexts.signupSubtitle2, // Same subtitle as step 2
                  style: TextStyle(
                    color: Color(0xFFDFDFE0), // Neutral-gray-200
                    fontSize: FinSizes.fontSizeMd,
                    fontWeight: FontWeight.w400,
                    height: 1.50,
                    letterSpacing: -0.16,
                  ),
                ),
                const SizedBox(height: FinSizes.spaceBtwSections),

                // Form section
                ReactiveForm(
                    formGroup: controller.step3Form,
                    child: Column(
                      children: [
                        // CPF Field
                        CustomTextFieldReactive(
                          formControlName: 'cpf',
                          label: FinTexts.cpf,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          validationMessages: {
                            ValidationMessage.required: (_) =>
                            'CPF é obrigatório',
                            ValidationMessage.pattern: (_) =>
                            FinTexts.signupValidationCpfInvalid,
                          },
                        ),
                        const SizedBox(height: FinSizes.spaceBtwInputFields),

                        // Date of Birth Field (Clickable)
                        GestureDetector(
                          onTap: () => controller.selectBirthdate(context),
                          child: AbsorbPointer(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Label
                                const Text(
                                  FinTexts.birthDate,
                                  style: TextStyle(
                                    color: FinColors.lightGray,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    height: 1.50,
                                    letterSpacing: -0.13,
                                  ),
                                ),
                                const SizedBox(height: 8),

                                // Date display field
                                Obx(() => Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2D3245),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: const Color(0xFFE3EBFF).withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        controller.selectedBirthdate.value != null
                                            ? DateFormat('dd/MM/yyyy').format(controller.selectedBirthdate.value!)
                                            : '',
                                        style: const TextStyle(
                                          color: FinColors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          height: 1.38,
                                          letterSpacing: -0.16,
                                        ),
                                      ),
                                      Icon(
                                        Icons.calendar_today_outlined,
                                        color: FinColors.white.withOpacity(0.6),
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                )),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: FinSizes.spaceBtwInputFields),

                        // Phone Number Field
                        CustomTextFieldReactive(
                          formControlName: 'phone',
                          label: FinTexts.phoneNo,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.done,
                          validationMessages: {
                            ValidationMessage.pattern: (_) =>
                            FinTexts.signupValidationPhoneInvalid,
                          },
                        ),
                        const SizedBox(height: FinSizes.spaceBtwSections),
                      ],
                    )),

                // Data collection disclaimer
                Obx(() => controller.currentStep.value == 2
                    ? const DisclaimerWidget(type: DisclaimerType.dataCollection)
                    : const SizedBox.shrink()),

                const SizedBox(height: FinSizes.spaceBtwInputFields),

                // Button inside the scrollable area
                const SignupContinueButton(),

                // Extra bottom padding for keyboard space
                const SizedBox(height: FinSizes.spaceBtwSections),
              ],
            ),
          ),
        ),
      ),
    );
  }
}