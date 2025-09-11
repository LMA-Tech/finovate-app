// lib/common/widgets/chat_input.dart

import 'package:flutter/material.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_strings.dart';

/// Chat Input Component for SofIA AI interaction
///
/// This widget provides a text input field with send button for users to
/// communicate with the AI assistant. Features auto-resize, send button state,
/// and proper styling to match the app theme.
class ChatInput extends StatefulWidget {
  /// Callback function when user sends a message
  final Function(String message) onSendMessage;

  /// Placeholder text for the input field
  final String hintText;

  /// Whether the input is currently disabled
  final bool isEnabled;

  /// Whether the AI is currently processing a message
  final bool isLoading;

  const ChatInput({
    super.key,
    required this.onSendMessage,
    this.hintText = FinTexts.sofiaChatInputHint,
    this.isEnabled = true,
    this.isLoading = false,
  });

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  /// Text editing controller for the input field
  final TextEditingController _messageController = TextEditingController();

  /// Focus node for the text field
  final FocusNode _focusNode = FocusNode();

  /// Whether the send button should be enabled
  bool _canSend = false;

  @override
  void initState() {
    super.initState();

    // Listen to text changes to enable/disable send button
    _messageController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  /// Handle text field changes to update send button state
  void _onTextChanged() {
    final hasText = _messageController.text.trim().isNotEmpty;
    if (hasText != _canSend) {
      setState(() {
        _canSend = hasText;
      });
    }
  }

  /// Handle sending the message
  void _sendMessage() {
    if (!_canSend || !widget.isEnabled || widget.isLoading) return;

    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      widget.onSendMessage(message);
      _messageController.clear();
      _focusNode.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(FinSizes.md),
      decoration: BoxDecoration(
        color: const Color(0xFF2D3245),
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Text input field
            Expanded(
              child: Container(
                constraints: const BoxConstraints(
                  minHeight: 44,
                  maxHeight: 120, // Allow for multiline expansion
                ),
                child: TextField(
                  controller: _messageController,
                  focusNode: _focusNode,
                  enabled: widget.isEnabled && !widget.isLoading,
                  maxLines: null, // Allow multiline
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _sendMessage(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: FinSizes.fontSizeMd,
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: FinSizes.fontSizeMd,
                      fontWeight: FontWeight.w400,
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(FinSizes.borderRadiusLg),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(FinSizes.borderRadiusLg),
                      borderSide: BorderSide(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(FinSizes.borderRadiusLg),
                      borderSide: const BorderSide(
                        color: FinColors.primary,
                        width: 1,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: FinSizes.md,
                      vertical: FinSizes.sm + 2,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(width: FinSizes.sm),

            // Send button
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _canSend && widget.isEnabled && !widget.isLoading
                    ? FinColors.primary
                    : FinColors.primary.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _canSend && widget.isEnabled && !widget.isLoading
                      ? _sendMessage
                      : null,
                  borderRadius: BorderRadius.circular(22),
                  child: Center(
                    child: widget.isLoading
                        ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white.withOpacity(0.8),
                        ),
                      ),
                    )
                        : Icon(
                      Icons.arrow_upward,
                      color: _canSend && widget.isEnabled
                          ? Colors.white
                          : Colors.white.withOpacity(0.5),
                      size: FinSizes.iconMd,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}