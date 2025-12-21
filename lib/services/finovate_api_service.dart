import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import '../models/models.dart';
import 'session_manager.dart';

/// Service for communicating with Finovate backend API
class FinovateApiService {
  static const _uuid = Uuid();

  // Base URL for backend API
  static const String _baseUrl = 'https://api.finovate.com.br/api/v1';

  // Request timeout duration
  static const Duration _timeout = Duration(seconds: 30);

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
      log('🔗 [$method] $endpoint [correlationId: $correlationId]');
    }
  }

  /// Log response details in debug mode
  static void _logResponse(int statusCode, String correlationId, {String? error}) {
    if (kDebugMode) {
      if (error != null) {
        log('❌ Response $statusCode [correlationId: $correlationId] - Error: $error');
      } else {
        log('✅ Response $statusCode [correlationId: $correlationId]');
      }
    }
  }

// ========================================
// DASHBOARD ENDPOINTS
// ========================================

  /// Get dashboard summary with portfolio, indices, indicators, and top stocks
  static Future<DashboardSummary> getDashboardSummary({
    String? correlationId,
  }) async {
    final headers = await _getHeaders(correlationId: correlationId);
    final corrId = headers['X-Correlation-Id']!;

    _logRequest('GET', '/dashboard/summary', corrId);

    final response = await http.get(
      Uri.parse('$_baseUrl/dashboard/summary'),
      headers: headers,
    ).timeout(_timeout);

    final responseCorrId = response.headers['x-correlation-id'] ?? corrId;

    if (response.statusCode == 200) {
      _logResponse(response.statusCode, responseCorrId);
      return DashboardSummary.fromJson(jsonDecode(response.body));
    } else {
      final errorBody = jsonDecode(response.body);
      final errorMessage = errorBody['error'] ?? 'Failed to get dashboard summary';
      _logResponse(response.statusCode, responseCorrId, error: errorMessage);
      throw Exception(errorMessage);
    }
  }

