import 'dart:convert';
import 'package:finovate_app/services/session_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import '../config/env_config.dart';

/// Service for communicating with Finovate backend API
class FinovateApiService {
  static const _uuid = Uuid();

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

  /// Get common headers with auth token and correlation ID
  static Future<Map<String, String>> _getHeaders({String? correlationId}) async {
    final token = await _getAuthToken();

    if (token == null) {
      throw Exception('No authentication token available');
    }

    // Generate correlation ID if not provided
    final corrId = correlationId ?? _uuid.v4();

    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      'X-Correlation-Id': corrId,
    };
  }

  /// Log request details in debug mode
  static void _logRequest(String method, String endpoint, String correlationId) {
    if (kDebugMode) {
      print('🔗 [$method] $endpoint [correlationId: $correlationId]');
    }
  }

  /// Log response details in debug mode
  static void _logResponse(int statusCode, String correlationId, {String? error}) {
    if (kDebugMode) {
      if (error != null) {
        print('❌ Response $statusCode [correlationId: $correlationId] - Error: $error');
      } else {
        print('✅ Response $statusCode [correlationId: $correlationId]');
      }
    }
  }

  // ========================================
  // CHAT ENDPOINTS
  // ========================================

  /// Create a new chat session
  static Future<ChatSession> createChatSession({
    String? title,
    String? correlationId,
  }) async {
    final headers = await _getHeaders(correlationId: correlationId);
    final corrId = headers['X-Correlation-Id']!;

    _logRequest('POST', '/chat/sessions', corrId);

    final response = await http.post(
      Uri.parse('$_baseUrl/chat/sessions'),
      headers: headers,
      body: jsonEncode({
        if (title != null) 'title': title,
      }),
    );

    // Log response with correlation ID from backend
    final responseCorrId = response.headers['x-correlation-id'] ?? corrId;
    _logResponse(response.statusCode, responseCorrId);

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return ChatSession.fromJson(data['data']['session']);
    } else {
      final error = jsonDecode(response.body)['error'] ?? 'Failed to create session';
      _logResponse(response.statusCode, responseCorrId, error: error);
      throw Exception(error);
    }
  }

  /// Get all chat sessions
  static Future<List<ChatSession>> getChatSessions({
    String? correlationId,
  }) async {
    final headers = await _getHeaders(correlationId: correlationId);
    final corrId = headers['X-Correlation-Id']!;

    _logRequest('GET', '/chat/sessions', corrId);

    final response = await http.get(
      Uri.parse('$_baseUrl/chat/sessions'),
      headers: headers,
    );

    final responseCorrId = response.headers['x-correlation-id'] ?? corrId;
    _logResponse(response.statusCode, responseCorrId);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final sessions = (data['data']['sessions'] as List)
          .map((json) => ChatSession.fromJson(json))
          .toList();
      return sessions;
    } else {
      final error = jsonDecode(response.body)['error'] ?? 'Failed to fetch sessions';
      _logResponse(response.statusCode, responseCorrId, error: error);
      throw Exception(error);
    }
  }

  /// Delete a chat session
  static Future<void> deleteChatSession(
      String sessionId, {
        String? correlationId,
      }) async {
    final headers = await _getHeaders(correlationId: correlationId);
    final corrId = headers['X-Correlation-Id']!;

    _logRequest('DELETE', '/chat/sessions/$sessionId', corrId);

    final response = await http.delete(
      Uri.parse('$_baseUrl/chat/sessions/$sessionId'),
      headers: headers,
    );

    final responseCorrId = response.headers['x-correlation-id'] ?? corrId;
    _logResponse(response.statusCode, responseCorrId);

    if (response.statusCode != 200) {
      final error = jsonDecode(response.body)['error'] ?? 'Failed to delete session';
      _logResponse(response.statusCode, responseCorrId, error: error);
      throw Exception(error);
    }
  }

  /// Stream chat message
  /// Returns a Stream of chat response chunks
  static Future<Stream<ChatChunk>> streamChatMessage({
    required String message,
    String? sessionId,
    String? correlationId,
  }) async {
    final headers = await _getHeaders(correlationId: correlationId);
    final corrId = headers['X-Correlation-Id']!;

    _logRequest('POST', '/chat/stream', corrId);

    final request = http.Request(
      'POST',
      Uri.parse('$_baseUrl/chat/stream'),
    );

    request.headers.addAll(headers);
    request.body = jsonEncode({
      'message': message,
      if (sessionId != null) 'session_id': sessionId,
    });

    final streamedResponse = await request.send();

    if (streamedResponse.statusCode != 200) {
      final errorBody = await streamedResponse.stream.bytesToString();
      final error = jsonDecode(errorBody)['error'] ?? 'Stream failed';
      _logResponse(streamedResponse.statusCode, corrId, error: error);
      throw Exception(error);
    }

    _logResponse(streamedResponse.statusCode, corrId);

    // Parse SSE stream
    return streamedResponse.stream
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .where((line) => line.startsWith('data: '))
        .map((line) {
      final jsonStr = line.substring(6); // Remove 'data: ' prefix
      final data = jsonDecode(jsonStr);
      return ChatChunk.fromJson(data);
    });
  }
}

// ========================================
// DATA MODELS
// ========================================

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
      messageCount: json['message_count'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

class ChatChunk {
  final String event;
  final Map<String, dynamic>? data;

  ChatChunk({
    required this.event,
    this.data,
  });

  factory ChatChunk.fromJson(Map<String, dynamic> json) {
    return ChatChunk(
      event: json['event'],
      data: json['data'],
    );
  }

  String? get chunk => data?['chunk'];
  String? get message => data?['message'];
}