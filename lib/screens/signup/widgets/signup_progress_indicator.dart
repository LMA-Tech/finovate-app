import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../signup_controller.dart';

/// Progress indicator for signup flow and questionnaire
///
/// Shows different progress bars depending on context:
/// - Signup flow (steps 1-4): 5-step progress bar
/// - Questionnaire (steps 7-10): 4-step progress bar
class SignupProgressIndicator extends StatelessWidget {
  const SignupProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SignupController>();

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: FinSizes.defaultSpace,
        vertical: FinSizes.md,
      ),
      child: Obx(() {
        // Determine which mode we're in
        final isQuestionnaire = controller.isQuestionnaireMode;

        if (isQuestionnaire) {
          // Questionnaire progress: 4 steps
          return _buildQuestionnaireProgress(controller);
        } else {
          // Signup progress: 5 steps
          return _buildSignupProgress(controller);
        }
      }),
    );
  }

  /// Build signup flow progress (5 steps)
  Widget _buildSignupProgress(SignupController controller) {
    return Row(
      children: List.generate(SignupController.totalProgressLevels, (index) {
        final isActive = index <= controller.progressLevel;

        return Expanded(
          child: Container(
            height: 6,
            margin: EdgeInsets.only(
              right: index < SignupController.totalProgressLevels - 1 ? 8 : 0,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: isActive
                  ? FinColors.primary
                  : FinColors.accent.withValues(alpha: 0.3),
            ),
          ),
        );
      }),
    );
  }

  /// Build questionnaire progress (4 steps for 4 questions)
  Widget _buildQuestionnaireProgress(SignupController controller) {
    const totalQuestions = 4;
    final currentQuestion = controller.questionnaireProgress;

    return Row(
      children: List.generate(totalQuestions, (index) {
        final questionNumber = index + 1;
        final isActive = questionNumber <= currentQuestion;
        final isCompleted = controller.questionnaireAnswers.containsKey(questionNumber);

        return Expanded(
          child: Container(
            height: 6,
            margin: EdgeInsets.only(
              right: index < totalQuestions - 1 ? 8 : 0,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: isActive
                  ? FinColors.primary
                  : FinColors.accent.withValues(alpha: 0.3),
            ),
          ),
        );
      }),
    );
  }
}