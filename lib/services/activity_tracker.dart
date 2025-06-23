import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Tracks user activity and manages session timeout requirements
/// Handles both biometric re-authentication and full session logout timeouts
class ActivityTracker extends GetxController {

  // ═══════════════════════════════════════════════════════════════════════════════════════
  // TIMEOUT CONFIGURATION
  // Configure session timeout durations for different security levels
  // ═══════════════════════════════════════════════════════════════════════════════════════

  /// Duration after which biometric re-authentication is required
  /// For testing: 30 seconds | Production: 30 minutes
  static const Duration BIOMETRIC_TIMEOUT = kDebugMode
      ? Duration(seconds: 30)     // Testing
      : Duration(minutes: 30);    // Production

  /// Duration after which full re-authentication (logout) is required
  /// Based on Supabase's lastSignInAt timestamp
  static const Duration FULL_LOGOUT_TIMEOUT = Duration(days: 7);

  // ═══════════════════════════════════════════════════════════════════════════════════════
  // STATE MANAGEMENT
  // Track user activity and authentication timestamps
  // ═══════════════════════════════════════════════════════════════════════════════════════

  /// Timestamp of the last user interaction with the app
  final Rx<DateTime> lastActivity = DateTime.now().obs;

  /// Timestamp of the last successful biometric authentication
  /// Null indicates no biometric auth has been performed yet
  final Rx<DateTime?> lastBiometricAuth = Rx<DateTime?>(null);

  // ═══════════════════════════════════════════════════════════════════════════════════════
  // ACTIVITY TRACKING
  // Methods to record and manage user activity
  // ═══════════════════════════════════════════════════════════════════════════════════════

  /// Records user activity (tap, scroll, navigation, etc.)
  /// Call this method whenever the user interacts with the app
  void recordActivity() {
    lastActivity.value = DateTime.now();

    if (kDebugMode) {
      debugPrint('🎯 Atividade registrada: ${_formatTime(DateTime.now())}');
    }
  }

  /// Marks that biometric authentication was successfully completed
  /// Resets the biometric timeout counter
  void markBiometricAuth() {
    lastBiometricAuth.value = DateTime.now();

    if (kDebugMode) {
      debugPrint('🔒 Autenticação biométrica confirmada: ${_formatTime(DateTime.now())}');
    }
  }

  /// Clears biometric authentication state
  /// Used when user logs out or session is reset
  void clearBiometricAuth() {
    lastBiometricAuth.value = null;

    if (kDebugMode) {
      debugPrint('🔓 Estado biométrico limpo');
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════════════════
  // TIMEOUT VALIDATION
  // Check if user needs re-authentication based on activity and time
  // ═══════════════════════════════════════════════════════════════════════════════════════

  /// Checks if biometric re-authentication is required
  /// Returns true if user hasn't authenticated biometrically within the timeout period
  bool get needsBiometricAuth {
    // First time biometric auth is always required
    if (lastBiometricAuth.value == null) {
      if (kDebugMode) {
        debugPrint('🔒 Primeira autenticação biométrica necessária');
      }
      return true;
    }

    final timeSinceBiometric = DateTime.now().difference(lastBiometricAuth.value!);
    final isExpired = timeSinceBiometric > BIOMETRIC_TIMEOUT;

    if (kDebugMode) {
      debugPrint('⏰ Tempo desde última biometria: ${_formatDuration(timeSinceBiometric)} / ${_formatDuration(BIOMETRIC_TIMEOUT)}');
      debugPrint('🔍 Biometria necessária: ${isExpired ? "SIM" : "NÃO"}');
    }

    return isExpired;
  }

  /// Checks if full re-authentication (logout) is required
  /// Based on Supabase's lastSignInAt timestamp and FULL_LOGOUT_TIMEOUT
  bool get needsFullReauth {
    final user = Supabase.instance.client.auth.currentUser;

    // No user or no sign-in timestamp means full reauth required
    if (user?.lastSignInAt == null) {
      if (kDebugMode) {
        debugPrint('❌ Usuário ou timestamp de login não encontrado');
      }
      return true;
    }

    try {
      final lastSignIn = DateTime.parse(user!.lastSignInAt!);
      final timeSinceLogin = DateTime.now().difference(lastSignIn);
      final isExpired = timeSinceLogin > FULL_LOGOUT_TIMEOUT;

      if (kDebugMode) {
        debugPrint('📅 Último login: ${_formatTime(lastSignIn)}');
        debugPrint('⏰ Tempo desde login: ${_formatDuration(timeSinceLogin)} / ${_formatDuration(FULL_LOGOUT_TIMEOUT)}');
        debugPrint('🔍 Logout necessário: ${isExpired ? "SIM" : "NÃO"}');
      }

      return isExpired;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Erro ao analisar timestamp de login: $e');
      }
      return true; // If we can't parse, require reauth for safety
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════════════════
  // UTILITY METHODS
  // Helper methods for debugging and state management
  // ═══════════════════════════════════════════════════════════════════════════════════════

  /// Formats a DateTime for readable debug output
  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}';
  }

  /// Formats a Duration for readable debug output
  String _formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays}d ${duration.inHours % 24}h';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m ${duration.inSeconds % 60}s';
    } else {
      return '${duration.inSeconds}s';
    }
  }

  /// Prints current state for debugging purposes
  void debugCurrentState() {
    if (kDebugMode) {
      debugPrint('=== Activity Tracker State ===');
      debugPrint('Última atividade: ${_formatTime(lastActivity.value)}');
      debugPrint('Última biometria: ${lastBiometricAuth.value != null ? _formatTime(lastBiometricAuth.value!) : "Nunca"}');
      debugPrint('Precisa biometria: ${needsBiometricAuth ? "SIM" : "NÃO"}');
      debugPrint('Precisa logout: ${needsFullReauth ? "SIM" : "NÃO"}');
      debugPrint('==============================');
    }
  }

  /// Resets all activity tracking state
  /// Used when user logs out or starts a fresh session
  void reset() {
    lastActivity.value = DateTime.now();
    lastBiometricAuth.value = null;

    if (kDebugMode) {
      debugPrint('🔄 Activity Tracker resetado');
    }
  }
}