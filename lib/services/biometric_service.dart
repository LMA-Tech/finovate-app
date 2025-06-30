import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

/// Context for biometric authentication to provide appropriate messaging
enum BiometricContext {
  login,
  sensitiveAction,
  appUnlock,
  payment,
  settings,
}

/// Result of biometric authentication with detailed information
class BiometricResult {
  final bool success;
  final String? errorMessage;
  final BiometricErrorType? errorType;

  const BiometricResult({
    required this.success,
    this.errorMessage,
    this.errorType,
  });

  factory BiometricResult.success() => const BiometricResult(success: true);

  factory BiometricResult.failure({
    required String errorMessage,
    BiometricErrorType? errorType,
  }) => BiometricResult(
    success: false,
    errorMessage: errorMessage,
    errorType: errorType,
  );
}

/// Types of biometric errors for better handling
enum BiometricErrorType {
  notAvailable,
  notEnrolled,
  lockedOut,
  permanentlyLockedOut,
  userCanceled,
  systemError,
}

/// Enhanced service for handling biometric authentication across different platforms
/// Supports Face ID, Touch ID, Fingerprint, and other biometric types with comprehensive error handling
class BiometricService {
  static final LocalAuthentication _localAuth = LocalAuthentication();

  // ═══════════════════════════════════════════════════════════════════════════════════════
  // AVAILABILITY CHECKS
  // Enhanced methods to check biometric capabilities and setup status
  // ═══════════════════════════════════════════════════════════════════════════════════════

