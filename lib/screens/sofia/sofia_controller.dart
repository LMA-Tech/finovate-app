// lib/screens/sofia/sofia_controller.dart

import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import '../../services/session_manager.dart';
import '../../utils/constants/text_strings.dart';

/// Simplified SofIA Controller for basic functionality
///
/// Keeps your existing response logic while working with the simple chat UI
class SofiaController extends GetxController {
  static SofiaController get instance => Get.find();

  // ═══════════════════════════════════════════════════════════════════════════════════════
  // STATE MANAGEMENT
  // Observable variables for reactive UI updates
  // ═══════════════════════════════════════════════════════════════════════════════════════

  /// Whether the AI is currently processing a request
  final RxBool isLoading = false.obs;

  /// Current user's name for personalized greeting
  final RxString userName = FinTexts.sofiaDefaultUserName.obs;

  /// Error message if something goes wrong
  final RxString errorMessage = ''.obs;

  // ═══════════════════════════════════════════════════════════════════════════════════════
  // LIFECYCLE METHODS
  // Controller initialization and cleanup
  // ═══════════════════════════════════════════════════════════════════════════════════════

  @override
  void onInit() {
    super.onInit();
    _initializeUser();
    _debugLog(FinTexts.sofiaDebugControllerInit);
  }

  @override
  void onClose() {
    _debugLog(FinTexts.sofiaDebugControllerDisposed);
    super.onClose();
  }

  // ═══════════════════════════════════════════════════════════════════════════════════════
  // CHAT MANAGEMENT
  // Public methods for chat interactions
  // ═══════════════════════════════════════════════════════════════════════════════════════

  /// Generate AI response based on user message
  String generateResponse(String userMessage) {
    String responseContent;

    if (userMessage.toLowerCase().contains('rentabilidade')) {
      responseContent = FinTexts.sofiaResponseRentabilidade;
    } else if (userMessage.toLowerCase().contains('risco')) {
      responseContent = FinTexts.sofiaResponseRisco;
    } else if (userMessage.toLowerCase().contains('descontadas')) {
      responseContent = FinTexts.sofiaResponseDescontadas;
    } else if (userMessage.toLowerCase().contains('frequentes')) {
      responseContent = FinTexts.sofiaResponseFrequentes;
    } else {
      responseContent = FinTexts.sofiaResponseDefault;
    }

    _debugLog('Generated response for: $userMessage');
    return responseContent;
  }

  /// Handle suggestion card taps
  void onSuggestionTap(String suggestion) {
    _debugLog('${FinTexts.sofiaDebugSuggestionTapped}: $suggestion');
    // The chat screen will handle sending the message
  }

  // ═══════════════════════════════════════════════════════════════════════════════════════
  // PRIVATE METHODS
  // Internal helper methods
  // ═══════════════════════════════════════════════════════════════════════════════════════

  /// Initialize user data
  void _initializeUser() {
    try {
      final sessionManager = Get.find<SessionManager>();

      if (sessionManager.currentUser.value != null) {
        // Extract name from email (before @) and capitalize first letter
        final email = sessionManager.currentUser.value!.email;
        if (email != null) {
          final emailPart = email.split('@')[0];
          userName.value = _capitalizeFirstLetter(emailPart);
        } else {
          userName.value = FinTexts.sofiaDefaultUserName;
        }
        _debugLog(FinTexts.sofiaDebugUserInit);
      }
    } catch (e) {
      _debugLog('${FinTexts.sofiaDebugErrorInit}: $e');
      // Keep default user name if session manager fails
    }
  }

  /// Capitalize first letter of a string
  String _capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  /// Debug logging helper
  void _debugLog(String message) {
    if (kDebugMode) {
      print('[SofiaController] $message');
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════════════════
  // GETTERS
  // Public getters for UI state
  // ═══════════════════════════════════════════════════════════════════════════════════════

  /// Get formatted greeting message
  String get greetingMessage =>
      '${FinTexts.sofiaGreetingHello} ${userName.value}, ${FinTexts.sofiaGreetingQuestion}';
}