// ========================================
// MARKET ENDPOINTS
// ========================================

  /// Get market stocks with filtering, sorting, and pagination.
  ///
  /// Parameters:
  /// - [tickers] - List of specific tickers (e.g., ['PETR4', 'VALE3'])
  /// - [search] - Search by ticker or company name
  /// - [type] - 'stock' (default), 'fund' (FII), 'bdr', or 'all'
  /// - [page] - Page number, 1-indexed (default: 1)
  /// - [limit] - Items per page, max 50 (default: 20)
  /// - [sortBy] - 'name', 'close', 'change', 'change_abs', 'volume', 'market_cap_basic', 'sector'
  /// - [sortOrder] - 'asc' or 'desc' (default: 'desc')
  /// - [sector] - Filter by sector (see [getMarketSectors])
  static Future<StockListResponse> getMarketStocks({
    List<String>? tickers,
    String? search,
    String? type,
    int page = 1,
    int limit = 20,
    String? sortBy,
    String? sortOrder,
    String? sector,
    String? correlationId,
  }) async {
    final headers = await _getHeaders(correlationId: correlationId);
    final corrId = headers['X-Correlation-Id']!;

    final queryParams = <String, String>{
      'page': page.toString(),
      'limit': limit.toString(),
    };

    if (tickers != null && tickers.isNotEmpty) {
      queryParams['tickers'] = tickers.join(',');
    }
    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }
    if (type != null && type.isNotEmpty) {
      queryParams['type'] = type;
    }
    if (sortBy != null && sortBy.isNotEmpty) {
      queryParams['sortBy'] = sortBy;
    }
    if (sortOrder != null && sortOrder.isNotEmpty) {
      queryParams['sortOrder'] = sortOrder;
    }
    if (sector != null && sector.isNotEmpty) {
      queryParams['sector'] = sector;
    }

    final uri = Uri.parse('$_baseUrl/market/stocks').replace(queryParameters: queryParams);
    _logRequest('GET', '/market/stocks?${uri.query}', corrId);

    final response = await http.get(uri, headers: headers).timeout(_timeout);
    final responseCorrId = response.headers['x-correlation-id'] ?? corrId;

    if (response.statusCode == 200) {
      _logResponse(response.statusCode, responseCorrId);
      return StockListResponse.fromJson(jsonDecode(response.body));
    } else {
      final errorBody = jsonDecode(response.body);
      final errorMessage = errorBody['error'] ?? 'Failed to get market stocks';
      _logResponse(response.statusCode, responseCorrId, error: errorMessage);
      throw Exception(errorMessage);
    }
  }

  /// Fast autocomplete search for stock tickers and names.
  /// Returns lightweight suggestions for typeahead UI.
  static Future<List<StockSearchSuggestion>> searchStocks({
    required String search,
    int limit = 10,
    String? correlationId,
  }) async {
    final headers = await _getHeaders(correlationId: correlationId);
    final corrId = headers['X-Correlation-Id']!;

    final queryParams = <String, String>{
      'search': search,
      'limit': limit.toString(),
    };

    final uri = Uri.parse('$_baseUrl/market/stocks/search').replace(queryParameters: queryParams);
    _logRequest('GET', '/market/stocks/search?${uri.query}', corrId);

    final response = await http.get(uri, headers: headers).timeout(_timeout);
    final responseCorrId = response.headers['x-correlation-id'] ?? corrId;

    if (response.statusCode == 200) {
      _logResponse(response.statusCode, responseCorrId);
      final data = jsonDecode(response.body)['data'] as Map<String, dynamic>;
      final suggestions = (data['suggestions'] as List)
          .map((s) => StockSearchSuggestion.fromJson(s as Map<String, dynamic>))
          .toList();
      return suggestions;
    } else {
      final errorBody = jsonDecode(response.body);
      final errorMessage = errorBody['error'] ?? 'Failed to search stocks';
      _logResponse(response.statusCode, responseCorrId, error: errorMessage);
      throw Exception(errorMessage);
    }
  }

  /// Get available sectors for filtering stocks.
  static Future<List<String>> getMarketSectors({
    String? correlationId,
  }) async {
    final headers = await _getHeaders(correlationId: correlationId);
    final corrId = headers['X-Correlation-Id']!;

    _logRequest('GET', '/market/sectors', corrId);

    final response = await http.get(
      Uri.parse('$_baseUrl/market/sectors'),
      headers: headers,
    ).timeout(_timeout);

    final responseCorrId = response.headers['x-correlation-id'] ?? corrId;

    if (response.statusCode == 200) {
      _logResponse(response.statusCode, responseCorrId);
      final data = jsonDecode(response.body)['data'] as Map<String, dynamic>;
      return List<String>.from(data['sectors'] as List);
    } else {
      final errorBody = jsonDecode(response.body);
      final errorMessage = errorBody['error'] ?? 'Failed to get market sectors';
      _logResponse(response.statusCode, responseCorrId, error: errorMessage);
      throw Exception(errorMessage);
    }
  }

  /// Get stock detail with price history chart
  ///
  /// Parameters:
  /// - [ticker] - Stock ticker (e.g., 'PETR4')
  /// - [range] - Time range for chart: '1w', '1mo', '3mo', '6mo', '1y' (default: '6mo')
  static Future<StockDetail> getStockDetail({
    required String ticker,
    String range = '6mo',
    String? correlationId,
  }) async {
    final headers = await _getHeaders(correlationId: correlationId);
    final corrId = headers['X-Correlation-Id']!;

    final queryParams = <String, String>{
      'range': range,
    };

    final uri = Uri.parse('$_baseUrl/market/stocks/$ticker')
        .replace(queryParameters: queryParams);
    _logRequest('GET', '/market/stocks/$ticker?${uri.query}', corrId);

    final response = await http.get(uri, headers: headers).timeout(_timeout);
    final responseCorrId = response.headers['x-correlation-id'] ?? corrId;

    if (response.statusCode == 200) {
      _logResponse(response.statusCode, responseCorrId);
      return StockDetail.fromJson(jsonDecode(response.body));
    } else {
      final errorBody = jsonDecode(response.body);
      final errorMessage = errorBody['error'] ?? 'Failed to get stock detail';
      _logResponse(response.statusCode, responseCorrId, error: errorMessage);
      throw Exception(errorMessage);
    }
  }

  /// Get market indices (IBOV, etc.)
  static Future<MarketIndicesResponse> getMarketIndices({
    String? correlationId,
  }) async {
    final headers = await _getHeaders(correlationId: correlationId);
    final corrId = headers['X-Correlation-Id']!;

    _logRequest('GET', '/market/indices', corrId);

    final response = await http.get(
      Uri.parse('$_baseUrl/market/indices'),
      headers: headers,
    ).timeout(_timeout);

    final responseCorrId = response.headers['x-correlation-id'] ?? corrId;

    if (response.statusCode == 200) {
      _logResponse(response.statusCode, responseCorrId);
      return MarketIndicesResponse.fromJson(jsonDecode(response.body));
    } else {
      final errorBody = jsonDecode(response.body);
      final errorMessage = errorBody['error'] ?? 'Failed to get market indices';
      _logResponse(response.statusCode, responseCorrId, error: errorMessage);
      throw Exception(errorMessage);
    }
  }

  /// Get market indicators (USD, SELIC, IPCA)
  static Future<MarketIndicatorsResponse> getMarketIndicators({
    String? correlationId,
  }) async {
    final headers = await _getHeaders(correlationId: correlationId);
    final corrId = headers['X-Correlation-Id']!;

    _logRequest('GET', '/market/indicators', corrId);

    final response = await http.get(
      Uri.parse('$_baseUrl/market/indicators'),
      headers: headers,
    ).timeout(_timeout);

    final responseCorrId = response.headers['x-correlation-id'] ?? corrId;

    if (response.statusCode == 200) {
      _logResponse(response.statusCode, responseCorrId);
      return MarketIndicatorsResponse.fromJson(jsonDecode(response.body));
    } else {
      final errorBody = jsonDecode(response.body);
      final errorMessage = errorBody['error'] ?? 'Failed to get market indicators';
      _logResponse(response.statusCode, responseCorrId, error: errorMessage);
      throw Exception(errorMessage);
    }
  }

