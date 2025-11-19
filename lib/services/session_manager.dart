import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

import '../controllers/bottom_navigation_controller.dart';
import 'activity_tracker.dart';
import 'biometric_service.dart';

/// Manages user authentication state and session lifecycle
/// Handles Supabase authentication, biometric timeouts, and navigation logic
class SessionManager extends GetxController {
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

      if (kDebugMode) {
        debugPrint('🔒 Biometric Setup Complete:');
        debugPrint('  - Available: $isSetup');
        debugPrint('  - Type: $type');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error initializing biometric: $e');
      }
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

    if (kDebugMode) {
      debugPrint('=== SessionManager Inicializado ===');
      debugPrint('Usuário inicial: ${user?.email ?? "Nenhum"}');
      debugPrint('Status de autenticação: ${user != null ? "Autenticado" : "Não autenticado"}');
      debugPrint('Fluxo de cadastro: ${isInSignupFlow.value ? "Ativo" : "Inativo"}');
    }

    // Listen to Supabase authentication state changes
    _supabase.auth.onAuthStateChange.listen((data) {
      final user = data.session?.user;
      currentUser.value = user;
      isAuthenticated.value = user != null;

      if (kDebugMode) {
        debugPrint('=== Mudança de Estado de Autenticação ===');
        debugPrint('Evento: ${data.event}');
        debugPrint('Usuário: ${user?.email ?? "Nenhum"}');
        debugPrint('Email confirmado: ${user?.emailConfirmedAt != null ? "Sim" : "Não"}');
        debugPrint('Fluxo de cadastro: ${isInSignupFlow.value ? "Ativo" : "Inativo"}');
        debugPrint('Rota atual: ${Get.currentRoute}');
      }

      // Handle different authentication events
      switch (data.event) {
        case AuthChangeEvent.signedIn:
          _handleSignedIn(user);
          break;
        case AuthChangeEvent.signedOut:
          _handleSignedOut();
          break;
        case AuthChangeEvent.userUpdated:
          if (kDebugMode) {
            debugPrint('ℹ️ Usuário atualizado - nenhuma navegação necessária');
          }
          break;
        default:
          if (kDebugMode) {
            debugPrint('ℹ️ Evento de autenticação: ${data.event} - nenhuma ação');
          }
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

      if (kDebugMode) {
        debugPrint('✅ Navegando para home: Email confirmado e fora do fluxo de cadastro');
        debugPrint('🔒 Autenticação biométrica inicializada');
      }

      try {
        final bottomNav = Get.find<BottomNavigationController>();
        bottomNav.resetToHome();
      } catch (e) {
        if (kDebugMode) {
          debugPrint('⚠️ Could not reset bottom nav (controller not initialized yet)');
        }
      }

      Get.offAllNamed('/home');
    } else if (isInSignupFlow.value) {
      if (kDebugMode) {
        debugPrint('⏸️ Navegação pausada: Usuário no fluxo de cadastro');
      }
    } else if (user?.emailConfirmedAt == null) {
      if (kDebugMode) {
        debugPrint('⏸️ Navegação pausada: Email não confirmado');
      }
    }
  }

  /// Handles user sign-out
  /// Cleans up state and redirects to get started screen
  void _handleSignedOut() {
    if (kDebugMode) {
      debugPrint('👋 Usuário desconectado');
    }

    // Reset all session-related state
    isInSignupFlow.value = false;

    // Clear activity tracking state
    try {
      final activityTracker = Get.find<ActivityTracker>();
      activityTracker.reset();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ ActivityTracker não encontrado durante logout');
      }
    }

    // Only navigate if not a manual logout to login
    if (!_manualLogout) {
      Get.offAllNamed('/getStarted');
    } else {
      if (kDebugMode) {
        debugPrint('ℹ️ Logout manual - não navegando automaticamente');
      }
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
      if (kDebugMode) {
        debugPrint('⚠️ Erro ao remover observer do ciclo de vida: $e');
      }
    }
  }

  /// Checks if user needs re-authentication based on session timeouts
  /// Called when app returns from background
  Future<void> checkAuthRequirements() async {
    // Skip checks if user is not authenticated
    if (!isAuthenticated.value) {
      if (kDebugMode) {
        debugPrint('ℹ️ Usuário não autenticado - pulando verificação de timeout');
      }
      return;
    }

    final activityTracker = Get.find<ActivityTracker>();

    // Check for full re-authentication (based on lastSignInAt)
    if (activityTracker.needsFullReauth) {
      if (kDebugMode) {
        debugPrint('🔐 Re-autenticação completa necessária - desconectando usuário');
      }
      await signOut();
      return;
    }

    if (activityTracker.needsBiometricAuth) {
      if (kDebugMode) {
        debugPrint('👆 Autenticação biométrica necessária');
      }

      await _performBiometricReauth();
    }
  }

