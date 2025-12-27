// lib/screens/sofia/sofia_home_controller.dart

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../services/app_logger.dart';
import '../../services/finovate_api_service.dart';
import '../../services/session_manager.dart';
import '../../utils/constants/text_strings.dart';

/// Controller for Sofia Home Screen
/// Handles welcome screen state, user greeting, and usage stats
class SofiaHomeController extends GetxController {
  static const String _tag = 'SofiaHomeController';
  static SofiaHomeController get instance => Get.find();

  final _uuid = const Uuid();

  // ═══════════════════════════════════════════════════════════════
  // STATE
  // ═══════════════════════════════════════════════════════════════

  final RxBool isLoading = false.obs;
  final RxString userName = FinTexts.sofiaDefaultUserName.obs;

  // Usage stats
  final Rx<SofiaUsage?> usage = Rx<SofiaUsage?>(null);
  final RxBool isLoadingUsage = false.obs;

  // Chat sessions
  final RxList<ChatSession> sessions = <ChatSession>[].obs;

  // ═══════════════════════════════════════════════════════════════
  // LIFECYCLE
  // ═══════════════════════════════════════════════════════════════

  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  Future<void> _initialize() async {
    initializeUser();
    // Load usage and sessions in parallel
    await Future.wait([
      loadUsage(),
      loadSessions(),
    ]);
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

  /// Load user's daily usage stats
  Future<void> loadUsage() async {
    try {
      isLoadingUsage.value = true;
      final correlationId = _uuid.v4();
      usage.value = await FinovateApiService.getSofiaUsage(
        correlationId: correlationId,
      );
      AppLogger.debug(
        'Loaded usage: ${usage.value?.usedToday}/${usage.value?.dailyLimit}',
        tag: _tag,
      );
    } catch (e) {
      AppLogger.error('Failed to load usage', error: e, tag: _tag);
    } finally {
      isLoadingUsage.value = false;
    }
  }

  /// Load existing chat sessions
  Future<void> loadSessions() async {
    try {
      final correlationId = _uuid.v4();
      sessions.value = await FinovateApiService.getChatSessions(
        correlationId: correlationId,
      );
      AppLogger.debug('Loaded ${sessions.length} sessions', tag: _tag);
    } catch (e) {
      AppLogger.error('Failed to load sessions', error: e, tag: _tag);
    }
  }

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

  /// Get usage display text (e.g., "3 de 5 perguntas restantes")
  String get usageDisplayText {
    if (usage.value == null) return '';
    if (usage.value!.isPro) return 'Plano Pro - ilimitado';
    final remaining = usage.value!.remaining ?? 0;
    final limit = usage.value!.dailyLimit ?? 5;
    return '$remaining de $limit perguntas restantes';
  }

  /// Check if user has reached daily limit
  bool get hasReachedLimit => usage.value?.hasReachedLimit ?? false;
}