import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

class SessionManager extends GetxController {
  final SupabaseClient _supabase = Supabase.instance.client;

  final RxBool isAuthenticated = false.obs;
  final Rx<User?> currentUser = Rx<User?>(null);
  final RxBool isInSignupFlow = false.obs;

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

    if (kDebugMode) {
      debugPrint('=== SessionManager Init ===');
      debugPrint('Initial user: ${user?.email}');
      debugPrint('Initial auth status: ${user != null}');
      debugPrint('Initial signup flow: ${isInSignupFlow.value}');
    }

    // Listen to auth changes - Supabase handles all session management
    _supabase.auth.onAuthStateChange.listen((data) {
      final user = data.session?.user;
      currentUser.value = user;
      isAuthenticated.value = user != null;

      if (kDebugMode) {
        debugPrint('=== Auth State Changed ===');
        debugPrint('Event: ${data.event}');
        debugPrint('User: ${user?.email}');
        debugPrint('Email confirmed: ${user?.emailConfirmedAt != null}');
        debugPrint('Is in signup flow: ${isInSignupFlow.value}');
        debugPrint('Current route: ${Get.currentRoute}');
      }

      // Navigation logic based on auth state
      switch (data.event) {
        case AuthChangeEvent.signedIn:
          _handleSignedIn(user);
          break;
        case AuthChangeEvent.signedOut:
          _handleSignedOut();
          break;
        case AuthChangeEvent.userUpdated:
          if (kDebugMode) {
            debugPrint('User updated - no navigation action needed');
          }
          break;
        default:
          if (kDebugMode) {
            debugPrint('Other auth event: ${data.event} - no action');
          }
          break;
      }
    });
  }

  void _handleSignedIn(User? user) {
    if (user?.emailConfirmedAt != null && !isInSignupFlow.value) {
      if (kDebugMode) {
        debugPrint('✅ Auto-navigating to home: Email confirmed and not in signup flow');
      }
      Get.offAllNamed('/home');
    } else if (isInSignupFlow.value) {
      if (kDebugMode) {
        debugPrint('⏸️ Skipping auto-navigation: User is in signup flow');
      }
    } else if (user?.emailConfirmedAt == null) {
      if (kDebugMode) {
        debugPrint('⏸️ Skipping auto-navigation: Email not confirmed yet');
      }
    }
  }

  void _handleSignedOut() {
    if (kDebugMode) {
      debugPrint('👋 User signed out - redirecting to get started');
    }
    isInSignupFlow.value = false; // Clear signup flow on logout
    Get.offAllNamed('/getStarted');
  }

  Future<void> signOut() async {
    if (kDebugMode) {
      debugPrint('=== Manual Sign Out ===');
    }
    await _supabase.auth.signOut();
  }

  /// Helper method to check if we should show the home screen
  bool get shouldShowHome => isAuthenticated.value &&
      currentUser.value?.emailConfirmedAt != null &&
      !isInSignupFlow.value;

  /// Helper method for debugging
  void debugCurrentState() {
    if (kDebugMode) {
      debugPrint('=== Current Session State ===');
      debugPrint('Authenticated: ${isAuthenticated.value}');
      debugPrint('User: ${currentUser.value?.email}');
      debugPrint('Email confirmed: ${currentUser.value?.emailConfirmedAt != null}');
      debugPrint('In signup flow: ${isInSignupFlow.value}');
      debugPrint('Should show home: $shouldShowHome');
      debugPrint('Current route: ${Get.currentRoute}');
    }
  }
}