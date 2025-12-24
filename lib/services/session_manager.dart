import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../controllers/bottom_navigation_controller.dart';
import 'activity_tracker.dart';
import 'app_logger.dart';
import 'biometric_service.dart';

/// Manages user authentication state and session lifecycle
/// Handles Supabase authentication, biometric timeouts, and navigation logic
class SessionManager extends GetxController {
  static const String _tag = 'SessionManager';
  final SupabaseClient _supabase = Supabase.instance.client;

  // ═══════════════════════════════════════════════════════════════════════════════════════
  // STATE MANAGEMENT
  // Observable authentication state that drives UI updates
  // ═══════════════════════════════════════════════════════════════════════════════════════

  /// Whether user is currently authenticated
  final RxBool isAuthenticated = false.obs;

  /// Current authenticated user (null if not authenticated)
  final Rx<User?> currentUser = Rx<User?>(null);

  /// Whether user is currently in the signup flow
  /// Used to prevent automatic navigation during registration
  final RxBool isInSignupFlow = false.obs;

  /// Whether biometric authentication is available and set up on this device
  final RxBool isBiometricAvailable = false.obs;

  /// The type of biometric authentication available (e.g., "Face ID", "Impressão Digital")
  final RxString biometricType = "Biometria".obs;

  bool _manualLogout = false;

  // ═══════════════════════════════════════════════════════════════════════════════════════
  // LIFECYCLE MANAGEMENT
  // Controller initialization and cleanup
  // ═══════════════════════════════════════════════════════════════════════════════════════

  @override
  void onInit() {
    super.onInit();
    _initAuth();
    _initBiometric();
    _setupAppStateListener();
  }

  @override
  void onClose() {
    _cleanupAppStateListener();
    super.onClose();
  }

  // ═══════════════════════════════════════════════════════════════════════════════════════
  // BIOMETRIC INITIALIZATION
  // Setup biometric capabilities detection
  // ═══════════════════════════════════════════════════════════════════════════════════════

