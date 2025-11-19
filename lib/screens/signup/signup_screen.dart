import 'package:finovate_app/common/widgets/app_background.dart';
import 'package:finovate_app/screens/signup/widgets/signup_step_3.dart';
import 'package:finovate_app/screens/signup/widgets/signup_step_4.dart';
import 'package:finovate_app/screens/signup/widgets/signup_step_5.dart';
import 'package:finovate_app/screens/signup/widgets/signup_step_6.dart';
import 'package:finovate_app/screens/signup/widgets/signup_step_7.dart';
import 'package:finovate_app/screens/signup/widgets/signup_step_questionnaire.dart';
import 'package:finovate_app/screens/signup/widgets/signup_step_questionnaire_final.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/activity_tracker.dart';
import '../../utils/helpers/helper_functions.dart';
import '../../utils/constants/text_strings.dart';
import 'signup_controller.dart';
import 'widgets/signup_progress_indicator.dart';
import 'widgets/signup_step_1.dart';
import 'widgets/signup_step_2.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());
    final dark = FinHelperFunctions.isDarkMode(context);
    final activityTracker = Get.find<ActivityTracker>();

    return GestureDetector(
        onTap: () => activityTracker.recordActivity(),
        child: AppBackground(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: _buildAppBar(controller, dark, context),
            body: Column(
              children: [
                // Progress indicator (only show from step 2 onwards)
                _buildProgressIndicator(controller),

                // Main content - swiping disabled
                Expanded(
                  child: PageView(
                    controller: controller.pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: const [  // ← This was missing!
                      // Original signup steps (0-5)
                      SignupStep1(), // Step 0: Email/Password
                      SignupStep2(), // Step 1: Name
                      SignupStep3(), // Step 2: CPF/Phone/Birthdate
                      SignupStep4(), // Step 3: Verification Method
                      SignupStep5(), // Step 4: OTP Code
                      SignupStep6(), // Step 5: Success Screen

                      // Questionnaire steps (6-11)
                      SignupStep7(), // Step 6: Intro

                      // Step 7: Question 1 - Wealth Range
                      SignupStepQuestionnaire(
                        questionNumber: 1,
                        questionTitle: FinTexts.question1Title,
                        options: [
                          FinTexts.question1Option1,
                          FinTexts.question1Option2,
                          FinTexts.question1Option3,
                          FinTexts.question1Option4,
                          FinTexts.question1Option5,
                        ],
                      ),

                      // Step 8: Question 2 - Investment Knowledge
                      SignupStepQuestionnaire(
                        questionNumber: 2,
                        questionTitle: FinTexts.question2Title,
                        options: [
                          FinTexts.question2Option1,
                          FinTexts.question2Option2,
                          FinTexts.question2Option3,
                          FinTexts.question2Option4,
                        ],
                      ),

                      // Step 9: Question 3 - Decision Style
                      SignupStepQuestionnaire(
                        questionNumber: 3,
                        questionTitle: FinTexts.question3Title,
                        options: [
                          FinTexts.question3Option1,
                          FinTexts.question3Option2,
                          FinTexts.question3Option3,
                          FinTexts.question3Option4,
                        ],
                      ),

                      // Step 10: Question 4 - Risk Profile
                      SignupStepQuestionnaire(
                        questionNumber: 4,
                        questionTitle: FinTexts.question4Title,
                        questionSubtitle: FinTexts.question4Subtitle,
                        options: [
                          FinTexts.question4Option1,
                          FinTexts.question4Option2,
                          FinTexts.question4Option3,
                        ],
                      ),

                      // Step 11: Final Welcome Screen
                      SignupStepQuestionnaireFinal(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  PreferredSizeWidget _buildAppBar(
      SignupController controller, bool dark, BuildContext context) {
    return AppBar(
      // Conditionally show back button
      leading: Obx(() {
        // Hide on Steps 5 & 6 (success + questionnaire intro)
        if (controller.currentStep.value == 5 || controller.currentStep.value == 6 || controller.currentStep.value == 11) {
          return const SizedBox.shrink(); // No back button
        }

        // Show on all other steps
        return IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: dark ? Colors.white : Colors.black,
          ),
          onPressed: () => controller.handleBackNavigation(context),
        );
      }),
      automaticallyImplyLeading: false, // Important!
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }

  Widget _buildProgressIndicator(SignupController controller) {
    return Obx(() => controller.shouldShowProgressIndicator()
        ? const SignupProgressIndicator()
        : const SizedBox.shrink());
  }
}