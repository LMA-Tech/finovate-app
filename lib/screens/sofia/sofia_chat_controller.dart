// lib/screens/sofia/sofia_chat_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../services/app_logger.dart';
import '../../services/finovate_api_service.dart';

/// Controller for Sofia Chat Screen
/// Handles backend chat integration with streaming responses
///
/// Session Flow (per API contract):
/// 1. First message: Don't pass session_id → backend auto-creates one
/// 2. Capture session_id from first SSE event (event: "session")
/// 3. Subsequent messages: Always pass session_id to continue conversation
/// 4. New conversation: Clear session_id → gets a new one
class SofiaChatController extends GetxController {
  static const String _tag = 'SofiaChatController';
  static SofiaChatController get instance => Get.find();

  // ═══════════════════════════════════════════════════════════════
  // CONTROLLERS & STATE
  // ═══════════════════════════════════════════════════════════════

  final messageController = TextEditingController();
  final scrollController = ScrollController();
  final _uuid = const Uuid();

  final RxBool isLoading = false.obs;
  final RxString streamingBuffer = ''.obs;
  final RxnString currentSessionId = RxnString();
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;

  // Usage stats
  final Rx<SofiaUsage?> usage = Rx<SofiaUsage?>(null);
  final RxBool isLoadingUsage = false.obs;

