// lib/screens/sofia/sofia_chat_screen.dart

import 'package:finovate_app/screens/sofia/sofia_chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/sizes.dart';

/// Sofia Chat Screen - Backend integration test
class SofiaChatScreen extends StatelessWidget {
  const SofiaChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SofiaChatController());

    return Scaffold(
      backgroundColor: const Color(0xFF1E2332),
      appBar: buildAppBar(controller),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: Obx(() => controller.messages.isEmpty
                ? buildEmptyState()
                : buildMessagesList(controller)),
          ),

          // Input area
          buildMessageInput(controller),
        ],
      ),
    );
  }

  PreferredSizeWidget buildAppBar(SofiaChatController controller) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Get.back(),
      ),
      title: Obx(() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Backend Chat Test',
            style: TextStyle(
              color: Colors.white,
              fontSize: FinSizes.fontSizeLg,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            controller.currentSessionId.value != null ? 'Session active' : 'No session',
            style: TextStyle(
              color: controller.currentSessionId.value != null
                  ? FinColors.success
                  : FinColors.warning,
              fontSize: FinSizes.fontSizeSm,
            ),
          ),
        ],
      )),
      actions: [
        IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.white),
          onPressed: controller.clearChat,
          tooltip: 'Clear chat',
        ),
      ],
    );
  }

  Widget buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: FinColors.primary.withOpacity(0.3),
          ),
          const SizedBox(height: FinSizes.md),
          Text(
            'Send a message to start chatting',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: FinSizes.fontSizeMd,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMessagesList(SofiaChatController controller) {
    return ListView.builder(
      controller: controller.scrollController,
      padding: const EdgeInsets.all(FinSizes.md),
      itemCount: controller.messages.length,
      itemBuilder: (context, index) {
        return buildMessageBubble(controller, controller.messages[index]);
      },
    );
  }

  Widget buildMessageBubble(SofiaChatController controller, ChatMessage message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: FinSizes.md),
        padding: const EdgeInsets.all(FinSizes.md),
        constraints: BoxConstraints(
          maxWidth: Get.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: message.isError
              ? FinColors.error.withOpacity(0.2)
              : message.isUser
              ? FinColors.primary
              : const Color(0xFF2D3245),
          borderRadius: BorderRadius.circular(FinSizes.borderRadiusLg),
          border: message.isError
              ? Border.all(color: FinColors.error, width: 1)
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.text.isEmpty ? ' ' : message.text,
              style: TextStyle(
                color: message.isError ? FinColors.error : Colors.white,
                fontSize: FinSizes.fontSizeMd,
              ),
            ),
            const SizedBox(height: FinSizes.xs),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  controller.formatTime(message.timestamp),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: FinSizes.fontSizeSm,
                  ),
                ),
                if (message.isStreaming) ...[
                  const SizedBox(width: FinSizes.xs),
                  SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white.withOpacity(0.5),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMessageInput(SofiaChatController controller) {
    return Container(
      padding: const EdgeInsets.all(FinSizes.md),
      decoration: BoxDecoration(
        color: const Color(0xFF2D3245),
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller.messageController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(FinSizes.borderRadiusLg),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: const Color(0xFF1E2332),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: FinSizes.md,
                    vertical: FinSizes.sm,
                  ),
                ),
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => controller.sendMessage(),
                enabled: !controller.isLoading.value,
              ),
            ),
            const SizedBox(width: FinSizes.sm),
            Obx(() => Container(
              decoration: BoxDecoration(
                color: controller.isLoading.value
                    ? FinColors.primary.withOpacity(0.5)
                    : FinColors.primary,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(
                  controller.isLoading.value ? Icons.stop : Icons.arrow_upward,
                  color: Colors.white,
                ),
                onPressed: controller.isLoading.value ? null : controller.sendMessage,
              ),
            )),
          ],
        ),
      ),
    );
  }
}