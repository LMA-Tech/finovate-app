import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/widgets/app_background.dart';
import 'feedback_controller.dart';
import 'widgets/rating_step.dart';
import 'widgets/focus_areas_step.dart';
import 'widgets/comments_step.dart';
import 'widgets/success_step.dart';

/// Main feedback flow screen with 4 steps:
/// 1. Star rating
/// 2. Focus areas selection
/// 3. Additional comments
/// 4. Success confirmation
class FeedbackScreen extends StatelessWidget {
  FeedbackScreen({super.key});

  final controller = Get.put(FeedbackController());

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        appBar: _buildAppBar(),
        body: Obx(() => _buildCurrentStep()),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leadingWidth: 56,
      leading: Obx(() {
        // On success screen (step 3), hide the leading button
        if (controller.currentStep.value >= 3) {
          return const SizedBox.shrink();
        }
        // On first step, show close button
        if (controller.currentStep.value == 0) {
          return IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Get.back(),
          );
        }
        // On other steps, show back arrow
        return IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: controller.previousStep,
        );
      }),
      actions: const [
        // No forward arrow - using bottom buttons for navigation
        SizedBox(width: 48),
      ],
      title: Obx(() => controller.currentStep.value < 3
          ? const SizedBox.shrink() // Title removed per Figma - progress bar shows instead
          : const SizedBox.shrink()),
      centerTitle: true,
    );
  }

  Widget _buildCurrentStep() {
    switch (controller.currentStep.value) {
      case 0:
        return RatingStep(controller: controller);
      case 1:
        return FocusAreasStep(controller: controller);
      case 2:
        return CommentsStep(controller: controller);
      case 3:
        return SuccessStep(controller: controller);
      default:
        return const SizedBox.shrink();
    }
  }
}
