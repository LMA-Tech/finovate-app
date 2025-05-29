import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  // Load environment variables from .env file
  static Future<void> load() async {
    await dotenv.load(fileName: ".env");
  }

  // Getters that read from loaded .env
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';
  static String get apiBaseUrl => dotenv.env['API_BASE_URL'] ?? 'http://localhost:3000';
  static bool get isProduction => dotenv.env['PRODUCTION']?.toLowerCase() == 'true';

  // Validation
  static bool get isConfigValid {
    return supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
  }

  // Helper to check environment
  static String get environment => isProduction ? 'production' : 'development';

  // Debug helper (never log secrets in production!)
  static void debugPrintConfig() {
    if (!isProduction) {
      print('Environment: $environment');
      print('API Base URL: $apiBaseUrl');
      print('Supabase URL configured: ${supabaseUrl.isNotEmpty}');
      print('Supabase Key configured: ${supabaseAnonKey.isNotEmpty}');
    }
  }
}