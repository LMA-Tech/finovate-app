import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Sign in with email and password
  Future<AuthResponse> loginWithEmailPassword(String email,
      String password) async {
    return await _supabase.auth.signInWithPassword(
        email: email,
        password: password
    );
  }

  /// Sign up with all required attributes
  Future<AuthResponse> signUpWithAttributes(String email,
      String password,
      String given_name,
      String birthdate,
      String middle_name,
      String family_name,
      String cpf) async {
    return await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'given_name': given_name,
          'birthdate': birthdate,
          'middle_name': middle_name,
          'family_name': family_name,
          'cpf': cpf,
        }
    );
  }

  /// Sign out
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  /// Get user email
  String? getCurrentUserEmail() {
    final session = _supabase.auth.currentSession;
    final user = session?.user;
    return user?.email;
  }
}
