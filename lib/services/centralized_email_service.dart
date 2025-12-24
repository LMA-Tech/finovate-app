import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../common/dialogs/app_dialogs.dart';
import '../utils/constants/colors.dart';
import '../utils/constants/text_strings.dart';
import 'app_logger.dart';

/// Centralized service for handling all email sending operations
/// Manages rate limiting, error handling, and user feedback consistently
class EmailService {
  static const String _tag = 'EmailService';
  static final SupabaseClient _supabase = Supabase.instance.client;

  // Track email sending to prevent rapid requests
  static final Map<String, DateTime> _lastEmailSent = {};
  static const Duration _minTimeBetweenEmails = Duration(minutes: 2);

  /// Send signup verification email with centralized error handling
  static Future<bool> sendSignupVerification(String email) async {
    return await _sendEmailWithHandling(
      email: email,
      emailType: 'verificação de cadastro',
      sendFunction: () async {
        final response = await _supabase.auth.signUp(
          email: email.trim().toLowerCase(),
          password: 'temp_password', // This will be set properly in signup
        );
        return response;
      },
    );
  }

  /// Resend signup verification email
  static Future<bool> resendSignupVerification(String email) async {
    return await _sendEmailWithHandling(
      email: email,
      emailType: 'reenvio de verificação',
      sendFunction: () async {
        await _supabase.auth.resend(
          type: OtpType.signup,
          email: email.trim().toLowerCase(),
        );
      },
    );
  }

  /// Send password reset email
  static Future<bool> sendPasswordReset(String email) async {
    return await _sendEmailWithHandling(
      email: email,
      emailType: 'redefinição de senha',
      sendFunction: () async {
        await _supabase.auth.resetPasswordForEmail(
          email.trim().toLowerCase(),
        );
      },
    );
  }

  /// Resend password reset email
  static Future<bool> resendPasswordReset(String email) async {
    return await _sendEmailWithHandling(
      email: email,
      emailType: 'reenvio de redefinição',
      sendFunction: () async {
        await _supabase.auth.resetPasswordForEmail(
          email.trim().toLowerCase(),
        );
      },
    );
  }

  /// Centralized email sending with comprehensive error handling
  static Future<bool> _sendEmailWithHandling({
    required String email,
    required String emailType,
    required Future<dynamic> Function() sendFunction,
  }) async {
    // Check rate limiting on frontend
    if (_isRateLimited(email)) {
      _showRateLimitMessage();
      return false;
    }

    try {
      // Attempt to send email
      await sendFunction();

      // Track successful email send
      _lastEmailSent[email] = DateTime.now();

      // Show success message
      _showSuccessMessage(emailType);

      AppLogger.info('Email sent successfully: $emailType to $email', tag: _tag);

      return true;

    } catch (e) {
      // Log error for debugging (but don't show to user)
      AppLogger.error('Email sending failed: $emailType', error: e, tag: _tag);

      // Handle different types of errors gracefully
      _handleEmailError(e, emailType);

      return false;
    }
  }

  /// Check if email sending is rate limited
  static bool _isRateLimited(String email) {
    final lastSent = _lastEmailSent[email];
    if (lastSent == null) return false;

    final timeSinceLastEmail = DateTime.now().difference(lastSent);
    return timeSinceLastEmail < _minTimeBetweenEmails;
  }

  /// Handle email errors gracefully without exposing technical details
  static void _handleEmailError(dynamic error, String emailType) {
    final errorString = error.toString().toLowerCase();

    if (errorString.contains('rate limit') ||
        errorString.contains('too many requests') ||
        errorString.contains('email rate limit exceeded')) {
      // Rate limit - use info dialog
      AppDialogs.showInfo(
        title: FinTexts.emailErrorRateLimitTitle,
        message: FinTexts.emailErrorRateLimit,
      );
    } else if (errorString.contains('invalid email') ||
        errorString.contains('email not found')) {
      // Invalid email - use error dialog
      AppDialogs.showError(
        title: FinTexts.error,
        message: FinTexts.emailErrorInvalid,
      );
    } else if (errorString.contains('network') ||
        errorString.contains('connection') ||
        errorString.contains('timeout')) {
      // Network error - use error dialog
      AppDialogs.showError(
        title: FinTexts.loginErrorNetworkTitle,
        message: FinTexts.emailErrorNetwork,
      );
    } else {
      // Generic error
      AppDialogs.showError(
        title: FinTexts.error,
        message: FinTexts.emailErrorGeneric,
      );
    }
  }

  /// Show rate limit message to user
  static void _showRateLimitMessage() {
    Get.snackbar(
      'Aguarde um momento',
      'Para sua segurança, aguarde alguns minutos antes de solicitar outro email',
      backgroundColor: FinColors.info,
      colorText: FinColors.white,
      duration: const Duration(seconds: 5),
    );
  }

  /// Show success message to user
  static void _showSuccessMessage(String emailType) {
    String message;
    switch (emailType) {
      case 'verificação de cadastro':
        message = 'Email de verificação enviado com sucesso';
        break;
      case 'reenvio de verificação':
        message = 'Email de verificação reenviado';
        break;
      case 'redefinição de senha':
        message = 'Email de redefinição enviado com sucesso';
        break;
      case 'reenvio de redefinição':
        message = 'Email de redefinição reenviado';
        break;
      default:
        message = 'Email enviado com sucesso';
    }

    Get.snackbar(
      'Email enviado',
      message,
      backgroundColor: FinColors.success,
      colorText: FinColors.white,
      duration: const Duration(seconds: 3),
    );
  }

  /// Get time remaining until next email can be sent
  static Duration? getTimeUntilNextEmail(String email) {
    final lastSent = _lastEmailSent[email];
    if (lastSent == null) return null;

    final timeSinceLastEmail = DateTime.now().difference(lastSent);
    final timeRemaining = _minTimeBetweenEmails - timeSinceLastEmail;

    return timeRemaining.isNegative ? null : timeRemaining;
  }

  /// Clear email tracking (useful for testing)
  static void clearEmailTracking() {
    _lastEmailSent.clear();
  }
}