// ========================================
// USER FAVORITES ENDPOINTS
// ========================================

  /// Get user's favorite stocks
  static Future<UserFavoritesResponse> getUserFavorites({
    String? correlationId,
  }) async {
    final headers = await _getHeaders(correlationId: correlationId);
    final corrId = headers['X-Correlation-Id']!;

    _logRequest('GET', '/user/favorites', corrId);

    final response = await http.get(
      Uri.parse('$_baseUrl/user/favorites'),
      headers: headers,
    ).timeout(_timeout);

    final responseCorrId = response.headers['x-correlation-id'] ?? corrId;

    if (response.statusCode == 200) {
      _logResponse(response.statusCode, responseCorrId);
      return UserFavoritesResponse.fromJson(jsonDecode(response.body));
    } else {
      final errorBody = jsonDecode(response.body);
      final errorMessage = errorBody['error'] ?? 'Failed to get user favorites';
      _logResponse(response.statusCode, responseCorrId, error: errorMessage);
      throw Exception(errorMessage);
    }
  }

  /// Add stock to user's favorites
  static Future<void> addFavorite({
    required String ticker,
    String? correlationId,
  }) async {
    final headers = await _getHeaders(correlationId: correlationId);
    final corrId = headers['X-Correlation-Id']!;

    _logRequest('POST', '/user/favorites', corrId);

    final response = await http.post(
      Uri.parse('$_baseUrl/user/favorites'),
      headers: headers,
      body: jsonEncode({'ticker': ticker}),
    ).timeout(_timeout);

    final responseCorrId = response.headers['x-correlation-id'] ?? corrId;

    if (response.statusCode == 201) {
      _logResponse(response.statusCode, responseCorrId);
    } else {
      final errorBody = jsonDecode(response.body);
      final errorMessage = errorBody['error'] ?? 'Failed to add favorite';
      _logResponse(response.statusCode, responseCorrId, error: errorMessage);
      throw Exception(errorMessage);
    }
  }

  /// Remove stock from user's favorites
  static Future<void> removeFavorite({
    required String ticker,
    String? correlationId,
  }) async {
    final headers = await _getHeaders(correlationId: correlationId);
    final corrId = headers['X-Correlation-Id']!;

    _logRequest('DELETE', '/user/favorites/$ticker', corrId);

    final response = await http.delete(
      Uri.parse('$_baseUrl/user/favorites/$ticker'),
      headers: headers,
    ).timeout(_timeout);

    final responseCorrId = response.headers['x-correlation-id'] ?? corrId;

    if (response.statusCode == 200) {
      _logResponse(response.statusCode, responseCorrId);
    } else {
      final errorBody = jsonDecode(response.body);
      final errorMessage = errorBody['error'] ?? 'Failed to remove favorite';
      _logResponse(response.statusCode, responseCorrId, error: errorMessage);
      throw Exception(errorMessage);
    }
  }

// ========================================
// ONBOARDING ENDPOINTS
// ========================================

  /// Submit onboarding questionnaire
  static Future<void> submitQuestionnaire({
    required String wealthRange,
    required String investmentKnowledge,
    required String decisionStyle,
    required String riskProfile,
    String? correlationId,
  }) async {
    final headers = await _getHeaders(correlationId: correlationId);
    final corrId = headers['X-Correlation-Id']!;

    _logRequest('POST', '/onboarding/questionnaire', corrId);

    final response = await http.post(
      Uri.parse('$_baseUrl/onboarding/questionnaire'),
      headers: headers,
      body: jsonEncode({
        'wealth_range': wealthRange,
        'investment_knowledge': investmentKnowledge,
        'decision_style': decisionStyle,
        'risk_profile': riskProfile,
      }),
    ).timeout(_timeout);

    final responseCorrId = response.headers['x-correlation-id'] ?? corrId;

    if (response.statusCode == 200) {
      _logResponse(response.statusCode, responseCorrId);
    } else {
      final errorBody = jsonDecode(response.body);
      final errorMessage = errorBody['error'] ?? 'Failed to submit questionnaire';
      _logResponse(response.statusCode, responseCorrId, error: errorMessage);
      throw Exception(errorMessage);
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
    ).timeout(_timeout);

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
    ).timeout(_timeout);

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
    ).timeout(_timeout);

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