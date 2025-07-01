
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Check if email already exists by querying the users table
  Future<bool> checkEmailExists(String email) async {
    try {
      final response = await _supabase
          .from('users')
          .select('email')
          .eq('email', email.trim().toLowerCase())
          .maybeSingle();

      return response != null;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error checking email: $e');
      }
      return false;
    }
  }

  /// Check if CPF already exists by querying the users table
  Future<bool> checkCpfExists(String cpf) async {
    try {
      // Remove formatting from CPF (keep only numbers)
      final cleanCpf = cpf.replaceAll(RegExp(r'[^\d]'), '');

      final response = await _supabase
          .from('users')
          .select('cpf')
          .eq('cpf', cleanCpf)
          .maybeSingle();

      return response != null;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error checking CPF: $e');
      }
      return false;
    }
  }

  /// Sign up with complete user data
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required Map<String, dynamic> userData,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email.trim().toLowerCase(),
        password: password,
        data: userData,
      );
      return response;
    } on AuthException catch (e) {
      throw _getErrorMessage(e.message);
    } catch (e) {
      throw 'Connection error. Please check your internet and try again.';
    }
  }

  /// Verify OTP code
  Future<AuthResponse> verifyOTP({
    required String email,
    required String token,
  }) async {
    try {
      final response = await _supabase.auth.verifyOTP(
        type: OtpType.signup,
        token: token,
        email: email,
      );
      return response;
    } on AuthException catch (e) {
      throw _getErrorMessage(e.message);
    } catch (e) {
      throw 'Invalid or expired code';
    }
  }

  /// Resend OTP
  Future<void> resendOTP(String email) async {
    try {
      await _supabase.auth.resend(
        type: OtpType.signup,
        email: email,
      );
    } on AuthException catch (e) {
      throw _getErrorMessage(e.message);
    } catch (e) {
      throw 'Failed to resend code';
    }
  }

  /// Login remains the same
  Future<AuthResponse> login(String email, String password) async {
    try {
      return await _supabase.auth.signInWithPassword(
        email: email.trim().toLowerCase(),
        password: password,
      );
    } on AuthException catch (e) {
      throw _getErrorMessage(e.message);
    }
  }

  /// Get user profile from custom users table
  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return null;

      final response = await _supabase
          .from('users')
          .select()
          .eq('auth_id', userId)
          .single();

      return response;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error getting user profile: $e');
      }
      return null;
    }
  }

  /// Update user profile in custom users table
  Future<void> updateUserProfile({
    String? firstName,
    String? lastName,
    String? middleName,
    DateTime? birthdate,
    String? cpf,
    String? phoneNumber,
  }) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw 'User not authenticated';

      final updates = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (firstName != null) updates['first_name'] = firstName.trim();
      if (lastName != null) updates['last_name'] = lastName.trim();
      if (middleName != null) updates['middle_name'] = middleName.trim();
      if (birthdate != null) updates['birthdate'] = birthdate.toIso8601String().split('T')[0]; // Date only
      if (cpf != null) updates['cpf'] = cpf.trim();
      if (phoneNumber != null) updates['phone_number'] = phoneNumber.trim();

      await _supabase
          .from('users')
          .update(updates)
          .eq('auth_id', userId);
    } catch (e) {
      throw 'Failed to update profile: $e';
    }
  }

  /// Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email.trim().toLowerCase());
    } on AuthException catch (e) {
      if (e.message.contains('Email rate limit exceeded')) {
        throw 'Muitas tentativas de redefinição. Tente novamente em alguns minutos.';
      }
      throw _getErrorMessage(e.message);
    }
  }

  /// Sign out
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  /// Current user getters
  User? get currentUser => _supabase.auth.currentUser;
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;
  bool get isAuthenticated => _supabase.auth.currentUser != null;

  /// Error handling
  String _getErrorMessage(String error) {
    if (error.contains('Invalid login credentials')) {
      return 'Invalid email or password';
    } else if (error.contains('Email not confirmed')) {
      return 'Please verify your email first';
    } else if (error.contains('User already registered')) {
      return 'Email already exists';
    } else if (error.contains('duplicate key value violates unique constraint "users_email_key"')) {
      return 'This email is already registered';
    } else if (error.contains('duplicate key value violates unique constraint "users_cpf_key"')) {
      return 'This CPF is already registered';
    } else {
      return error;
    }
  }
}