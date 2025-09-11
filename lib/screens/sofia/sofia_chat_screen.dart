// lib/screens/sofia/sofia_chat_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/widgets/app_background.dart';
import '../../screens/sofia/widgets/chat_input.dart';
import '../../screens/sofia/sofia_controller.dart';
import '../../services/activity_tracker.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/sizes.dart';
import '../../utils/constants/text_strings.dart';

/// SofIA Chat Screen - Active conversation interface
///
/// This screen handles the active chat conversation with SofIA.
/// Features include message history, real-time messaging, and
/// chat-specific functionality like clearing conversations.
class SofiaChatScreen extends StatefulWidget {
  const SofiaChatScreen({super.key});

  @override
  State<SofiaChatScreen> createState() => _SofiaChatScreenState();
}

class _SofiaChatScreenState extends State<SofiaChatScreen> {
  late SofiaController sofiaController;
  String? initialMessage;
  bool resumeChat = false;

  @override
  void initState() {
    super.initState();
    _initializeChat();
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
        sofiaController.sendMessage(initialMessage!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final activityTracker = Get.find<ActivityTracker>();

    return GestureDetector(
      onTap: () => activityTracker.recordActivity(),
      child: AppBackground(
        child: Scaffold(
          // Chat-specific app bar
          appBar: _buildChatAppBar(),

          body: Column(
            children: [
              // Chat messages area
              Expanded(
                child: _buildChatArea(),
              ),

              // Chat input at bottom
              _buildChatInput(),
            ],
          ),
        ),
      ),
    );
  }

  /// Build chat-specific app bar
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
    ) as PreferredSizeWidget;
  }

  /// Build the chat area with messages
  Widget _buildChatArea() {
    return Obx(() => Column(
      children: [
        // Chat messages list
        Expanded(
          child: sofiaController.messages.isEmpty
              ? _buildEmptyChatState()
              : _buildMessagesList(),
        ),

        // Show error message if any
        if (sofiaController.errorMessage.value.isNotEmpty)
          _buildErrorMessage(),
      ],
    ));
  }

  /// Build the messages list view
  Widget _buildMessagesList() {
    return ListView.builder(
      padding: const EdgeInsets.all(FinSizes.md),
      itemCount: sofiaController.messages.length,
      itemBuilder: (context, index) {
        final message = sofiaController.messages[index];
        return ChatMessageWidget(
          message: message,
          showAvatar: true,
        );
      },
    );
  }

  /// Build empty chat state
  Widget _buildEmptyChatState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(FinSizes.defaultSpace),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 64,
              color: FinColors.darkGrey,
            ),
            SizedBox(height: FinSizes.md),
            Text(
              FinTexts.sofiaChatEmpty,
              style: TextStyle(
                fontSize: FinSizes.fontSizeMd,
                color: FinColors.darkGrey,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Build error message widget
  Widget _buildErrorMessage() {
    return Container(
      margin: const EdgeInsets.all(FinSizes.md),
      padding: const EdgeInsets.all(FinSizes.md),
      decoration: BoxDecoration(
        color: FinColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(FinSizes.borderRadiusMd),
        border: Border.all(
          color: FinColors.error.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline,
            color: FinColors.error,
            size: FinSizes.iconMd,
          ),
          const SizedBox(width: FinSizes.sm),
          Expanded(
            child: Text(
              sofiaController.errorMessage.value,
              style: const TextStyle(
                color: FinColors.error,
                fontSize: FinSizes.fontSizeSm,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              sofiaController.errorMessage.value = '';
              sofiaController.retryLastMessage();
            },
            child: const Text(
              FinTexts.sofiaErrorRetry,
              style: TextStyle(
                color: FinColors.error,
                fontSize: FinSizes.fontSizeSm,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build chat input section
  Widget _buildChatInput() {
    return Obx(() => ChatInput(
      onSendMessage: sofiaController.sendMessage,
      hintText: FinTexts.sofiaChatInputHintActive,
      isEnabled: !sofiaController.isLoading.value,
      isLoading: sofiaController.isLoading.value,
    ));
  }

  /// Show chat options menu
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

            // Share conversation option
            ListTile(
              leading: const Icon(
                Icons.share_outlined,
                color: Colors.white,
              ),
              title: const Text(
                'Compartilhar conversa',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: FinSizes.fontSizeMd,
                ),
              ),
              onTap: () {
                Get.back();
                _shareConversation();
              },
            ),

            // Clear chat option
            if (sofiaController.hasMessages)
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
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          FinTexts.sofiaClearChatMessage,
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              FinTexts.sofiaCancel,
              style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              sofiaController.clearChat();
              // Navigate back to home after clearing
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: FinColors.error,
            ),
            child: const Text(
              FinTexts.sofiaClear,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  /// Share conversation functionality
  void _shareConversation() {
    // TODO: Implement conversation sharing
    Get.snackbar(
      'Em breve',
      'Funcionalidade de compartilhamento estará disponível em breve',
      backgroundColor: FinColors.primary.withValues(alpha: 0.8),
      colorText: Colors.white,
    );
  }
}

/// Reusable Chat Message Widget
///
/// Extracted from the original _buildMessageBubble method
/// for better code organization and reusability
class ChatMessageWidget extends StatelessWidget {
  final ChatMessage message;
  final bool showAvatar;

  const ChatMessageWidget({
    super.key,
    required this.message,
    this.showAvatar = true,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.isFromUser;

    return Padding(
      padding: const EdgeInsets.only(bottom: FinSizes.md),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser && showAvatar) _buildAIAvatar(),
          if (!isUser && showAvatar) const SizedBox(width: FinSizes.sm),

          // Message content
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: FinSizes.md,
                vertical: FinSizes.sm,
              ),
              decoration: BoxDecoration(
                color: isUser
                    ? FinColors.primary
                    : const Color(0xFF2D3245),
                borderRadius: BorderRadius.circular(FinSizes.borderRadiusLg).copyWith(
                  bottomLeft: isUser
                      ? const Radius.circular(FinSizes.borderRadiusLg)
                      : const Radius.circular(4),
                  bottomRight: isUser
                      ? const Radius.circular(4)
                      : const Radius.circular(FinSizes.borderRadiusLg),
                ),
                border: !isUser ? Border.all(
                  color: Colors.white.withValues(alpha: 0.1),
                  width: 1,
                ) : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.content,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: FinSizes.fontSizeMd,
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: FinSizes.xs),
                  Text(
                    _formatTime(message.timestamp),
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: FinSizes.fontSizeSm - 2,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (isUser && showAvatar) const SizedBox(width: FinSizes.sm),
          if (isUser && showAvatar) _buildUserAvatar(),
        ],
      ),
    );
  }

  /// Build AI avatar
  Widget _buildAIAvatar() {
    return Container(
      width: 32,
      height: 32,
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
        size: 18,
        color: FinColors.primary,
      ),
    );
  }

  /// Build user avatar
  Widget _buildUserAvatar() {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: FinColors.darkGrey.withValues(alpha: 0.3),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Icon(
        Icons.person,
        size: 18,
        color: Colors.white.withValues(alpha: 0.8),
      ),
    );
  }

  /// Format timestamp for message display
  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return FinTexts.sofiaTimeNow;
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}${FinTexts.sofiaTimeMinutesAgo}';
    } else if (difference.inDays < 1) {
      return '${timestamp.hour.toString().padLeft(2, '0')}${FinTexts.sofiaTimeHourMinuteSeparator}${timestamp.minute.toString().padLeft(2, '0')}';
    } else {
      return '${timestamp.day}${FinTexts.sofiaTimeDaysFormat}${timestamp.month} ${timestamp.hour.toString().padLeft(2, '0')}${FinTexts.sofiaTimeHourMinuteSeparator}${timestamp.minute.toString().padLeft(2, '0')}';
    }
  }
}