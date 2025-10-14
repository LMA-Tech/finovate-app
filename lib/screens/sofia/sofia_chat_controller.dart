// lib/screens/sofia/sofia_chat_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../services/finovate_api_service.dart';

/// Controller for Sofia Chat Screen
/// Handles backend chat integration with streaming responses
class SofiaChatController extends GetxController {
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

  // ═══════════════════════════════════════════════════════════════
  // LIFECYCLE
  // ═══════════════════════════════════════════════════════════════

  @override
  void onInit() {
    super.onInit();
    loadSessions();
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

  /// Load existing sessions on startup
  Future<void> loadSessions() async {
    try {
      final correlationId = _uuid.v4();
      final sessions = await FinovateApiService.getChatSessions(
        correlationId: correlationId,
      );
      if (sessions.isNotEmpty) {
        currentSessionId.value = sessions.first.sessionId;
        debugPrint('📋 Loaded session [correlationId: $correlationId]');
      }
    } catch (e) {
      debugPrint('❌ Failed to load sessions: $e');
    }
  }

  /// Send message to backend
  Future<void> sendMessage() async {
    final messageText = messageController.text.trim();
    if (messageText.isEmpty || isLoading.value) return;

    messageController.clear();
    final correlationId = _uuid.v4();
    debugPrint('🔗 Sending message [correlationId: $correlationId]');

    // Add user message
    messages.add(ChatMessage(
      text: messageText,
      isUser: true,
      timestamp: DateTime.now(),
    ));
    isLoading.value = true;
    streamingBuffer.value = '';

    // Create session if needed
    if (currentSessionId.value == null) {
      try {
        final session = await FinovateApiService.createChatSession(
          title: messageText.substring(0, messageText.length > 30 ? 30 : messageText.length),
          correlationId: correlationId,
        );
        currentSessionId.value = session.sessionId;
        debugPrint('✅ Created session [correlationId: $correlationId]');
      } catch (e) {
        isLoading.value = false;
        messages.add(ChatMessage(
          text: 'Failed to create session: $e',
          isUser: false,
          isError: true,
          timestamp: DateTime.now(),
        ));
        return;
      }
    }

    // Add streaming placeholder
    messages.add(ChatMessage(
      text: '',
      isUser: false,
      isStreaming: true,
      timestamp: DateTime.now(),
    ));

    scrollToBottom();

    // Stream response from backend
    try {
      final stream = await FinovateApiService.streamChatMessage(
        message: messageText,
        sessionId: currentSessionId.value,
        correlationId: correlationId,
      );

      // Listen to stream
      await for (final chunk in stream) {
        if (chunk.event == 'token') {
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
          debugPrint('✅ Stream completed [correlationId: $correlationId]');

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
          break;
        } else if (chunk.event == 'error') {
          throw Exception(chunk.message ?? 'Stream error');
        }
      }
    } catch (e) {
      debugPrint('❌ Stream error [correlationId: $correlationId]: $e');

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