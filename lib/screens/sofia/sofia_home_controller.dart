// lib/screens/sofia/sofia_home_controller.dart

import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import '../../services/session_manager.dart';
import '../../utils/constants/text_strings.dart';

/// Controller for Sofia Home Screen
/// Handles welcome screen state and user greeting
class SofiaHomeController extends GetxController {
  static SofiaHomeController get instance => Get.find();

  // ═══════════════════════════════════════════════════════════════
  // STATE
  // ═══════════════════════════════════════════════════════════════

  final RxBool isLoading = false.obs;
  final RxString userName = FinTexts.sofiaDefaultUserName.obs;

  // ═══════════════════════════════════════════════════════════════
  // LIFECYCLE
  // ═══════════════════════════════════════════════════════════════

  @override
  void onInit() {
    super.onInit();
    initializeUser();
    if (kDebugMode) print('[SofiaHomeController] Initialized');
  }

  @override
  void onClose() {
    if (kDebugMode) print('[SofiaHomeController] Disposed');
    super.onClose();
  }

  // ═══════════════════════════════════════════════════════════════
  // METHODS
  // ═══════════════════════════════════════════════════════════════

  /// Initialize user data from session
  void initializeUser() {
    try {
      final sessionManager = Get.find<SessionManager>();

      if (sessionManager.currentUser.value != null) {
        final email = sessionManager.currentUser.value!.email;
        if (email != null) {
          final emailPart = email.split('@')[0];
          userName.value = _capitalizeFirstLetter(emailPart);
        }
        if (kDebugMode) print('[SofiaHomeController] User initialized: ${userName.value}');
      }
    } catch (e) {
      if (kDebugMode) print('[SofiaHomeController] Error initializing user: $e');
    }
  }

  /// Handle suggestion card tap
  void onSuggestionTap(String suggestion) {
    if (kDebugMode) print('[SofiaHomeController] Suggestion tapped: $suggestion');
  }

  // ═══════════════════════════════════════════════════════════════
  // HELPERS
  // ═══════════════════════════════════════════════════════════════

  String _capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  String get greetingMessage =>
      '${FinTexts.sofiaGreetingHello} ${userName.value}, ${FinTexts.sofiaGreetingQuestion}';
}