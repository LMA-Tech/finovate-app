import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/widgets/app_background.dart';
import '../../common/widgets/custom_appbar.dart';
import '../../services/activity_tracker.dart';
import '../../utils/helpers/helper_functions.dart';
import 'forgot_password_controller.dart';
import 'widgets/forgot_password_step_1.dart';
import 'widgets/forgot_password_step_2.dart';
import 'widgets/forgot_password_step_3.dart';
import 'widgets/forgot_password_step_4.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgotPasswordController());
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
              Expanded(
                child: PageView(
                  controller: controller.pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: const [
                    ForgotPasswordStep1(),
                    ForgotPasswordStep2(),
                    ForgotPasswordStep3(),
                    ForgotPasswordStep4(),
                  ],
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
      ForgotPasswordController controller, bool dark, BuildContext context) {
    final hideBackButton = controller.currentStep.value == 3;

    return CustomAppBar(
      showBackButton: !hideBackButton,
      onBackPressed: () => controller.handleBackNavigation(context),
    );
  }
}