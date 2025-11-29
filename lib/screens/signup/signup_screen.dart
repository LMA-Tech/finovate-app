import 'package:finovate_app/common/widgets/app_background.dart';
import 'package:finovate_app/screens/signup/widgets/signup_milestone_screen.dart';
import 'package:finovate_app/screens/signup/widgets/signup_form_personal_info.dart';
import 'package:finovate_app/screens/signup/widgets/signup_verification_method.dart';
import 'package:finovate_app/screens/signup/widgets/signup_verification_otp.dart';
import 'package:finovate_app/screens/signup/widgets/signup_questionnaire_steps.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/widgets/custom_appbar.dart';
import '../../services/activity_tracker.dart';
import '../../services/session_manager.dart';
import '../../utils/constants/image_strings.dart';
import '../../utils/constants/routes.dart';
import '../../utils/helpers/helper_functions.dart';
import '../../utils/constants/text_strings.dart';
import 'signup_controller.dart';
import 'widgets/signup_progress_indicator.dart';
import 'widgets/signup_form_email_password.dart';
import 'widgets/signup_form_name.dart';

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
          child: Obx(() => Scaffold(
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
                    children: [  // ← This was missing!
                      // Original signup steps (0-5)
                      const SignupFormEmailPassword(), // Step 0: Email/Password
                      const SignupFormName(), // Step 1: Name
                      const SignupFormPersonalInfo(), // Step 2: CPF/Phone/Birthdate
                      const SignupVerificationMethod(), // Step 3: Verification Method
                      const SignupVerificationOtp(), // Step 4: OTP Code

                      // Step 5: Success Screen
                      Builder(
                        builder: (context) {
                          final controller = Get.find<SignupController>();
                          final firstName = controller.step2Form.control('firstName').value ?? 'Usuário';

                          return SignupMilestoneScreen(
                            logoHeight: 40,
                            illustration: FinImages.trophySuccess,
                            title: 'Conta criada com sucesso, $firstName!',
                            subtitle: FinTexts.signupFinalSubtitle,
                            buttonText: FinTexts.signupFinalbutton,
                            showButtonArrow: false,
                            onButtonPressed: () => controller.nextStep(),
                          );
                        },
                      ),

                      // Step 6: Questionnaire Intro
                      Builder(
                        builder: (context) {
                          final controller = Get.find<SignupController>();

                          return SignupMilestoneScreen(
                            logoHeight: 40,
                            illustration: FinImages.questionnaireStart,
                            title: FinTexts.questionnaireIntroTitle,
                            subtitle: FinTexts.questionnaireIntroSubtitle,
                            buttonText: FinTexts.questionnaireIntroButton,
                            showButtonArrow: false,
                            onButtonPressed: () => controller.nextStep(),
                          );
                        },
                      ),

                      // Step 7: Question 1 - Wealth Range
                      const SignupStepQuestionnaire(
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
                      const SignupStepQuestionnaire(
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
                      const SignupStepQuestionnaire(
                        questionNumber: 3,
                        questionTitle: FinTexts.question3Title,
                        options: [
                          FinTexts.question3Option1,
                          FinTexts.question3Option2,
                          FinTexts.question3Option3,
                          FinTexts.question3Option4,
                        ],
                      ),

                      // Step 10: Question 4 - Risk Profile (LAST QUESTION - submits on completion)
                      const SignupStepQuestionnaire(
                        questionNumber: 4,
                        questionTitle: FinTexts.question4Title,
                        questionSubtitle: FinTexts.question4Subtitle,
                        options: [
                          FinTexts.question4Option1,
                          FinTexts.question4Option2,
                          FinTexts.question4Option3,
                        ],
                        isLastQuestion: true, // ← Triggers submission
                      ),

                      // Step 11: Final Welcome Screen
                      Builder(
                        builder: (context) {
                          final controller = Get.find<SignupController>();
                          final firstName = controller.step2Form.control('firstName').value ?? 'usuário';

                          return SignupMilestoneScreen(
                            logoHeight: 200, // Large logo for final screen
                            illustration: null, // No illustration
                            title: FinTexts.questionnaireWelcomeTitle.replaceAll('{NAME}', firstName),
                            subtitle: FinTexts.questionnaireWelcomeSubtitle,
                            buttonText: FinTexts.questionnaireWelcomeButton,
                            showButtonArrow: false,
                            onButtonPressed: () {
                              // Mark signup flow as complete
                              Get.find<SessionManager>().isInSignupFlow.value = false;
                              // Navigate to home
                              Get.offAllNamed(AppRoutes.home);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
        ));
  }

  PreferredSizeWidget _buildAppBar(
      SignupController controller, bool dark, BuildContext context) {
    // Get reactive value directly
    final hideBackButton = [5, 6, 11].contains(controller.currentStep.value);

    return CustomAppBar(
      showBackButton: !hideBackButton,
      onBackPressed: () => controller.handleBackNavigation(context),
    );
  }

  Widget _buildProgressIndicator(SignupController controller) {
    return Obx(() => controller.shouldShowProgressIndicator()
        ? const SignupProgressIndicator()
        : const SizedBox.shrink());
  }
}