  /// Performs biometric re-authentication with enhanced error handling
  Future<void> _performBiometricReauth() async {
    // Check if biometric is available before attempting
    if (!isBiometricAvailable.value) {
      if (kDebugMode) {
        debugPrint('⚠️ Biometric not available - signing out user');
      }
      await signOut();
      return;
    }

    final result = await BiometricService.authenticateWithContext(
      context: BiometricContext.appUnlock,
    );

    if (result.success) {
      Get.find<ActivityTracker>().markBiometricAuth();
      if (kDebugMode) {
        debugPrint('✅ Biometric re-authentication successful');
      }
    } else {
      if (kDebugMode) {
        debugPrint('❌ Biometric re-authentication failed: ${result.errorMessage}');
      }

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

        if (kDebugMode) {
          debugPrint('✅ Session validated successfully');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Session validation failed: $e');
        debugPrint('🔄 Logging out invalid session');
      }

      // Clear invalid session
      await _supabase.auth.signOut();
      currentUser.value = null;
      isAuthenticated.value = false;
    }
  }

  /// Signs out the current user
  /// Triggers Supabase sign-out which will cause _handleSignedOut to be called
  Future<void> signOut() async {
    if (kDebugMode) {
      debugPrint('=== Logout Manual Iniciado ===');
    }

    try {
      await _supabase.auth.signOut();

      if (kDebugMode) {
        debugPrint('✅ Logout concluído com sucesso');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Erro durante logout: $e');
      }
      // Even if logout fails, clean up local state
      _handleSignedOut();
    }
  }

  /// Signs out user for manual logout to login screen
  /// Prevents automatic navigation to get started
  Future<void> signOutToLogin() async {
    if (kDebugMode) {
      debugPrint('=== Logout Manual para Login ===');
    }

    _manualLogout = true;

    try {
      await _supabase.auth.signOut();

      if (kDebugMode) {
        debugPrint('✅ Logout para login concluído com sucesso');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Erro durante logout para login: $e');
      }
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
      if (kDebugMode) {
        debugPrint('⚠️ Biometric not available for sensitive action');
      }
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
      if (kDebugMode) {
        debugPrint('❌ Biometric auth failed for sensitive action: ${result.errorMessage}');
      }
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
      debugPrint('Error getting auth token: $e');
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
    if (kDebugMode) {
      debugPrint('=== Estado Atual da Sessão ===');
      debugPrint('Autenticado: ${isAuthenticated.value ? "Sim" : "Não"}');
      debugPrint('Usuário: ${currentUser.value?.email ?? "Nenhum"}');
      debugPrint('Email confirmado: ${currentUser.value?.emailConfirmedAt != null ? "Sim" : "Não"}');
      debugPrint('Fluxo de cadastro: ${isInSignupFlow.value ? "Ativo" : "Inativo"}');
      debugPrint('Biometria disponível: ${isBiometricAvailable.value ? "Sim" : "Não"}');
      debugPrint('Tipo de biometria: ${biometricType.value}');
      debugPrint('Deve mostrar home: ${shouldShowHome ? "Sim" : "Não"}');
      debugPrint('Rota atual: ${Get.currentRoute}');
      debugPrint('===============================');

      // Also debug activity tracker state if available
      try {
        final activityTracker = Get.find<ActivityTracker>();
        activityTracker.debugCurrentState();
      } catch (e) {
        debugPrint('⚠️ ActivityTracker não disponível para debug');
      }
    }
  }

  /// Gets current user's email safely
  String? get userEmail => currentUser.value?.email;

  /// Gets current user's ID safely
  String? get userId => currentUser.value?.id;

  /// Checks if current user's email is confirmed
  bool get isEmailConfirmed => currentUser.value?.emailConfirmedAt != null;
}

// ═══════════════════════════════════════════════════════════════════════════════════════
// APP LIFECYCLE OBSERVER
// Handles app backgrounding/foregrounding for session timeout checks
// ═══════════════════════════════════════════════════════════════════════════════════════

class _AppLifecycleObserver extends WidgetsBindingObserver {
  final SessionManager sessionManager;

  _AppLifecycleObserver(this.sessionManager);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (kDebugMode) {
      debugPrint('📱 Estado do app alterado: $state');
    }

    switch (state) {
      case AppLifecycleState.resumed:
        if (kDebugMode) {
          debugPrint('📱 App retomado - verificando requisitos de autenticação');
        }
        sessionManager.checkAuthRequirements();
        break;
      case AppLifecycleState.paused:
        if (kDebugMode) {
          debugPrint('📱 App pausado');
        }
        break;
      case AppLifecycleState.detached:
        if (kDebugMode) {
          debugPrint('📱 App desanexado');
        }
        break;
      case AppLifecycleState.inactive:
        if (kDebugMode) {
          debugPrint('📱 App inativo');
        }
        break;
      case AppLifecycleState.hidden:
        if (kDebugMode) {
          debugPrint('📱 App oculto');
        }
        break;
    }
  }
}