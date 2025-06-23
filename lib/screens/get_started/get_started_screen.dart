import 'package:finovate_app/common/widgets/app_background.dart';
import 'package:finovate_app/screens/get_started/widgets/get_started_buttons.dart';
import 'package:finovate_app/screens/get_started/widgets/get_started_logo.dart';
import 'package:finovate_app/screens/get_started/widgets/get_started_message.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:finovate_app/utils/constants/sizes.dart';
import '../../services/activity_tracker.dart';
import 'get_started_controller.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(GetStartedController());
    final activityTracker = Get.find<ActivityTracker>();

    return GestureDetector(
        onTap: () => activityTracker.recordActivity(),
        child: const AppBackground(
      child: Stack(
        children: [
          // Main content
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(FinSizes.defaultSpace),
              child: Column(
                children: [
                  // Logo section (pushed to top with SizedBox)
                  SizedBox(height: FinSizes.pushToTop),
                  Center(child: GetStartedLogo()),

                  // Spacer to push content to bottom
                  Spacer(),

                  // Bottom section with text and buttons
                  Column(
                    children: [
                      // Welcome message
                      GetStartedMessage(),

                      SizedBox(height: FinSizes.largeSpaceBtwSections),

                      // Action buttons
                      GetStartedButtons(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
