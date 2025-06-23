import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';

/// Service for handling biometric authentication across different platforms
/// Supports Face ID, Touch ID, Fingerprint, and other biometric types
class BiometricService {
  static final LocalAuthentication _localAuth = LocalAuthentication();

  // ═══════════════════════════════════════════════════════════════════════════════════════
  // BIOMETRIC TYPE DETECTION
  // Methods to detect what type of biometric authentication is available
  // ═══════════════════════════════════════════════════════════════════════════════════════

  /// Returns the localized name of the available biometric type
  /// e.g., "Face ID", "Impressão Digital", "Íris", etc.
  static Future<String> getBiometricType() async {
    try {
      final availableBiometrics = await _localAuth.getAvailableBiometrics();

      if (kDebugMode) {
        debugPrint('🔍 Available biometrics: $availableBiometrics');
      }

      // iOS/Android specific biometric types
      if (availableBiometrics.contains(BiometricType.face)) {
        return "Face ID";
      } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
        return "Impressão Digital";
      } else if (availableBiometrics.contains(BiometricType.iris)) {
        return "Íris";
      }
      // Android generic biometric strength levels
      else if (availableBiometrics.contains(BiometricType.strong)) {
        return "Impressão Digital"; // Assume fingerprint for strong biometric
      } else if (availableBiometrics.contains(BiometricType.weak)) {
        return "Autenticação"; // Generic for weak biometric
      } else {
        return "Biometria"; // Fallback generic term
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error detecting biometric type: $e');
      }
      return "Biometria";
    }
  }

  /// Returns the appropriate icon for the available biometric type
  /// Uses Material Design icons that match the biometric capability
  static Future<IconData> getBiometricIcon() async {
    try {
      final availableBiometrics = await _localAuth.getAvailableBiometrics();

      // iOS/Android specific biometric types
      if (availableBiometrics.contains(BiometricType.face)) {
        return Icons.face; // Face ID icon
      } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
        return Icons.fingerprint; // Fingerprint icon
      } else if (availableBiometrics.contains(BiometricType.iris)) {
        return Icons.visibility; // Eye/iris icon
      }
      // Android generic biometric strength levels
      else if (availableBiometrics.contains(BiometricType.strong)) {
        return Icons.fingerprint; // Assume fingerprint for strong biometric
      } else if (availableBiometrics.contains(BiometricType.weak)) {
        return Icons.security; // Generic security icon
      } else {
        return Icons.security; // Fallback security icon
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error detecting biometric icon: $e');
      }
      return Icons.security;
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════════════════
  // AUTHENTICATION
  // Core biometric authentication functionality
  // ═══════════════════════════════════════════════════════════════════════════════════════

  /// Performs biometric authentication with the device's available biometric method
  ///
  /// [reason] - The localized reason shown to the user for why authentication is needed
  ///
  /// Returns true if authentication succeeds, false otherwise
  static Future<bool> authenticate({String? reason}) async {
    try {
      // Debug mode: Simulate authentication for development/testing
      if (kDebugMode) {
        debugPrint('🧪 TEST MODE: Simulating biometric authentication...');
        await Future.delayed(const Duration(seconds: 2));
        return true;
      }

      // Check if biometric authentication is available on this device
      final isAvailable = await _localAuth.canCheckBiometrics;
      if (!isAvailable) {
        if (kDebugMode) {
          debugPrint('⚠️ Biometric authentication not available');
        }
        return false;
      }

      // Perform the actual biometric authentication
      final result = await _localAuth.authenticate(
        localizedReason: reason ?? "Autentique-se para continuar",
        options: const AuthenticationOptions(
          biometricOnly: false, // Allow PIN/password fallback
          stickyAuth: true, // Keep auth dialog until success/cancel
        ),
      );

      if (kDebugMode) {
        debugPrint(result ? '✅ Biometric authentication successful' : '❌ Biometric authentication failed');
      }

      return result;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Biometric authentication error: $e');
      }
      return false;
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════════════════
  // UTILITY METHODS
  // Helper methods for checking biometric availability
  // ═══════════════════════════════════════════════════════════════════════════════════════

  /// Checks if any biometric authentication method is available on the device
  static Future<bool> isAvailable() async {
    try {
      return await _localAuth.canCheckBiometrics;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error checking biometric availability: $e');
      }
      return false;
    }
  }

  /// Gets a list of all available biometric types on the device
  /// Useful for debugging and feature detection
  static Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error getting available biometrics: $e');
      }
      return [];
    }
  }
}