import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

class SessionManager extends GetxController {
  final SupabaseClient _supabase = Supabase.instance.client;

  final RxBool isAuthenticated = false.obs;
  final Rx<User?> currentUser = Rx<User?>(null);
  final RxBool isInSignupFlow = false.obs; // ADD THIS LINE

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
        debugPrint('Is in signup flow: ${isInSignupFlow.value}'); // ADD THIS LINE
      }

      // Simple navigation logic - but skip during signup flow
      switch (data.event) {
        case AuthChangeEvent.signedIn:
          if (user?.emailConfirmedAt != null && !isInSignupFlow.value) { // MODIFY THIS LINE
            if (kDebugMode) {
              debugPrint('Auto-navigating to home');
            }
            Get.offAllNamed('/home');
          } else if (isInSignupFlow.value) { // ADD THIS BLOCK
            if (kDebugMode) {
              debugPrint('Skipping auto-navigation - in signup flow');
            }
          }
          break;
        case AuthChangeEvent.signedOut:
          Get.offAllNamed('/getStarted');
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