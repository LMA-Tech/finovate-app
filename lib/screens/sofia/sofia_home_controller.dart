// lib/screens/sofia/sofia_home_controller.dart

import 'package:get/get.dart';
import '../../services/app_logger.dart';
import '../../services/session_manager.dart';
import '../../utils/constants/text_strings.dart';

/// Controller for Sofia Home Screen
/// Handles welcome screen state and user greeting
class SofiaHomeController extends GetxController {
  static const String _tag = 'SofiaHomeController';
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
    AppLogger.debug('Initialized', tag: _tag);
  }

  @override
  void onClose() {
    AppLogger.debug('Disposed', tag: _tag);
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
        AppLogger.debug('User initialized: ${userName.value}', tag: _tag);
      }
    } catch (e) {
      AppLogger.error('Error initializing user', error: e, tag: _tag);
    }
  }

  /// Handle suggestion card tap
  void onSuggestionTap(String suggestion) {
    AppLogger.debug('Suggestion tapped: $suggestion', tag: _tag);
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