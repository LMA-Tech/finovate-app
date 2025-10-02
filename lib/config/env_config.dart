// lib/config/env_config.dart

import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Environment configuration manager
///
/// Handles loading and accessing environment variables from .env file
/// Includes validation and debug helpers for development
class EnvConfig {
  // ═══════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════

  /// Load environment variables from .env file
  static Future<void> load() async {
    await dotenv.load(fileName: ".env");
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SUPABASE CONFIGURATION
  // ═══════════════════════════════════════════════════════════════════════════

  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  // ═══════════════════════════════════════════════════════════════════════════
  // LANGFLOW CONFIGURATION
  // ═══════════════════════════════════════════════════════════════════════════

  /// Langflow API base URL (e.g., http://localhost:7860)
  static String get langflowUrl => dotenv.env['LANGFLOW_URL'] ?? 'http://localhost:7860';

  /// Langflow flow ID for SofIA assistant
  static String get langflowFlowId => dotenv.env['LANGFLOW_FLOW_ID'] ?? '';

  /// Langflow API key for authentication
  static String get langflowApiKey => dotenv.env['LANGFLOW_API_KEY'] ?? '';

  // ═══════════════════════════════════════════════════════════════════════════
  // GENERAL CONFIGURATION
  // ═══════════════════════════════════════════════════════════════════════════

  static String get apiBaseUrl => dotenv.env['API_BASE_URL'] ?? 'http://localhost:3000';
  static bool get isProduction => dotenv.env['PRODUCTION']?.toLowerCase() == 'true';

  // ═══════════════════════════════════════════════════════════════════════════
  // VALIDATION
  // ═══════════════════════════════════════════════════════════════════════════

  /// Validate that required Supabase configuration is present
  static bool get isConfigValid {
    return supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
  }

  /// Validate that Langflow configuration is complete
  static bool get isLangflowConfigured {
    return langflowUrl.isNotEmpty &&
        langflowFlowId.isNotEmpty &&
        langflowApiKey.isNotEmpty;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // HELPERS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Get current environment name
  static String get environment => isProduction ? 'production' : 'development';

  /// Debug helper to print configuration status
  ///
  /// IMPORTANT: Never logs actual secrets in production!
  /// Only shows whether values are present or not
  static void debugPrintConfig() {
    if (!isProduction) {
      print('╔════════════════════════════════════════════════════════════╗');
      print('║            ENVIRONMENT CONFIGURATION                       ║');
      print('╠════════════════════════════════════════════════════════════╣');
      print('║ Environment: $environment');
      print('║ API Base URL: $apiBaseUrl');
      print('║ ');
      print('║ SUPABASE:');
      print('║   URL configured: ${supabaseUrl.isNotEmpty ? "✓" : "✗"}');
      print('║   Key configured: ${supabaseAnonKey.isNotEmpty ? "✓" : "✗"}');
      print('║ ');
      print('║ LANGFLOW:');
      print('║   URL: $langflowUrl');
      print('║   Flow ID configured: ${langflowFlowId.isNotEmpty ? "✓" : "✗"}');
      print('║   API Key configured: ${langflowApiKey.isNotEmpty ? "✓" : "✗"}');
      print('╚════════════════════════════════════════════════════════════╝');
    }
  }
}