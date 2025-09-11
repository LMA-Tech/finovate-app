// lib/controllers/sofia_controller.dart

import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import '../../services/session_manager.dart';
import '../../utils/constants/text_strings.dart';

/// Controller for managing SofIA AI chat interface state
///
/// Handles chat messages, user interactions, AI responses, and screen state
/// for the SofIA assistant. Integrates with session management for user data.
class SofiaController extends GetxController {
  static SofiaController get instance => Get.find();

  // ═══════════════════════════════════════════════════════════════════════════════════════
  // STATE MANAGEMENT
  // Observable variables for reactive UI updates
  // ═══════════════════════════════════════════════════════════════════════════════════════

  /// Whether the AI is currently processing a request
  final RxBool isLoading = false.obs;

  /// Whether the chat has started (messages exist)
  final RxBool hasChatStarted = false.obs;

  /// Current user's name for personalized greeting
  final RxString userName = FinTexts.sofiaDefaultUserName.obs; // Use constant default

  /// List of chat messages
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;

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
  // USER MANAGEMENT
  // Handle user data and personalization
  // ═══════════════════════════════════════════════════════════════════════════════════════

  /// Initialize user data from session or defaults
  void _initializeUser() {
    try {
      // Get user data from SessionManager
      final sessionManager = Get.find<SessionManager>();
      final user = sessionManager.currentUser.value;

      if (user != null && user.email != null) {
        // Extract name from email (before @) and capitalize first letter
        final emailPart = user.email!.split('@')[0];
        userName.value = _capitalizeFirstLetter(emailPart);
      } else {
        userName.value = FinTexts.sofiaDefaultUserName;
      }

      _debugLog('${FinTexts.sofiaDebugUserInit}: ${userName.value}');
    } catch (e) {
      _debugLog('${FinTexts.sofiaDebugErrorInit}: $e');
      userName.value = FinTexts.sofiaDefaultUserName; // Fallback to constant
    }
  }

  /// Capitalize first letter of a string
  String _capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  // ═══════════════════════════════════════════════════════════════════════════════════════
  // CHAT FUNCTIONALITY
  // Handle message sending, receiving, and chat state
  // ═══════════════════════════════════════════════════════════════════════════════════════

  /// Send a message to the AI assistant
  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty || isLoading.value) return;

    try {
      // Clear any previous errors
      errorMessage.value = '';

      // Add user message to chat
      final userMessage = ChatMessage(
        content: message.trim(),
        isFromUser: true,
        timestamp: DateTime.now(),
      );

      messages.add(userMessage);
      hasChatStarted.value = true;

      _debugLog('${FinTexts.sofiaDebugUserMessageAdded}: ${message.trim()}');

      // Start loading state
      isLoading.value = true;

      // Simulate AI response (replace with actual API call)
      await _simulateAIResponse(message.trim());

    } catch (e) {
      _debugLog('${FinTexts.sofiaDebugErrorSending}: $e');
      errorMessage.value = FinTexts.sofiaErrorMessage;
    } finally {
      isLoading.value = false;
    }
  }

  /// Handle suggestion card taps
  void onSuggestionTap(String suggestion) {
    _debugLog('${FinTexts.sofiaDebugSuggestionTapped}: $suggestion');
    sendMessage(suggestion);
  }

  /// Simulate AI response (replace with actual API integration)
  Future<void> _simulateAIResponse(String userMessage) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Generate mock response based on user message
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

    // Add AI response to chat
    final aiMessage = ChatMessage(
      content: responseContent,
      isFromUser: false,
      timestamp: DateTime.now(),
    );

    messages.add(aiMessage);
    _debugLog(FinTexts.sofiaDebugAIResponseAdded);
  }

  /// Clear chat history
  void clearChat() {
    messages.clear();
    hasChatStarted.value = false;
    errorMessage.value = '';
    _debugLog(FinTexts.sofiaDebugChatCleared);
  }

  /// Retry last message if there was an error
  void retryLastMessage() {
    if (messages.isNotEmpty && messages.last.isFromUser) {
      final lastMessage = messages.last.content;
      sendMessage(lastMessage);
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════════════════
  // UTILITY METHODS
  // Helper functions and debugging
  // ═══════════════════════════════════════════════════════════════════════════════════════

  /// Debug logging helper
  void _debugLog(String message) {
    if (kDebugMode) {
      print('[SofiaController] $message');
    }
  }

  /// Get formatted greeting message
  String get greetingMessage => '${FinTexts.sofiaGreetingHello} ${userName.value}, ${FinTexts.sofiaGreetingQuestion}';

  /// Check if there are any messages
  bool get hasMessages => messages.isNotEmpty;

  /// Get the last message timestamp for UI updates
  DateTime? get lastMessageTime => messages.isNotEmpty ? messages.last.timestamp : null;
}

/// Model class for chat messages
class ChatMessage {
  /// The text content of the message
  final String content;

  /// Whether the message is from the user (true) or AI (false)
  final bool isFromUser;

  /// When the message was created
  final DateTime timestamp;

  /// Unique identifier for the message
  final String id;

  ChatMessage({
    required this.content,
    required this.isFromUser,
    required this.timestamp,
    String? id,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  /// Create a copy of the message with updated fields
  ChatMessage copyWith({
    String? content,
    bool? isFromUser,
    DateTime? timestamp,
    String? id,
  }) {
    return ChatMessage(
      content: content ?? this.content,
      isFromUser: isFromUser ?? this.isFromUser,
      timestamp: timestamp ?? this.timestamp,
      id: id ?? this.id,
    );
  }

  /// Convert message to JSON for storage/API calls
  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'isFromUser': isFromUser,
      'timestamp': timestamp.toIso8601String(),
      'id': id,
    };
  }

  /// Create message from JSON
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      content: json['content'] as String,
      isFromUser: json['isFromUser'] as bool,
      timestamp: DateTime.parse(json['timestamp'] as String),
      id: json['id'] as String,
    );
  }

  @override
  String toString() {
    return 'ChatMessage(id: $id, isFromUser: $isFromUser, content: ${content.substring(0, content.length > 50 ? 50 : content.length)}...)';
  }
}