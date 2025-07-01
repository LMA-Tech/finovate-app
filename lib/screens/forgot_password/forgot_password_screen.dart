import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/widgets/app_background.dart';
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
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          // Prevent screen resizing when keyboard appears
          appBar: _buildAppBar(controller, dark, context),
          body: Column(
            children: [
              // Main content - swiping disabled
              Expanded(
                child: PageView(
                  controller: controller.pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  // Disable swiping
                  children: const [
                    ForgotPasswordStep1(),
                    ForgotPasswordStep2(),
                    // ForgotPasswordStep3(),
                    // ForgotPasswordStep4(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
      ForgotPasswordController controller, bool dark, BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(
          Icons.chevron_left,
          color: dark ? Colors.white : Colors.black,
        ),
        onPressed: () => controller.handleBackNavigation(context),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }
}