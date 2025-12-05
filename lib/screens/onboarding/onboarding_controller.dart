import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../services/onboarding_service.dart';
import '../../utils/constants/routes.dart';

class OnBoardingController extends GetxController {
  static OnBoardingController get instance => Get.find();

  // Constants
  static const int pageCount = 3;
  static const Duration pageTransitionDuration = Duration(milliseconds: 300);
  static const Curve transitionCurve = Curves.easeInOut;

  // Controller variables
  final pageController = PageController();
  final Rx<int> currentPageIndex = 0.obs;

  // Animation state tracking - prevents UI flickering during transitions
  final RxBool isAnimating = false.obs;

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

  // Update page indicator - called by PageView onPageChanged
  void updatePageIndicator(int index) {
    // Only update if not currently animating programmatically
    if (!isAnimating.value) {
      currentPageIndex.value = index;
    }
  }

  // Navigate to specific page when dot is clicked
  void dotNavigationClick(int index) {
    _animateToPageSafely(index);
  }

  // Navigate to next page or complete onboarding
  void nextPage() {
    final bool isLastPage = currentPageIndex.value == pageCount - 1;

    if (isLastPage) {
      // Complete onboarding and navigate away
      _completeOnboardingAndNavigate();
    } else {
      // Go to next page
      final int nextPage = currentPageIndex.value + 1;
      _animateToPageSafely(nextPage);
    }
  }

  // Skip to last page - fixed to prevent button flickering
  void skipPage() {
    // Don't complete onboarding yet, just go to last page
    _animateToPageSafely(pageCount - 1);
  }

  // Safe animation method - prevents UI flickering
  void _animateToPageSafely(int targetPage) {
    if (isAnimating.value) return; // Prevent multiple simultaneous animations

    isAnimating.value = true;

    pageController.animateToPage(
      targetPage,
      duration: pageTransitionDuration,
      curve: transitionCurve,
    ).then((_) {
      // Update index only after animation completes
      currentPageIndex.value = targetPage;
      isAnimating.value = false;
    });
  }

  // Complete onboarding and navigate - single responsibility
  void _completeOnboardingAndNavigate() {
    _onboardingService.completeOnboarding();
    Get.offAllNamed(AppRoutes.getStarted);
  }
}