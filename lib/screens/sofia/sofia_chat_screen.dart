// lib/screens/sofia/sofia_chat_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/finovate_api_service.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/sizes.dart';

/// Test screen for backend chat integration with streaming
class SofiaChatScreen extends StatefulWidget {
  const SofiaChatScreen({super.key});

  @override
  State<SofiaChatScreen> createState() => _SofiaTestScreenState();
}

class _SofiaTestScreenState extends State<SofiaChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();

  bool _isLoading = false;
  String _streamingBuffer = '';
  String? _currentSessionId;

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// Load existing sessions on startup
  Future<void> _loadSessions() async {
    try {
      final sessions = await FinovateApiService.getChatSessions();
      if (sessions.isNotEmpty) {
        // Use most recent session
        _currentSessionId = sessions.first.sessionId;
        debugPrint('📋 Loaded existing session: $_currentSessionId');
      }
    } catch (e) {
      debugPrint('❌ Failed to load sessions: $e');
    }
  }

  /// Send message to backend
  Future<void> _sendMessage() async {
    final messageText = _messageController.text.trim();
    if (messageText.isEmpty || _isLoading) return;

    _messageController.clear();

    // Add user message
    setState(() {
      _messages.add(ChatMessage(
        text: messageText,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isLoading = true;
      _streamingBuffer = '';
    });

    // Create session if needed
    if (_currentSessionId == null) {
      try {
        final session = await FinovateApiService.createChatSession(
          title: messageText.substring(0, messageText.length > 30 ? 30 : messageText.length),
        );
        _currentSessionId = session.sessionId;
        debugPrint('✅ Created session: $_currentSessionId');
      } catch (e) {
        setState(() {
          _isLoading = false;
          _messages.add(ChatMessage(
            text: 'Failed to create session: $e',
            isUser: false,
            isError: true,
            timestamp: DateTime.now(),
          ));
        });
        return;
      }
    }

    // Add streaming placeholder
    setState(() {
      _messages.add(ChatMessage(
        text: '',
        isUser: false,
        isStreaming: true,
        timestamp: DateTime.now(),
      ));
    });

    _scrollToBottom();

    // Stream response from backend
    await FinovateApiService.streamChatMessage(
      message: messageText,
      sessionId: _currentSessionId,
      onToken: (token) {
        if (!mounted) return;
        setState(() {
          _streamingBuffer += token;
          if (_messages.isNotEmpty && _messages.last.isStreaming) {
            _messages[_messages.length - 1] = ChatMessage(
              text: _streamingBuffer,
              isUser: false,
              isStreaming: true,
              timestamp: _messages.last.timestamp,
            );
          }
        });
        _scrollToBottom();
      },
      onComplete: () {
        if (!mounted) return;
        debugPrint('✅ Stream completed');
        setState(() {
          _isLoading = false;
          if (_messages.isNotEmpty && _messages.last.isStreaming) {
            _messages[_messages.length - 1] = ChatMessage(
              text: _streamingBuffer.isEmpty ? '(empty response)' : _streamingBuffer,
              isUser: false,
              isStreaming: false,
              timestamp: _messages.last.timestamp,
            );
          }
          _streamingBuffer = '';
        });
        _scrollToBottom();
      },
      onError: (error) {
        if (!mounted) return;
        debugPrint('❌ Stream error: $error');
        setState(() {
          _isLoading = false;
          if (_messages.isNotEmpty && _messages.last.isStreaming) {
            _messages.removeLast();
          }
          _messages.add(ChatMessage(
            text: 'Error: $error',
            isUser: false,
            isError: true,
            timestamp: DateTime.now(),
          ));
          _streamingBuffer = '';
        });
        _scrollToBottom();
      },
    );
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 50), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E2332),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Column(
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
              _currentSessionId != null ? 'Session active' : 'No session',
              style: TextStyle(
                color: _currentSessionId != null ? FinColors.success : FinColors.warning,
                fontSize: FinSizes.fontSizeSm,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.white),
            onPressed: () {
              setState(() {
                _messages.clear();
                _currentSessionId = null;
              });
            },
            tooltip: 'Clear chat',
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: _messages.isEmpty
                ? Center(
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
            )
                : ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(FinSizes.md),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),

          // Input area
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: FinSizes.md),
        padding: const EdgeInsets.all(FinSizes.md),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
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
                  _formatTime(message.timestamp),
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

  Widget _buildMessageInput() {
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
                controller: _messageController,
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
                onSubmitted: (_) => _sendMessage(),
                enabled: !_isLoading,
              ),
            ),
            const SizedBox(width: FinSizes.sm),
            Container(
              decoration: BoxDecoration(
                color: _isLoading
                    ? FinColors.primary.withOpacity(0.5)
                    : FinColors.primary,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(
                  _isLoading ? Icons.stop : Icons.arrow_upward,
                  color: Colors.white,
                ),
                onPressed: _isLoading ? null : _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}

// Chat message model
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