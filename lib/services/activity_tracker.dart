import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app_logger.dart';

/// Tracks user activity and manages session timeout requirements
/// Handles both biometric re-authentication and full session logout timeouts
class ActivityTracker extends GetxController {
  static const String _tag = 'ActivityTracker';

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
    AppLogger.verbose('Activity recorded: ${_formatTime(DateTime.now())}', tag: _tag);
  }

  /// Marks that biometric authentication was successfully completed
  /// Resets the biometric timeout counter
  void markBiometricAuth() {
    lastBiometricAuth.value = DateTime.now();
    AppLogger.debug('Biometric authentication confirmed: ${_formatTime(DateTime.now())}', tag: _tag);
  }

  /// Clears biometric authentication state
  /// Used when user logs out or session is reset
  void clearBiometricAuth() {
    lastBiometricAuth.value = null;
    AppLogger.debug('Biometric state cleared', tag: _tag);
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
      AppLogger.debug('First biometric auth required', tag: _tag);
      return true;
    }

    final timeSinceBiometric = DateTime.now().difference(lastBiometricAuth.value!);
    final isExpired = timeSinceBiometric > BIOMETRIC_TIMEOUT;

    AppLogger.verbose('Time since biometric: ${_formatDuration(timeSinceBiometric)} / ${_formatDuration(BIOMETRIC_TIMEOUT)}, needed: $isExpired', tag: _tag);

    return isExpired;
  }

  /// Checks if full re-authentication (logout) is required
  /// Based on Supabase's lastSignInAt timestamp and FULL_LOGOUT_TIMEOUT
  bool get needsFullReauth {
    final user = Supabase.instance.client.auth.currentUser;

    // No user or no sign-in timestamp means full reauth required
    if (user?.lastSignInAt == null) {
      AppLogger.warning('User or login timestamp not found', tag: _tag);
      return true;
    }

    try {
      final lastSignIn = DateTime.parse(user!.lastSignInAt!);
      final timeSinceLogin = DateTime.now().difference(lastSignIn);
      final isExpired = timeSinceLogin > FULL_LOGOUT_TIMEOUT;

      AppLogger.verbose('Last login: ${_formatTime(lastSignIn)}, time since: ${_formatDuration(timeSinceLogin)} / ${_formatDuration(FULL_LOGOUT_TIMEOUT)}, logout needed: $isExpired', tag: _tag);

      return isExpired;
    } catch (e) {
      AppLogger.error('Error parsing login timestamp', error: e, tag: _tag);
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
    AppLogger.debug(
      'Activity state: lastActivity=${_formatTime(lastActivity.value)}, '
      'lastBiometric=${lastBiometricAuth.value != null ? _formatTime(lastBiometricAuth.value!) : "never"}, '
      'needsBiometric=$needsBiometricAuth, needsLogout=$needsFullReauth',
      tag: _tag,
    );
  }

  /// Resets all activity tracking state
  /// Used when user logs out or starts a fresh session
  void reset() {
    lastActivity.value = DateTime.now();
    lastBiometricAuth.value = null;
    AppLogger.info('Activity tracker reset', tag: _tag);
  }
}