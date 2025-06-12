import 'package:finovate_app/common/widgets/app_background.dart';
import 'package:finovate_app/screens/signup/widgets/signup_step_3.dart';
import 'package:finovate_app/screens/signup/widgets/signup_step_4.dart';
import 'package:finovate_app/screens/signup/widgets/signup_step_5.dart';
import 'package:finovate_app/screens/signup/widgets/signup_step_6.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/helpers/helper_functions.dart';
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

    return AppBackground(
        child: Scaffold(
          resizeToAvoidBottomInset: false, // Prevent screen resizing when keyboard appears
          appBar: _buildAppBar(controller, dark, context),
          body: Column(
            children: [
              // Progress indicator (only show from step 2 onwards)
              _buildProgressIndicator(controller),

              // Main content - swiping disabled
              Expanded(
                child: PageView(
                  controller: controller.pageController,
                  physics: const NeverScrollableScrollPhysics(), // Disable swiping
                  children: const [
                    SignupStep1(),
                    SignupStep2(),
                    SignupStep3(),
                    SignupStep4(),
                    SignupStep5(),
                    SignupStep6(),
                  ],
                ),
              ),
            ],
          ),
        ),
    );
  }

  PreferredSizeWidget _buildAppBar(SignupController controller, bool dark, BuildContext context) {
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

  Widget _buildProgressIndicator(SignupController controller) {
    return Obx(() => controller.shouldShowProgressIndicator()
        ? const SignupProgressIndicator()
        :         const SizedBox.shrink());
  }
}