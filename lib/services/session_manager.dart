import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

class SessionManager extends GetxController {
  final SupabaseClient _supabase = Supabase.instance.client;

  final RxBool isAuthenticated = false.obs;
  final Rx<User?> currentUser = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    _initAuth();
  }

  void _initAuth() {
    // Set initial state
    final user = _supabase.auth.currentUser;
    currentUser.value = user;
    isAuthenticated.value = user != null;

    // Listen to auth changes - Supabase handles all session management
    _supabase.auth.onAuthStateChange.listen((data) {
      final user = data.session?.user;
      currentUser.value = user;
      isAuthenticated.value = user != null;

      if (kDebugMode) {
        debugPrint('Auth changed: ${data.event} - User: ${user?.email}');
      }

      // Simple navigation logic
      switch (data.event) {
        case AuthChangeEvent.signedIn:
          if (user?.emailConfirmedAt != null) {
            Get.offAllNamed('/home');
          }
          break;
        case AuthChangeEvent.signedOut:
          Get.offAllNamed('/login');
          break;
        default:
          break;
      }
    });
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}