  /// Comprehensive check if biometric authentication is properly set up and available
  static Future<bool> isBiometricSetup() async {
    try {
      final isAvailable = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      final availableBiometrics = await _localAuth.getAvailableBiometrics();

      final isFullySetup = isAvailable &&
          isDeviceSupported &&
          availableBiometrics.isNotEmpty;

      if (kDebugMode) {
        debugPrint('🔍 Biometric Setup Status:');
        debugPrint('  - Can check biometrics: $isAvailable');
        debugPrint('  - Device supported: $isDeviceSupported');
        debugPrint('  - Available types: $availableBiometrics');
        debugPrint('  - Fully setup: $isFullySetup');
      }

      return isFullySetup;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error checking biometric setup: $e');
      }
      return false;
    }
  }

  /// Checks if any biometric authentication method is available on the device
  static Future<bool> isAvailable() async {
    try {
      final canCheck = await _localAuth.canCheckBiometrics;
      final isSupported = await _localAuth.isDeviceSupported();
      return canCheck || isSupported;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error checking biometric availability: $e');
      }
      return false;
    }
  }

  /// Gets detailed information about biometric capabilities
  static Future<Map<String, dynamic>> getBiometricCapabilities() async {
    try {
      final canCheck = await _localAuth.canCheckBiometrics;
      final isSupported = await _localAuth.isDeviceSupported();
      final availableTypes = await _localAuth.getAvailableBiometrics();
      final biometricType = await getBiometricType();

      return {
        'canCheck': canCheck,
        'isSupported': isSupported,
        'availableTypes': availableTypes,
        'primaryType': biometricType,
        'isFullySetup': canCheck && isSupported && availableTypes.isNotEmpty,
      };
    } catch (e) {
      return {
        'canCheck': false,
        'isSupported': false,
        'availableTypes': <BiometricType>[],
        'primaryType': 'Biometria',
        'isFullySetup': false,
        'error': e.toString(),
      };
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════════════════
  // BIOMETRIC TYPE DETECTION
  // Enhanced methods to detect what type of biometric authentication is available
  // ═══════════════════════════════════════════════════════════════════════════════════════

  /// Returns the localized name of the available biometric type
  /// e.g., "Face ID", "Impressão Digital", "Íris", etc.
  static Future<String> getBiometricType() async {
    try {
      final availableBiometrics = await _localAuth.getAvailableBiometrics();

      if (kDebugMode) {
        debugPrint('🔍 Available biometrics: $availableBiometrics');
      }

      // iOS/Android specific biometric types (prioritize more secure methods)
      if (availableBiometrics.contains(BiometricType.face)) {
        return "Face ID";
      } else if (availableBiometrics.contains(BiometricType.iris)) {
        return "Íris";
      } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
        return "Impressão Digital";
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

      // iOS/Android specific biometric types (prioritize more secure methods)
      if (availableBiometrics.contains(BiometricType.face)) {
        return Icons.face; // Face ID icon
      } else if (availableBiometrics.contains(BiometricType.iris)) {
        return Icons.visibility; // Eye/iris icon
      } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
        return Icons.fingerprint; // Fingerprint icon
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
  // ENHANCED AUTHENTICATION
  // Core biometric authentication functionality with context-aware messaging
  // ═══════════════════════════════════════════════════════════════════════════════════════

  /// Performs biometric authentication with context-aware messaging and enhanced error handling
  ///
  /// [context] - The context for authentication to provide appropriate messaging
  /// [customReason] - Custom reason that overrides context-based messaging
  /// [allowFallback] - Whether to allow PIN/password fallback (default: true)
  ///
  /// Returns BiometricResult with success status and detailed error information
  static Future<BiometricResult> authenticateWithContext({
    BiometricContext context = BiometricContext.appUnlock,
    String? customReason,
    bool allowFallback = true,
  }) async {
    try {
      // Debug mode: Simulate authentication for development/testing
      if (kDebugMode) {
        debugPrint('🧪 TEST MODE: Simulating biometric authentication...');
        debugPrint('🧪 Context: $context');
        debugPrint('🧪 Custom reason: $customReason');
        await Future.delayed(const Duration(seconds: 2));
        return BiometricResult.success();
      }

      // Check if biometric authentication is available on this device
      final isSetup = await isBiometricSetup();
      if (!isSetup) {
        return BiometricResult.failure(
          errorMessage: 'Autenticação biométrica não está disponível ou configurada',
          errorType: BiometricErrorType.notAvailable,
        );
      }

      // Get context-aware localized reason
      final localizedReason = customReason ?? _getLocalizedReason(context);

      // Perform the actual biometric authentication
      final result = await _localAuth.authenticate(
        localizedReason: localizedReason,
        options: AuthenticationOptions(
          biometricOnly: !allowFallback, // Allow PIN/password fallback based on parameter
          stickyAuth: true, // Keep auth dialog until success/cancel
          useErrorDialogs: true, // Show system error dialogs
        ),
      );

      if (kDebugMode) {
        debugPrint(result ? '✅ Biometric authentication successful' : '❌ Biometric authentication failed');
      }

      return result
          ? BiometricResult.success()
          : BiometricResult.failure(
        errorMessage: 'Falha na autenticação biométrica',
        errorType: BiometricErrorType.userCanceled,
      );

    } on PlatformException catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Biometric Platform Exception: ${e.code} - ${e.message}');
      }

      return _handlePlatformException(e);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Biometric authentication error: $e');
      }

      return BiometricResult.failure(
        errorMessage: 'Erro inesperado na autenticação biométrica',
        errorType: BiometricErrorType.systemError,
      );
    }
  }

  /// Legacy method for backward compatibility
  static Future<bool> authenticate({String? reason}) async {
    final result = await authenticateWithContext(
      context: BiometricContext.appUnlock,
      customReason: reason,
    );
    return result.success;
  }

  // ═══════════════════════════════════════════════════════════════════════════════════════
  // PRIVATE HELPER METHODS
  // Internal methods for localization and error handling
  // ═══════════════════════════════════════════════════════════════════════════════════════

  /// Gets context-aware localized reason for biometric authentication
  static String _getLocalizedReason(BiometricContext context) {
    switch (context) {
      case BiometricContext.login:
        return "Use sua biometria para fazer login rapidamente";
      case BiometricContext.sensitiveAction:
        return "Confirme sua identidade para esta ação sensível";
      case BiometricContext.appUnlock:
        return "Desbloqueie o Finovate com sua biometria";
      case BiometricContext.payment:
        return "Confirme sua identidade para autorizar este pagamento";
      case BiometricContext.settings:
        return "Confirme sua identidade para acessar as configurações";
    }
  }

  /// Handles platform exceptions and converts them to BiometricResult
  static BiometricResult _handlePlatformException(PlatformException e) {
    switch (e.code) {
      case auth_error.notAvailable:
        return BiometricResult.failure(
          errorMessage: 'Hardware biométrico não está disponível',
          errorType: BiometricErrorType.notAvailable,
        );
      case auth_error.notEnrolled:
        return BiometricResult.failure(
          errorMessage: 'Nenhuma biometria cadastrada no dispositivo',
          errorType: BiometricErrorType.notEnrolled,
        );
      case auth_error.lockedOut:
        return BiometricResult.failure(
          errorMessage: 'Muitas tentativas falharam. Tente novamente mais tarde',
          errorType: BiometricErrorType.lockedOut,
        );
      case auth_error.permanentlyLockedOut:
        return BiometricResult.failure(
          errorMessage: 'Autenticação biométrica permanentemente desabilitada',
          errorType: BiometricErrorType.permanentlyLockedOut,
        );
      case auth_error.otherOperatingSystem:
        return BiometricResult.failure(
          errorMessage: 'Sistema operacional não suportado',
          errorType: BiometricErrorType.systemError,
        );
      default:
      // Handle user cancellation and other errors here
        if (e.code == 'UserCancel' || e.message?.contains('canceled') == true) {
          return BiometricResult.failure(
            errorMessage: 'Autenticação cancelada pelo usuário',
            errorType: BiometricErrorType.userCanceled,
          );
        }
        return BiometricResult.failure(
          errorMessage: 'Erro na autenticação biométrica: ${e.message}',
          errorType: BiometricErrorType.systemError,
        );
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════════════════
  // UTILITY METHODS
  // Helper methods for checking biometric availability and capabilities
  // ═══════════════════════════════════════════════════════════════════════════════════════

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

  /// Returns user-friendly description of why biometric authentication might not be available
  static Future<String> getUnavailabilityReason() async {
    try {
      final canCheck = await _localAuth.canCheckBiometrics;
      final isSupported = await _localAuth.isDeviceSupported();
      final availableTypes = await _localAuth.getAvailableBiometrics();

      if (!isSupported) {
        return 'Este dispositivo não suporta autenticação biométrica';
      } else if (!canCheck) {
        return 'Autenticação biométrica não está habilitada';
      } else if (availableTypes.isEmpty) {
        return 'Nenhuma biometria foi cadastrada no dispositivo';
      } else {
        return 'Autenticação biométrica está disponível';
      }
    } catch (e) {
      return 'Erro ao verificar disponibilidade da biometria';
    }
  }

  /// Checks if the device supports a specific biometric type
  static Future<bool> supportsBiometricType(BiometricType type) async {
    try {
      final availableTypes = await _localAuth.getAvailableBiometrics();
      return availableTypes.contains(type);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error checking biometric type support: $e');
      }
      return false;
    }
  }
}