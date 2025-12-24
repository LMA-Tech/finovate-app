import 'package:supabase_flutter/supabase_flutter.dart';

import 'app_logger.dart';

class AuthService {
  static const String _tag = 'AuthService';
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
      AppLogger.error('Error checking email', error: e, tag: _tag);
      return false;
    }
  }

  /// Check if tax ID (CPF/CNPJ) already exists by querying the users table
  Future<bool> checkTaxIdExists(String taxId) async {
    try {
      // Remove formatting (keep only numbers)
      final cleanTaxId = taxId.replaceAll(RegExp(r'[^\d]'), '');

      final response = await _supabase
          .from('users')
          .select('tax_id')
          .eq('tax_id', cleanTaxId)
          .maybeSingle();

      return response != null;
    } catch (e) {
      AppLogger.error('Error checking tax ID', error: e, tag: _tag);
      return false;
    }
  }

  /// Sign up with complete user data and provider email
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

  /// Sign up with complete user data and provider phone
  Future<AuthResponse> signUpWithPhone({
    required String phoneNumber,
    required String password,
    required Map<String, dynamic> userData,
  }) async {
    try {
      AppLogger.verbose('userData being sent: $userData', tag: _tag);
      final response = await _supabase.auth.signUp(
        phone: phoneNumber,
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

  /// Verify SMS OTP
  Future<AuthResponse> verifySmsOTP({
    required String phoneNumber,
    required String token,
  }) async {
    try {
      final response = await _supabase.auth.verifyOTP(
        type: OtpType.sms,
        token: token,
        phone: phoneNumber,
      );
      return response;
    } on AuthException catch (e) {
      throw _getErrorMessage(e.message);
    } catch (e) {
      throw 'Invalid or expired SMS code';
    }
  }

  /// Resend SMS OTP
  Future<void> resendSmsOTP(String phoneNumber) async {
    try {
      await _supabase.auth.resend(
        type: OtpType.sms,
        phone: phoneNumber,
      );
    } on AuthException catch (e) {
      throw _getErrorMessage(e.message);
    } catch (e) {
      throw 'Failed to resend SMS code';
    }
  }

  /// Verify OTP code for password reset
  Future<AuthResponse> verifyResetOTP({
    required String email,
    required String token,
  }) async {
    try {
      final response = await _supabase.auth.verifyOTP(
        type: OtpType.recovery, // Use recovery type for password reset
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

  /// Update user password after successful OTP verification
  Future<void> updatePassword(String newPassword) async {
    try {
      await _supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );
    } on AuthException catch (e) {
      throw _getErrorMessage(e.message);
    } catch (e) {
      throw 'Failed to update password. Please try again.';
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
      AppLogger.error('Error getting user profile', error: e, tag: _tag);
      return null;
    }
  }

  /// Update user profile in custom users table
  Future<void> updateUserProfile({
    String? firstName,
    String? lastName,
    String? middleName,
    DateTime? birthdate,
    String? taxId,
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
      if (taxId != null) updates['tax_id'] = taxId.trim();
      if (phoneNumber != null) updates['phone_number'] = phoneNumber.trim();

      await _supabase
          .from('users')
          .update(updates)
          .eq('auth_id', userId);
    } catch (e) {
      throw 'Failed to update profile: $e';
    }
  }

  /// Update user metadata in Supabase auth (for immediate UI updates)
  /// Also updates the custom users table for data consistency
  Future<void> updateUserMetadata({
    String? firstName,
    String? lastName,
    String? nickname,
    String? phoneNumber,
    DateTime? birthdate,
  }) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw 'User not authenticated';

      // Build metadata updates
      final metadata = <String, dynamic>{};
      if (firstName != null) metadata['first_name'] = firstName.trim();
      if (lastName != null) metadata['last_name'] = lastName.trim();
      if (nickname != null) metadata['nickname'] = nickname.trim();
      if (phoneNumber != null) metadata['phone_number'] = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
      if (birthdate != null) metadata['birthdate'] = birthdate.toIso8601String();

      if (metadata.isNotEmpty) {
        // Update auth metadata
        await _supabase.auth.updateUser(
          UserAttributes(data: metadata),
        );

        // Also update users table for consistency
        await updateUserProfile(
          firstName: firstName,
          lastName: lastName,
          phoneNumber: phoneNumber,
          birthdate: birthdate,
        );
      }
    } on AuthException catch (e) {
      throw _getErrorMessage(e.message);
    } catch (e) {
      throw 'Falha ao atualizar perfil: $e';
    }
  }

  /// Updates a single user preference in metadata
  Future<void> updateUserPreference(String key, String value) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw 'User not authenticated';

      await _supabase.auth.updateUser(
        UserAttributes(data: {key: value}),
      );
    } on AuthException catch (e) {
      throw _getErrorMessage(e.message);
    } catch (e) {
      throw 'Failed to update preference: $e';
    }
  }

  /// Request email change - sends OTP to new email
  Future<void> requestEmailChange(String newEmail) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw 'Usuário não autenticado';

      // Check if new email already exists
      final exists = await checkEmailExists(newEmail);
      if (exists) {
        throw 'Este e-mail já está em uso';
      }

      // Supabase sends verification email to the new address
      await _supabase.auth.updateUser(
        UserAttributes(email: newEmail.trim().toLowerCase()),
      );
    } on AuthException catch (e) {
      throw _getErrorMessage(e.message);
    } catch (e) {
      if (e is String) rethrow;
      throw 'Falha ao solicitar alteração de e-mail: $e';
    }
  }

  /// Verify email change OTP
  Future<void> verifyEmailChangeOTP({
    required String newEmail,
    required String token,
  }) async {
    try {
      await _supabase.auth.verifyOTP(
        type: OtpType.emailChange,
        token: token,
        email: newEmail.trim().toLowerCase(),
      );

      // Update users table with new email
      final userId = _supabase.auth.currentUser?.id;
      if (userId != null) {
        await _supabase
            .from('users')
            .update({
              'email': newEmail.trim().toLowerCase(),
              'updated_at': DateTime.now().toIso8601String(),
            })
            .eq('auth_id', userId);
      }
    } on AuthException catch (e) {
      throw _getErrorMessage(e.message);
    } catch (e) {
      throw 'Código inválido ou expirado';
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
    } else if (error.contains('duplicate key value violates unique constraint "users_tax_id_key"')) {
      return 'This CPF/CNPJ is already registered';
    } else {
      return error;
    }
  }
}