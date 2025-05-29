import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Sign in with email and password
  /// Rate limiting is handled by Supabase's built-in rate limits
  Future<AuthResponse> loginWithEmailPassword(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email.trim().toLowerCase(),
        password: password,
      );
      return response;
    } on AuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Connection error. Please check your internet and try again.';
    }
  }

  /// Sign up with email and password
  Future<AuthResponse> signUp(String email, String password, {
    String? firstName,
    String? lastName,
    String? phone,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email.trim().toLowerCase(),
        password: password,
        data: {
          if (firstName?.isNotEmpty == true) 'first_name': firstName!.trim(),
          if (lastName?.isNotEmpty == true) 'last_name': lastName!.trim(),
          if (phone?.isNotEmpty == true) 'phone': phone!.trim(),
        },
        // Supabase handles email confirmation automatically
      );
      return response;
    } on AuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Connection error. Please check your internet and try again.';
    }
  }

  /// Reset password - Supabase handles email sending and rate limiting
  Future<void> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(
        email.trim().toLowerCase(),
        // Supabase will use your configured redirect URL
      );
    } on AuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Failed to send reset email. Please try again.';
    }
  }

  /// Sign out - Supabase handles session cleanup
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Sign out error: $e');
      }
      // Even if API call fails, clear local session
      rethrow;
    }
  }

  /// Get current user
  User? getCurrentUser() => _supabase.auth.currentUser;

  /// Get current session
  Session? getCurrentSession() => _supabase.auth.currentSession;

  /// Check if user is authenticated
  bool get isAuthenticated => _supabase.auth.currentUser != null;

  /// Listen to auth state changes - Supabase handles session management
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  /// Refresh session - Supabase handles this automatically
  Future<AuthResponse> refreshSession() async {
    try {
      return await _supabase.auth.refreshSession();
    } on AuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Handle Supabase auth exceptions
  String _handleAuthException(AuthException e) {
    if (kDebugMode) {
      debugPrint('Auth Exception: ${e.message}');
    }

    // Map Supabase errors to user-friendly messages
    final message = e.message.toLowerCase();

    if (message.contains('invalid login credentials')) {
      return 'Invalid email or password. Please check your credentials.';
    } else if (message.contains('email not confirmed')) {
      return 'Please check your email and click the confirmation link.';
    } else if (message.contains('user already registered')) {
      return 'An account with this email already exists.';
    } else if (message.contains('password should be at least')) {
      return 'Password must be at least 6 characters long.';
    } else if (message.contains('signup disabled')) {
      return 'Account creation is currently disabled.';
    } else if (message.contains('rate limit')) {
      return 'Too many attempts. Please wait a moment before trying again.';
    } else if (message.contains('weak password')) {
      return 'Please choose a stronger password.';
    } else if (message.contains('invalid email')) {
      return 'Please enter a valid email address.';
    } else {
      return e.message; // Return original message for other cases
    }
  }
}