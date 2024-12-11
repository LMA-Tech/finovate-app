import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../login/login_screen.dart';

class OnBoardingController extends GetxController
    with GetSingleTickerProviderStateMixin {
  static OnBoardingController get instance => Get.find();

  /// Variables
  final pageController = PageController();
  Rx<int> currentPageIndex =
      0.obs; //Rx type is defined to indicate state change
  late final AnimationController
      animationController; // Manages Lottie animations

  /// Set immersive mode when the controller is initialized
  @override
  void onInit() {
    super.onInit();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: []);
    animationController = AnimationController(vsync: this);
  }

  /// Reset system UI mode when the controller is disposed
  @override
  void onClose() {
    animationController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
        overlays: SystemUiOverlay.values);
    super.onClose();
  }

  /// Play Lottie animation
  void playAnimation(Duration fullDuration) {
    animationController.duration = fullDuration;

    // Play the animation fully and stop
    animationController.forward().then((_) {
      animationController.stop(); // Stop at the end
    });
  }

  /// Reset Lottie animation
  void resetAnimation() {
    animationController.stop();
    animationController.reset();
  }

  /// Update Current Index when Page Scroll
  void updatePageIndicator(index, Duration fullDuration) {
    currentPageIndex.value = index;
    // Reset and play the animation for the new page
    resetAnimation();
    playAnimation(fullDuration);
  }

  /// Jump to specific dot selected page
  void dotNavigationClick(index) {
    currentPageIndex.value = index;
    resetAnimation(); // Reset the current animation
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  /// Update Current Index & jump to next page
  void nextPage(Duration fullDuration) {
    if (currentPageIndex.value == 2) {
      Get.offAll(const LoginScreen());
    } else {
      int page = currentPageIndex.value + 1;
      resetAnimation(); // Reset the current animation
      playAnimation(fullDuration); // Play the animation for the next page
      pageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 300), // Smooth transition
        curve: Curves.easeInOut,
      );
    }
  }

  /// Update Current Index & jump to last page
  void skipPage() {
    currentPageIndex.value = 2;
    pageController.animateToPage(
      2,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