  // ═══════════════════════════════════════════════════════════════
  // LIFECYCLE
  // ═══════════════════════════════════════════════════════════════

  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  Future<void> _initialize() async {
    // Load usage stats and sessions in parallel
    await Future.wait([
      loadUsage(),
      loadSessions(),
    ]);

    // Check if there's an initial message to send
    final args = Get.arguments;
    if (args != null && args is Map && args.containsKey('initialMessage')) {
      final initialMessage = args['initialMessage'] as String?;
      if (initialMessage != null && initialMessage.isNotEmpty) {
        AppLogger.debug('Received initial message: $initialMessage', tag: _tag);
        // Wait a moment for UI to build, then send message
        Future.delayed(const Duration(milliseconds: 500), () {
          messageController.text = initialMessage;
          sendMessage();
        });
      }
    }

    // Check if resuming an existing session
    if (args != null && args is Map && args.containsKey('sessionId')) {
      final sessionId = args['sessionId'] as String?;
      if (sessionId != null && sessionId.isNotEmpty) {
        await loadSessionMessages(sessionId);
      }
    }
  }
  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
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
        'Loaded usage: ${usage.value?.usedToday}/${usage.value?.dailyLimit} [correlationId: $correlationId]',
        tag: _tag,
      );
    } catch (e) {
      AppLogger.error('Failed to load usage', error: e, tag: _tag);
    } finally {
      isLoadingUsage.value = false;
    }
  }

  /// Load existing sessions on startup
  Future<void> loadSessions() async {
    try {
      final correlationId = _uuid.v4();
      final sessions = await FinovateApiService.getChatSessions(
        correlationId: correlationId,
      );
      AppLogger.debug('Loaded ${sessions.length} sessions [correlationId: $correlationId]', tag: _tag);
    } catch (e) {
      AppLogger.error('Failed to load sessions', error: e, tag: _tag);
    }
  }

  /// Load messages for a specific session (when resuming a conversation)
  Future<void> loadSessionMessages(String sessionId) async {
    try {
      isLoading.value = true;
      final correlationId = _uuid.v4();
      final sessionMessages = await FinovateApiService.getSessionMessages(
        sessionId,
        correlationId: correlationId,
      );

      currentSessionId.value = sessionId;
      messages.clear();

      for (final msg in sessionMessages.messages) {
        messages.add(ChatMessage(
          text: msg.content,
          isUser: msg.isUser,
          timestamp: msg.timestamp,
        ));
      }

      AppLogger.debug(
        'Loaded ${sessionMessages.messageCount} messages for session $sessionId',
        tag: _tag,
      );
      scrollToBottom();
    } catch (e) {
      AppLogger.error('Failed to load session messages', error: e, tag: _tag);
    } finally {
      isLoading.value = false;
    }
  }

  /// Send message to backend
  /// Session is auto-created by backend on first message
  Future<void> sendMessage() async {
    final messageText = messageController.text.trim();
    if (messageText.isEmpty || isLoading.value) return;

    // Check if user has reached daily limit
    if (usage.value?.hasReachedLimit == true) {
      messages.add(ChatMessage(
        text: 'Você atingiu o limite diário de perguntas. Volte amanhã ou faça upgrade para o plano Pro.',
        isUser: false,
        isError: true,
        timestamp: DateTime.now(),
      ));
      scrollToBottom();
      return;
    }

    messageController.clear();
    final correlationId = _uuid.v4();
    AppLogger.debug('Sending message [correlationId: $correlationId]', tag: _tag);

    // Add user message
    messages.add(ChatMessage(
      text: messageText,
      isUser: true,
      timestamp: DateTime.now(),
    ));
    isLoading.value = true;
    streamingBuffer.value = '';

    // Add streaming placeholder
    messages.add(ChatMessage(
      text: '',
      isUser: false,
      isStreaming: true,
      timestamp: DateTime.now(),
    ));

    scrollToBottom();

    // Stream response from backend
    // Note: Session is auto-created by backend on first message if sessionId is null
    try {
      final stream = await FinovateApiService.streamChatMessage(
        message: messageText,
        sessionId: currentSessionId.value,
        correlationId: correlationId,
      );

      // Listen to stream
      await for (final chunk in stream) {
        // Handle session event (first event when new session is created)
        if (chunk.event == 'session') {
          final newSessionId = chunk.sessionId;
          if (newSessionId != null) {
            currentSessionId.value = newSessionId;
            AppLogger.info('Session auto-created: $newSessionId', tag: _tag);
          }
        } else if (chunk.event == 'token') {
          final token = chunk.chunk ?? '';
          streamingBuffer.value += token;

          if (messages.isNotEmpty && messages.last.isStreaming) {
            messages[messages.length - 1] = ChatMessage(
              text: streamingBuffer.value,
              isUser: false,
              isStreaming: true,
              timestamp: messages.last.timestamp,
            );
          }
          scrollToBottom();
        } else if (chunk.event == 'end') {
          AppLogger.debug('Stream completed [correlationId: $correlationId]', tag: _tag);

          isLoading.value = false;
          if (messages.isNotEmpty && messages.last.isStreaming) {
            messages[messages.length - 1] = ChatMessage(
              text: streamingBuffer.value.isEmpty ? '(empty response)' : streamingBuffer.value,
              isUser: false,
              isStreaming: false,
              timestamp: messages.last.timestamp,
            );
          }
          streamingBuffer.value = '';
          scrollToBottom();

          // Refresh usage after successful message
          loadUsage();
          break;
        } else if (chunk.event == 'error') {
          throw Exception(chunk.message ?? 'Stream error');
        }
      }
    } catch (e) {
      AppLogger.error('Stream error [correlationId: $correlationId]', error: e, tag: _tag);

      isLoading.value = false;
      if (messages.isNotEmpty && messages.last.isStreaming) {
        messages.removeLast();
      }
      messages.add(ChatMessage(
        text: 'Error: $e',
        isUser: false,
        isError: true,
        timestamp: DateTime.now(),
      ));
      streamingBuffer.value = '';
      scrollToBottom();
    }
  }

  /// Clear chat history
  void clearChat() {
    messages.clear();
    currentSessionId.value = null;
  }

  /// Scroll to bottom of messages
  void scrollToBottom() {
    if (scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 50), () {
        if (scrollController.hasClients) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  /// Format time for display
  String formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  /// Get usage display text (e.g., "3 de 5 perguntas restantes")
  String get usageDisplayText {
    if (usage.value == null) return '';
    if (usage.value!.isPro) return 'Plano Pro - ilimitado';
    final remaining = usage.value!.remaining ?? 0;
    final limit = usage.value!.dailyLimit ?? 5;
    return '$remaining de $limit perguntas restantes';
  }

  /// Start a new conversation (clears current session)
  void startNewConversation() {
    messages.clear();
    currentSessionId.value = null;
    streamingBuffer.value = '';
    AppLogger.debug('Started new conversation', tag: _tag);
  }
}

// ═══════════════════════════════════════════════════════════════
// DATA MODELS
// ═══════════════════════════════════════════════════════════════

class ChatMessage {
  final String text;
  final bool isUser;
  final bool isError;
  final bool isStreaming;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    this.isError = false,
    this.isStreaming = false,
    required this.timestamp,
  });
}