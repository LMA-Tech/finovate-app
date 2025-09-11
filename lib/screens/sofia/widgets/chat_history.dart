// lib/screens/sofia/widgets/recent_conversations_widget.dart

import 'package:flutter/material.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_strings.dart';
import '../sofia_controller.dart';

/// Recent Conversations Widget
///
/// Displays a preview of recent conversations with SofIA.
/// This widget is reusable and can be used in different screens
/// that need to show conversation history.
class ChatHistoryWidget extends StatelessWidget {
  final SofiaController controller;
  final VoidCallback onConversationTap;
  final VoidCallback onViewAllTap;

  const ChatHistoryWidget({
    super.key,
    required this.controller,
    required this.onConversationTap,
    required this.onViewAllTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(FinSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                FinTexts.sofiaChatHistory,
                style: TextStyle(
                  fontSize: FinSizes.fontSizeLg,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              TextButton(
                onPressed: onViewAllTap,
                child: Text(
                  FinTexts.sofiaViewAllChats,
                  style: TextStyle(
                    fontSize: FinSizes.fontSizeSm,
                    color: FinColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: FinSizes.md),

          // Recent conversation tile
          ConversationTileWidget(
            controller: controller,
            onTap: onConversationTap,
          ),
        ],
      ),
    );
  }
}

/// Individual Conversation Tile Widget
///
/// Displays a single conversation preview with avatar, title,
/// last message preview, and timestamp. Reusable component
/// for conversation lists.
class ConversationTileWidget extends StatelessWidget {
  final SofiaController controller;
  final VoidCallback onTap;

  const ConversationTileWidget({
    super.key,
    required this.controller,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Get the most recent message for preview
    final lastMessage = controller.messages.isNotEmpty
        ? controller.messages.last
        : null;

    if (lastMessage == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(FinSizes.md),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(FinSizes.borderRadiusLg),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(FinSizes.borderRadiusLg),
        child: Row(
          children: [
            // AI avatar
            Container(
              width: 40,
              height: 40,
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
                size: 20,
                color: FinColors.primary,
              ),
            ),

            const SizedBox(width: FinSizes.md),

            // Conversation preview
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    FinTexts.sofiaChatWithSofia,
                    style: TextStyle(
                      fontSize: FinSizes.fontSizeMd,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: FinSizes.xs),
                  Text(
                    lastMessage.content.length > 50
                        ? '${lastMessage.content.substring(0, 50)}...'
                        : lastMessage.content,
                    style: TextStyle(
                      fontSize: FinSizes.fontSizeSm,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Time indicator
            Text(
              _getRelativeTime(lastMessage.timestamp),
              style: TextStyle(
                fontSize: FinSizes.fontSizeSm,
                color: Colors.white.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Get relative time string for conversation preview
  String _getRelativeTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return FinTexts.sofiaTimeNow;
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}${FinTexts.sofiaTimeMinutesAgo}';
    } else if (difference.inDays < 1) {
      return '${timestamp.hour.toString().padLeft(2, '0')}${FinTexts.sofiaTimeHourMinuteSeparator}${timestamp.minute.toString().padLeft(2, '0')}';
    } else {
      return '${timestamp.day}${FinTexts.sofiaTimeDaysFormat}${timestamp.month}';
    }
  }
}