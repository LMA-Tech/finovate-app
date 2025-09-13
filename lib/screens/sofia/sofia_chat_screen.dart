// lib/screens/sofia/sofia_chat_screen.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

import '../../common/widgets/app_background.dart';
import 'sofia_controller.dart';
import '../../services/activity_tracker.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/sizes.dart';
import '../../utils/constants/text_strings.dart';

/// SofIA Chat Screen - Simple implementation with flutter_chat_ui
///
/// This screen provides professional auto-scrolling chat interface
/// while maintaining all existing SofIA functionality.
class SofiaChatScreen extends StatefulWidget {
  const SofiaChatScreen({super.key});

  @override
  State<SofiaChatScreen> createState() => _SofiaChatScreenState();
}

class _SofiaChatScreenState extends State<SofiaChatScreen> {
  late SofiaController sofiaController;
  final _chatController = InMemoryChatController();
  String? initialMessage;
  bool resumeChat = false;

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  /// Initialize chat with arguments from navigation
  void _initializeChat() {
    final arguments = Get.arguments as Map<String, dynamic>?;

    // Get controller from arguments or find existing one
    sofiaController = arguments?['controller'] ?? Get.find<SofiaController>();

    // Check if we should resume existing chat or start with initial message
    resumeChat = arguments?['resumeChat'] ?? false;
    initialMessage = arguments?['initialMessage'];

    // Send initial message if provided and not resuming
    if (initialMessage != null && !resumeChat) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _sendMessage(initialMessage!);
      });
    }
  }

  /// Send message through both chat UI and Sofia controller
  void _sendMessage(String text) {
    // Add user message to chat UI
    _chatController.insertMessage(
      TextMessage(
        id: '${Random().nextInt(1000000) + 1}',
        authorId: 'user',
        createdAt: DateTime.now().toUtc(),
        text: text,
      ),
    );

    // Trigger Sofia's AI response
    _handleSofiaResponse(text);
  }

  /// Handle Sofia's AI response
  Future<void> _handleSofiaResponse(String userMessage) async {
    try {
      // Simulate AI thinking delay
      await Future.delayed(const Duration(seconds: 2));

      // Generate Sofia's response using existing logic
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

      // Add Sofia's response to chat UI
      _chatController.insertMessage(
        TextMessage(
          id: '${Random().nextInt(1000000) + 1}',
          authorId: 'sofia',
          createdAt: DateTime.now().toUtc(),
          text: responseContent,
        ),
      );
    } catch (e) {
      // Handle error
      print('Error generating Sofia response: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final activityTracker = Get.find<ActivityTracker>();

    return GestureDetector(
      onTap: () => activityTracker.recordActivity(),
      child: AppBackground(
        child: Scaffold(
          // Your existing app bar
          appBar: _buildChatAppBar(),

          // Simple chat interface
          body: Chat(
            chatController: _chatController,
            currentUserId: 'user',
            onMessageSend: _sendMessage,
            resolveUser: (String id) async {
              if (id == 'sofia') {
                return const User(id: 'sofia', name: 'SofIA');
              } else {
                return const User(id: 'user', name: 'Você');
              }
            },
            // Basic dark theme
            backgroundColor: const Color(0xFF1E2332),
          ),
        ),
      ),
    );
  }

  /// Build chat-specific app bar (keeping your existing design)
  PreferredSizeWidget _buildChatAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: true,
      centerTitle: true,
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // AI avatar in title
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: FinColors.primary.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              border: Border.all(
                color: FinColors.primary.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: const Icon(
              Icons.smart_toy,
              size: 14,
              color: FinColors.primary,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            FinTexts.sofiaScreenTitle,
            style: const TextStyle(
              fontSize: FinSizes.fontSizeLg,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
      actions: [
        // Chat options menu
        IconButton(
          onPressed: () => _showChatOptions(),
          icon: const Icon(
            Icons.more_vert,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  /// Show chat options menu (keeping your existing functionality)
  void _showChatOptions() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(FinSizes.defaultSpace),
        decoration: const BoxDecoration(
          color: Color(0xFF2D3245),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(FinSizes.borderRadiusLg),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: FinSizes.lg),

            // Title
            const Text(
              FinTexts.sofiaChatOptionsTitle,
              style: TextStyle(
                fontSize: FinSizes.fontSizeLg,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: FinSizes.lg),

            // Clear chat option
            ListTile(
              leading: const Icon(
                Icons.delete_outline,
                color: FinColors.error,
              ),
              title: const Text(
                FinTexts.sofiaClearChat,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: FinSizes.fontSizeMd,
                ),
              ),
              onTap: () {
                Get.back();
                _showClearChatDialog();
              },
            ),

            // Close option
            ListTile(
              leading: Icon(
                Icons.close,
                color: Colors.white.withValues(alpha: 0.8),
              ),
              title: Text(
                FinTexts.sofiaClose,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: FinSizes.fontSizeMd,
                ),
              ),
              onTap: () => Get.back(),
            ),

            // Safe area padding
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

  /// Show clear chat confirmation dialog
  void _showClearChatDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF2D3245),
        title: const Text(
          FinTexts.sofiaClearChatTitle,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: const Text(
          FinTexts.sofiaClearChatMessage,
          style: TextStyle(
            color: Colors.white70,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              FinTexts.sofiaCancel,
              style: TextStyle(
                color: Colors.white70,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              // Use the correct method for flutter_chat_ui 2.9.0
              // The controller uses set([]) to cle ar all messages
              _chatController.setMessages([]);
            },
            child: const Text(
              FinTexts.sofiaClear,
              style: TextStyle(
                color: FinColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}