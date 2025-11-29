import 'package:finovate_app/utils/constants/text_strings.dart';
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

  /// Whether this is the last question (triggers submission)
  final bool isLastQuestion;

  const SignupStepQuestionnaire({
    super.key,
    required this.questionNumber,
    required this.questionTitle,
    this.questionSubtitle,
    required this.options,
    this.isLastQuestion = false,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SignupController>();

    return Column(
      children: [
        // Question Title
        Padding(
          padding: const EdgeInsets.fromLTRB(8, FinSizes.spaceBtwItems, 8, 0),
          child: Text(
            questionTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: FinSizes.fontSizeXLg,
              fontWeight: FontWeight.w600,
              height: 1.60,
              letterSpacing: -0.40,
              color: Colors.white,
            ),
          ),
        ),

        // Subtitle (if needed)
        if (questionSubtitle != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(8, FinSizes.spaceBtwItems, 8, 0),
            child: Text(
              questionSubtitle!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFFDFDFE0),
                fontSize: FinSizes.fontSizeMd,
                fontWeight: FontWeight.w400,
                height: 1.50,
                letterSpacing: -0.32,
              ),
            ),
          ),

        const SizedBox(height: FinSizes.spaceBtwSections),

        // Answer Options
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: FinSizes.xl),
            child: SingleChildScrollView(
              child: Obx(() {
                final selectedAnswer = controller.getSelectedAnswer(questionNumber);

                return Column(
                  children: options.map((option) {
                    final isSelected = selectedAnswer == option;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: FinSizes.lg),
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
            ),
          ),
        ),

        const SizedBox(height: FinSizes.spaceBtwSections),

        // Button pinned to bottom
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: FinSizes.defaultSpace),
          child: isLastQuestion
              ? SignupContinueButton(
            customText: FinTexts.questionnaireFinalizeButton,
            customOnTap: () => controller.submitQuestionnaire(),
          )
              : const SignupContinueButton(),
        ),

        const SizedBox(height: FinSizes.spaceBtwSections),
      ],
    );
  }
}