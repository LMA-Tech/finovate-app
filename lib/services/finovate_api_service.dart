import 'dart:convert';
import 'package:finovate_app/services/session_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../config/env_config.dart';

/// Service for communicating with Finovate backend API
class FinovateApiService {
  // Base URL for backend API
  static String get _baseUrl {
    // Use configured URL from environment
    final configuredUrl = EnvConfig.apiBaseUrl;

    // If API_BASE_URL is set in .env, use it
    if (configuredUrl.isNotEmpty && configuredUrl != 'http://localhost:3000') {
      return '$configuredUrl/api/v1';
    }

    // Fallback to localhost for local development
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:5001/api/v1';
    } else {
      return 'http://localhost:5001/api/v1';
    }
  }

  /// Get auth token from Supabase session
  static Future<String?> _getAuthToken() async {
    final sessionManager = Get.find<SessionManager>();
    return await sessionManager.getAuthToken();
  }

  /// Get common headers with auth token
  static Future<Map<String, String>> _getHeaders() async {
    final token = await _getAuthToken();

    if (token == null) {
      throw Exception('No authentication token available');
    }

    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // ========================================
  // CHAT ENDPOINTS
  // ========================================

  /// Create a new chat session
  static Future<ChatSession> createChatSession({String? title}) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$_baseUrl/chat/sessions'),
        headers: headers,
        body: jsonEncode({
          if (title != null) 'title': title,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return ChatSession.fromJson(data['data']['session']);
      } else {
        throw Exception('Failed to create session: ${response.body}');
      }
    } catch (e) {
      debugPrint('[BackendApiService] Error creating session: $e');
      rethrow;
    }
  }

  /// Get all chat sessions for current user
  static Future<List<ChatSession>> getChatSessions() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$_baseUrl/chat/sessions'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final sessions = (data['data']['sessions'] as List)
            .map((json) => ChatSession.fromJson(json))
            .toList();
        return sessions;
      } else {
        throw Exception('Failed to get sessions: ${response.body}');
      }
    } catch (e) {
      debugPrint('[BackendApiService] Error getting sessions: $e');
      rethrow;
    }
  }

  /// Get a specific chat session
  static Future<ChatSession> getChatSession(String sessionId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$_baseUrl/chat/sessions/$sessionId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ChatSession.fromJson(data['data']['session']);
      } else {
        throw Exception('Failed to get session: ${response.body}');
      }
    } catch (e) {
      debugPrint('[BackendApiService] Error getting session: $e');
      rethrow;
    }
  }

  /// Delete a chat session
  static Future<void> deleteChatSession(String sessionId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.parse('$_baseUrl/chat/sessions/$sessionId'),
        headers: headers,
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete session: ${response.body}');
      }
    } catch (e) {
      debugPrint('[BackendApiService] Error deleting session: $e');
      rethrow;
    }
  }

  /// Stream chat message with real-time response
  static Future<void> streamChatMessage({
    required String message,
    String? sessionId,
    required Function(String token) onToken,
    required Function() onComplete,
    required Function(String error) onError,
  }) async {
    try {
      final headers = await _getHeaders();

      final request = http.Request(
        'POST',
        Uri.parse('$_baseUrl/chat/stream'),
      );

      request.headers.addAll(headers);
      request.body = jsonEncode({
        'message': message,
        if (sessionId != null) 'session_id': sessionId,
      });

      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          throw Exception('Request timed out');
        },
      );

      if (streamedResponse.statusCode == 200) {
        await _processStreamResponse(
          streamedResponse,
          onToken: onToken,
          onComplete: onComplete,
          onError: onError,
        );
      } else {
        final errorBody = await streamedResponse.stream.bytesToString();
        onError('Request failed: $errorBody');
      }
    } catch (e) {
      debugPrint('[BackendApiService] Error streaming message: $e');
      onError(e.toString());
    }
  }

  /// Process Server-Sent Events stream from backend
  static Future<void> _processStreamResponse(
      http.StreamedResponse response, {
        required Function(String token) onToken,
        required Function() onComplete,
        required Function(String error) onError,
      }) async {
    try {
      final buffer = StringBuffer();
      bool hasReceivedData = false;

      await for (final chunk in response.stream.transform(utf8.decoder)) {
        buffer.write(chunk);
        final lines = buffer.toString().split('\n');

        for (int i = 0; i < lines.length - 1; i++) {
          final line = lines[i].trim();
          if (line.isEmpty || !line.startsWith('data: ')) continue;

          final jsonStr = line.substring(6); // Remove 'data: ' prefix

          try {
            final data = jsonDecode(jsonStr);

            if (data['event'] == 'end') {
              onComplete();
              return;
            }

            if (data['event'] == 'error') {
              onError(data['data']?['message'] ?? 'Unknown error');
              return;
            }

            if (data['event'] == 'token') {
              final token = data['data']?['chunk'] ?? '';
              if (token.isNotEmpty) {
                hasReceivedData = true;
                onToken(token);
              }
            }
          } catch (e) {
            debugPrint('[BackendApiService] Error parsing SSE: $e');
          }
        }

        buffer.clear();
        buffer.write(lines.last);
      }

      if (hasReceivedData) {
        onComplete();
      }
    } catch (e) {
      debugPrint('[BackendApiService] Error processing stream: $e');
      onError(e.toString());
    }
  }
}

// ========================================
// DATA MODELS
// ========================================

/// Chat session model matching backend response
class ChatSession {
  final String id;
  final String userAuthId;
  final String sessionId;
  final String? title;
  final int messageCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChatSession({
    required this.id,
    required this.userAuthId,
    required this.sessionId,
    this.title,
    required this.messageCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChatSession.fromJson(Map<String, dynamic> json) {
    return ChatSession(
      id: json['id'],
      userAuthId: json['user_auth_id'],
      sessionId: json['session_id'],
      title: json['title'],
      messageCount: json['message_count'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_auth_id': userAuthId,
      'session_id': sessionId,
      'title': title,
      'message_count': messageCount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}