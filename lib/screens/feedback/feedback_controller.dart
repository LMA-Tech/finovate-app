import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Controller for the 4-step feedback flow
class FeedbackController extends GetxController {
  /// Current step in the flow (0-3)
  final currentStep = 0.obs;

  /// Star rating (1-5)
  final rating = 0.obs;

  /// Selected focus areas (multi-select)
  final selectedFocusAreas = <String>[].obs;

  /// Additional comments text controller
  final commentsController = TextEditingController();

  /// Loading state for submission
  final isSubmitting = false.obs;

  /// Available focus areas for selection (matching Figma design)
  final focusAreas = [
    FocusArea(
      id: 'charts',
      title: 'Aprimoramento de gráficos',
    ),
    FocusArea(
      id: 'navigation',
      title: 'Navegação',
    ),
    FocusArea(
      id: 'crypto',
      title: 'Criptoativos',
    ),
    FocusArea(
      id: 'taxes',
      title: 'Imposto de renda',
    ),
    FocusArea(
      id: 'portfolio_analysis',
      title: 'Análises sobre seu portfólio',
    ),
    FocusArea(
      id: 'ai',
      title: 'IA',
    ),
    FocusArea(
      id: 'international',
      title: 'Mercado internacional',
    ),
    FocusArea(
      id: 'news',
      title: 'Notícias',
    ),
  ];

  /// Set the star rating
  void setRating(int value) {
    rating.value = value;
  }

  /// Toggle a focus area selection
  void toggleFocusArea(String areaId) {
    if (selectedFocusAreas.contains(areaId)) {
      selectedFocusAreas.remove(areaId);
    } else {
      selectedFocusAreas.add(areaId);
    }
  }

  /// Check if a focus area is selected
  bool isFocusAreaSelected(String areaId) {
    return selectedFocusAreas.contains(areaId);
  }

  /// Navigate to next step
  void nextStep() {
    if (currentStep.value < 3) {
      currentStep.value++;
    }
  }

  /// Navigate to previous step
  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  /// Check if can proceed from current step
  bool get canProceed {
    switch (currentStep.value) {
      case 0:
        return rating.value > 0;
      case 1:
        return selectedFocusAreas.isNotEmpty;
      case 2:
        return true; // Comments are optional
      default:
        return false;
    }
  }

  /// Submit the feedback
  Future<void> submitFeedback() async {
    isSubmitting.value = true;

    // TODO: Replace with actual API call
    await Future.delayed(const Duration(seconds: 1));

    isSubmitting.value = false;
    currentStep.value = 3; // Go to success screen
  }

  /// Reset the controller state
  void reset() {
    currentStep.value = 0;
    rating.value = 0;
    selectedFocusAreas.clear();
    commentsController.clear();
  }

  @override
  void onClose() {
    commentsController.dispose();
    super.onClose();
  }
}

/// Model for focus area options
class FocusArea {
  final String id;
  final String title;

  FocusArea({
    required this.id,
    required this.title,
  });
}