  /// Initialize biometric authentication capabilities
  Future<void> _initBiometric() async {
    try {
      final isSetup = await BiometricService.isBiometricSetup();
      final type = await BiometricService.getBiometricType();

      isBiometricAvailable.value = isSetup;
      biometricType.value = type;

      AppLogger.info('Biometric setup complete: available=$isSetup, type=$type', tag: _tag);
    } catch (e) {
      AppLogger.error('Error initializing biometric', error: e, tag: _tag);
      isBiometricAvailable.value = false;
      biometricType.value = "Biometria";
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════════════════
  // AUTHENTICATION INITIALIZATION
  // Setup authentication listeners and initial state
  // ═══════════════════════════════════════════════════════════════════════════════════════

  void _initAuth() {
    // Set initial authentication state
    final user = _supabase.auth.currentUser;
    currentUser.value = user;
    isAuthenticated.value = user != null;

    // Validate session on startup
    if (user != null) {
      validateSession();
    }

    AppLogger.info('SessionManager initialized: user=${user?.email ?? "none"}, authenticated=${user != null}', tag: _tag);

    // Listen to Supabase authentication state changes
    _supabase.auth.onAuthStateChange.listen((data) {
      final user = data.session?.user;
      currentUser.value = user;
      isAuthenticated.value = user != null;

      AppLogger.debug('Auth state changed: event=${data.event}, user=${user?.email ?? "none"}, emailConfirmed=${user?.emailConfirmedAt != null}', tag: _tag);

      // Handle different authentication events
      switch (data.event) {
        case AuthChangeEvent.signedIn:
          _handleSignedIn(user);
          break;
        case AuthChangeEvent.signedOut:
          _handleSignedOut();
          break;
        case AuthChangeEvent.userUpdated:
          AppLogger.verbose('User updated - no navigation needed', tag: _tag);
          break;
        default:
          AppLogger.verbose('Auth event: ${data.event} - no action', tag: _tag);
          break;
      }
    });
  }

  /// Handles successful user sign-in
  /// Manages navigation logic and biometric authentication initialization
  void _handleSignedIn(User? user) {
    if (user?.emailConfirmedAt != null && !isInSignupFlow.value) {
      // Initialize biometric authentication state for new session
      final activityTracker = Get.find<ActivityTracker>();
      activityTracker.markBiometricAuth();

      AppLogger.info('Navigating to home: email confirmed, not in signup flow', tag: _tag);

      try {
        final bottomNav = Get.find<BottomNavigationController>();
        bottomNav.resetToHome();
      } catch (e) {
        AppLogger.warning('Could not reset bottom nav (controller not initialized yet)', tag: _tag);
      }

      Get.offAllNamed('/home');
    } else if (isInSignupFlow.value) {
      AppLogger.debug('Navigation paused: user in signup flow', tag: _tag);
    } else if (user?.emailConfirmedAt == null) {
      AppLogger.debug('Navigation paused: email not confirmed', tag: _tag);
    }
  }

  /// Handles user sign-out
  /// Cleans up state and redirects to get started screen
  void _handleSignedOut() {
    AppLogger.info('User signed out', tag: _tag);

    // Reset all session-related state
    isInSignupFlow.value = false;

    // Clear activity tracking state
    try {
      final activityTracker = Get.find<ActivityTracker>();
      activityTracker.reset();
    } catch (e) {
      AppLogger.warning('ActivityTracker not found during logout', tag: _tag);
    }

    // Only navigate if not a manual logout to login
    if (!_manualLogout) {
      Get.offAllNamed('/getStarted');
    } else {
      AppLogger.debug('Manual logout - not navigating automatically', tag: _tag);
      _manualLogout = false; // Reset flag
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════════════════
  // SESSION TIMEOUT & BIOMETRIC AUTHENTICATION
  // Manage session timeouts and biometric re-authentication
  // ═══════════════════════════════════════════════════════════════════════════════════════

  /// Sets up app lifecycle observer for session timeout checks
  void _setupAppStateListener() {
    WidgetsBinding.instance.addObserver(_AppLifecycleObserver(this));
  }

  /// Cleans up app lifecycle observer
  void _cleanupAppStateListener() {
    // Note: We create a new observer to remove since we don't store the reference
    // This is safe because the observer holds a reference to this SessionManager
    try {
      WidgetsBinding.instance.removeObserver(_AppLifecycleObserver(this));
    } catch (e) {
      AppLogger.warning('Error removing lifecycle observer', error: e, tag: _tag);
    }
  }

  /// Checks if user needs re-authentication based on session timeouts
  /// Called when app returns from background
  Future<void> checkAuthRequirements() async {
    // Skip checks if user is not authenticated
    if (!isAuthenticated.value) {
      AppLogger.verbose('User not authenticated - skipping timeout check', tag: _tag);
      return;
    }

    final activityTracker = Get.find<ActivityTracker>();

    // Check for full re-authentication (based on lastSignInAt)
    if (activityTracker.needsFullReauth) {
      AppLogger.info('Full re-authentication required - signing out user', tag: _tag);
      await signOut();
      return;
    }

    if (activityTracker.needsBiometricAuth) {
      AppLogger.debug('Biometric authentication required', tag: _tag);
      await _performBiometricReauth();
    }
  }

  /// Performs biometric re-authentication with enhanced error handling
  Future<void> _performBiometricReauth() async {
    // Check if biometric is available before attempting
    if (!isBiometricAvailable.value) {
      AppLogger.warning('Biometric not available - signing out user', tag: _tag);
      await signOut();
      return;
    }

    final result = await BiometricService.authenticateWithContext(
      context: BiometricContext.appUnlock,
    );

    if (result.success) {
      Get.find<ActivityTracker>().markBiometricAuth();
      AppLogger.info('Biometric re-authentication successful', tag: _tag);
    } else {
      AppLogger.warning('Biometric re-authentication failed: ${result.errorMessage}', tag: _tag);

      // Handle different error types appropriately
      switch (result.errorType) {
        case BiometricErrorType.userCanceled:
        // User cancelled - sign them out
          await signOut();
          break;
        case BiometricErrorType.lockedOut:
        case BiometricErrorType.permanentlyLockedOut:
        // Biometric locked - sign out for security
          await signOut();
          break;
        case BiometricErrorType.notAvailable:
        case BiometricErrorType.notEnrolled:
        // Biometric not available - sign out
          await signOut();
          break;
        default:
        // Other errors - sign out for safety
          await signOut();
      }
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════════════════
  // PUBLIC METHODS
  // Public API for authentication management
  // ═══════════════════════════════════════════════════════════════════════════════════════

  /// Validate current session and refresh if needed
  Future<void> validateSession() async {
    try {
      // Try to get current session
      final session = _supabase.auth.currentSession;

      if (session != null) {
        // Try to refresh the session (this will fail if user is deleted)
        await _supabase.auth.refreshSession();
        AppLogger.debug('Session validated successfully', tag: _tag);
      }
    } catch (e) {
      AppLogger.error('Session validation failed - logging out', error: e, tag: _tag);

      // Clear invalid session
      await _supabase.auth.signOut();
      currentUser.value = null;
      isAuthenticated.value = false;
    }
  }

  /// Signs out the current user
  /// Triggers Supabase sign-out which will cause _handleSignedOut to be called
  Future<void> signOut() async {
    AppLogger.debug('Manual logout initiated', tag: _tag);

    try {
      await _supabase.auth.signOut();
      AppLogger.info('Logout completed successfully', tag: _tag);
    } catch (e) {
      AppLogger.error('Error during logout', error: e, tag: _tag);
      // Even if logout fails, clean up local state
      _handleSignedOut();
    }
  }

  /// Signs out user for manual logout to login screen
  /// Prevents automatic navigation to get started
  Future<void> signOutToLogin() async {
    AppLogger.debug('Manual logout to login initiated', tag: _tag);

    _manualLogout = true;

    try {
      await _supabase.auth.signOut();
      AppLogger.info('Logout to login completed successfully', tag: _tag);
    } catch (e) {
      AppLogger.error('Error during logout to login', error: e, tag: _tag);
      // Even if logout fails, clean up local state
      _manualLogout = false;
      _handleSignedOut();
    }
  }

  /// Forces biometric re-authentication for sensitive operations
  /// Can be called manually for high-security actions
  Future<bool> requireBiometricAuth({BiometricContext context = BiometricContext.sensitiveAction}) async {
    if (!isAuthenticated.value) return false;

    // Check if biometric is available
    if (!isBiometricAvailable.value) {
      AppLogger.warning('Biometric not available for sensitive action', tag: _tag);
      return false;
    }

    final activityTracker = Get.find<ActivityTracker>();

    // If biometric auth is already recent, allow action
    if (!activityTracker.needsBiometricAuth) {
      return true;
    }

    // Perform biometric authentication with enhanced result handling
    final result = await BiometricService.authenticateWithContext(context: context);

    if (result.success) {
      activityTracker.markBiometricAuth();
      return true;
    } else {
      AppLogger.warning('Biometric auth failed for sensitive action: ${result.errorMessage}', tag: _tag);
      return false;
    }
  }

  /// Refreshes biometric availability status
  /// Useful to call after user might have changed biometric settings
  Future<void> refreshBiometricStatus() async {
    await _initBiometric();
  }

  /// Get current auth token, refreshing if needed
  Future<String?> getAuthToken() async {
    try {
      final session = _supabase.auth.currentSession;

      // Check if token is expired or about to expire
      if (session?.expiresAt != null) {
        final expiresAt = DateTime.fromMillisecondsSinceEpoch(session!.expiresAt! * 1000);
        final now = DateTime.now();

        // If expires within 60 seconds, refresh
        if (expiresAt.difference(now).inSeconds < 60) {
          final refreshed = await _supabase.auth.refreshSession();
          return refreshed.session?.accessToken;
        }
      }

      return session?.accessToken;
    } catch (e) {
      AppLogger.error('Error getting auth token', error: e, tag: _tag);
      return null;
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════════════════
  // UTILITY METHODS
  // Helper methods for state checking and debugging
  // ═══════════════════════════════════════════════════════════════════════════════════════

  /// Checks if we should show the home screen
  /// Used by routing logic to determine appropriate initial route
  bool get shouldShowHome =>
      isAuthenticated.value &&
          currentUser.value?.emailConfirmedAt != null &&
          !isInSignupFlow.value;

  /// Gets user-friendly biometric status for UI display
  String get biometricStatusMessage {
    if (!isBiometricAvailable.value) {
      return "Biometria não disponível";
    }
    return "${biometricType.value} disponível";
  }

  /// Checks if biometric login should be offered to user
  bool get shouldOfferBiometricLogin =>
      isBiometricAvailable.value && !isInSignupFlow.value;

  /// Gets comprehensive authentication capabilities for debugging
  Future<Map<String, dynamic>> getAuthCapabilities() async {
    final biometricCaps = await BiometricService.getBiometricCapabilities();

    return {
      'isAuthenticated': isAuthenticated.value,
      'isInSignupFlow': isInSignupFlow.value,
      'userEmail': currentUser.value?.email,
      'emailConfirmed': currentUser.value?.emailConfirmedAt != null,
      'shouldShowHome': shouldShowHome,
      'biometric': {
        'available': isBiometricAvailable.value,
        'type': biometricType.value,
        'capabilities': biometricCaps,
      },
    };
  }

  /// Prints comprehensive session state for debugging
  void debugCurrentState() {
    AppLogger.debug(
      'Session state: authenticated=${isAuthenticated.value}, user=${currentUser.value?.email ?? "none"}, '
      'emailConfirmed=${currentUser.value?.emailConfirmedAt != null}, signupFlow=${isInSignupFlow.value}, '
      'biometricAvailable=${isBiometricAvailable.value}, biometricType=${biometricType.value}, '
      'shouldShowHome=$shouldShowHome, route=${Get.currentRoute}',
      tag: _tag,
    );

    // Also debug activity tracker state if available
    try {
      final activityTracker = Get.find<ActivityTracker>();
      activityTracker.debugCurrentState();
    } catch (e) {
      AppLogger.verbose('ActivityTracker not available for debug', tag: _tag);
    }
  }

  /// Gets current user's email safely
  String? get userEmail => currentUser.value?.email;

  /// Gets current user's ID safely
  String? get userId => currentUser.value?.id;

  /// Checks if current user's email is confirmed
  bool get isEmailConfirmed => currentUser.value?.emailConfirmedAt != null;

  /// Gets current user's full name from metadata (first_name + last_name)
  String? get userFullName {
    final metadata = currentUser.value?.userMetadata;
    if (metadata == null) return null;

    final firstName = metadata['first_name'] as String?;
    final lastName = metadata['last_name'] as String?;

    if (firstName == null && lastName == null) return null;
    if (firstName == null) return lastName;
    if (lastName == null) return firstName;

    return '$firstName $lastName';
  }

  /// Gets current user's first name from metadata
  String? get userFirstName {
    final metadata = currentUser.value?.userMetadata;
    return metadata?['first_name'] as String?;
  }

  /// Gets current user's profile photo URL from metadata
  String? get userPhotoUrl {
    final metadata = currentUser.value?.userMetadata;
    return metadata?['avatar_url'] as String? ?? metadata?['photo_url'] as String?;
  }

  /// Refreshes the current user data from Supabase
  /// Call this after updating user metadata to get the latest values
  void refreshCurrentUser() {
    currentUser.value = _supabase.auth.currentUser;
  }
}

// ═══════════════════════════════════════════════════════════════════════════════════════
// APP LIFECYCLE OBSERVER
// Handles app backgrounding/foregrounding for session timeout checks
// ═══════════════════════════════════════════════════════════════════════════════════════

class _AppLifecycleObserver extends WidgetsBindingObserver {
  static const String _tag = 'AppLifecycle';
  final SessionManager sessionManager;

  _AppLifecycleObserver(this.sessionManager);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    AppLogger.verbose('App lifecycle state changed: $state', tag: _tag);

    switch (state) {
      case AppLifecycleState.resumed:
        AppLogger.debug('App resumed - checking auth requirements', tag: _tag);
        sessionManager.checkAuthRequirements();
        break;
      case AppLifecycleState.paused:
        AppLogger.verbose('App paused', tag: _tag);
        break;
      case AppLifecycleState.detached:
        AppLogger.verbose('App detached', tag: _tag);
        break;
      case AppLifecycleState.inactive:
        AppLogger.verbose('App inactive', tag: _tag);
        break;
      case AppLifecycleState.hidden:
        AppLogger.verbose('App hidden', tag: _tag);
        break;
    }
  }
}