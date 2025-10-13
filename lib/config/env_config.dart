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
  // GENERAL CONFIGURATION
  // ═══════════════════════════════════════════════════════════════════════════

  static String get apiBaseUrl => dotenv.env['API_BASE_URL'] ?? 'http://localhost:3000';
  static bool get isProduction => dotenv.env['PRODUCTION']?.toLowerCase() == 'true';
  static bool get allowBiometricTestMode => dotenv.env['ALLOW_BIOMETRIC_TEST_MODE']?.toLowerCase() == 'true';

  // ═══════════════════════════════════════════════════════════════════════════
  // VALIDATION
  // ═══════════════════════════════════════════════════════════════════════════

  /// Validate that required Supabase configuration is present
  static bool get isConfigValid {
    return supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
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
      print('╚════════════════════════════════════════════════════════════╝');
    }
  }
}