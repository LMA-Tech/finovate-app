import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/constants/sizes.dart';
import '../signup_controller.dart';
import 'questionnaire_option.dart';
import 'signup_continue_button.dart';

/// Reusable Questionnaire Screen for Questions 1-4
///
/// This widget displays a question with multiple choice options
/// and handles answer selection
class SignupStepQuestionnaire extends StatelessWidget {
  /// Question number (1-4)
  final int questionNumber;

  /// Question title text
  final String questionTitle;

  /// Optional subtitle text (e.g., for question 4 explanation)
  final String? questionSubtitle;

  /// List of answer options to display
  final List<String> options;

  const SignupStepQuestionnaire({
    super.key,
    required this.questionNumber,
    required this.questionTitle,
    this.questionSubtitle,
    required this.options,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SignupController>();

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
                  //Question Title
                  Text(
                    questionTitle,
                    style: const TextStyle(
                      fontSize: FinSizes.fontSizeLg + 6, // 24px
                      fontWeight: FontWeight.w600,
                      height: 1.33,
                      letterSpacing: -0.48,
                      color: Colors.white,
                    ),
                  ),

                  // Subtitle (if needed)
                  if (questionSubtitle != null) ...[
                    const SizedBox(height: FinSizes.spaceBtwItems),
                    Text(
                      questionSubtitle!,
                      style: const TextStyle(
                        color: Color(0xFFDFDFE0), // Neutral-gray-200
                        fontSize: FinSizes.fontSizeSm,
                        fontWeight: FontWeight.w400,
                        height: 1.50,
                        letterSpacing: -0.16,
                      ),
                    ),
                  ],

                  const SizedBox(height: FinSizes.spaceBtwSections),

                  // Answer Options
                  Obx(() {
                    final selectedAnswer = controller.getSelectedAnswer(questionNumber);

                    return Column(
                      children: options.map((option) {
                        final isSelected = selectedAnswer == option;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: FinSizes.spaceBtwItems),
                          child: QuestionnaireOption(
                            text: option,
                            isSelected: isSelected,
                            onTap: () {
                              controller.selectQuestionnaireAnswer(questionNumber, option);
                            },
                          ),
                        );
                      }).toList(),
                    );
                  }),

                  const SizedBox(height: FinSizes.spaceBtwSections),

                  // Continue/Next Button
                  const SignupContinueButton(),

                  const SizedBox(height: FinSizes.spaceBtwSections),
                ],
              ),
          ),
        ),
      )
    );
  }
}