import 'package:finovate_app/screens/get_started/get_started_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../services/onboarding_service.dart';

class OnBoardingController extends GetxController {
  static OnBoardingController get instance => Get.find();

  // Constants
  static const int pageCount = 3;
  static const Duration pageTransitionDuration = Duration(milliseconds: 300);
  static const Curve transitionCurve = Curves.easeInOut;

  // Controller variables
  final pageController = PageController();
  final Rx<int> currentPageIndex = 0.obs;

  // Service for tracking onboarding completion
  final OnboardingService _onboardingService = OnboardingService();

  @override
  void onInit() {
    super.onInit();
    // Set immersive mode for fullscreen experience
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: []);
  }

  @override
  void onClose() {
    // Cleanup resources
    pageController.dispose();

    // Restore normal UI mode
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
      overlays: SystemUiOverlay.values,
    );
    super.onClose();
  }

  // Update page indicator
  void updatePageIndicator(int index) {
    currentPageIndex.value = index;
  }

  // Navigate to specific page when dot is clicked
  void dotNavigationClick(int index) {
    currentPageIndex.value = index;

    pageController.animateToPage(
      index,
      duration: pageTransitionDuration,
      curve: transitionCurve,
    );
  }

  // Navigate to next page or login screen
  void nextPage() {
    final bool isLastPage = currentPageIndex.value == pageCount - 1;

    if (isLastPage) {
      _completeOnboarding();
      Get.offAll(() => const GetStartedScreen());
    } else {
      final int nextPage = currentPageIndex.value + 1;

      pageController.animateToPage(
        nextPage,
        duration: pageTransitionDuration,
        curve: transitionCurve,
      );
    }
  }

  // Skip to last page
  void skipPage() {
    _completeOnboarding();

    currentPageIndex.value = pageCount - 1;

    pageController.animateToPage(
      pageCount - 1,
      duration: pageTransitionDuration,
      curve: transitionCurve,
    );
  }

  // Mark onboarding as complete
  void _completeOnboarding() {
    _onboardingService.completeOnboarding();
  }
}