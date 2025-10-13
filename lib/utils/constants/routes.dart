/// Application route constants
///
/// Centralized route definitions for type-safe navigation.
/// All routes must be registered in main.dart getPages.
class AppRoutes {
  // Prevent instantiation
  AppRoutes._();

  // ═══════════════════════════════════════════════════════════════
  // AUTHENTICATION FLOW
  // ═══════════════════════════════════════════════════════════════

  /// Splash screen - Initial loading screen
  static const String splash = '/';

  /// Onboarding - First-time user introduction
  static const String onboarding = '/onboarding';

  /// Get Started - Choice between login/signup
  static const String getStarted = '/getStarted';

  /// Login screen
  static const String login = '/login';

  /// Signup flow (multi-step)
  static const String signup = '/signup';

  /// Forgot password flow
  static const String forgotPassword = '/forgotPassword';

  // ═══════════════════════════════════════════════════════════════
  // MAIN APPLICATION
  // ═══════════════════════════════════════════════════════════════

  /// Home screen (main dashboard)
  static const String home = '/home';

  // ═══════════════════════════════════════════════════════════════
  // BOTTOM NAVIGATION SCREENS
  // Accessible via bottom navigation bar from home
  // ═══════════════════════════════════════════════════════════════

  /// Portfolio screen (Carteira)
  static const String carteira = '/carteira';

  /// Market analysis screen (Conjuntura)
  static const String conjuntura = '/conjuntura';

  /// User profile screen
  static const String perfil = '/perfil';

  // ═══════════════════════════════════════════════════════════════
  // SOFIA AI ASSISTANT SCREENS
  // Multiple screens for different interaction modes
  // ═══════════════════════════════════════════════════════════════

  /// Sofia Home - Welcome/landing screen (accessed via bottom nav)
  static const String sofiaHome = '/sofiaHome';

  /// Sofia Chat - Main chat interface with mock responses
  static const String sofiaChat = '/sofia/chat';

  /// Sofia Test - Backend integration test screen
  /// TODO: Remove before production deployment
  static const String sofiaTest = '/sofia/test';

  // ═══════════════════════════════════════════════════════════════
  // HELPER LISTS
  // For validation and utilities
  // ═══════════════════════════════════════════════════════════════

  /// All valid application routes
  static const List<String> allRoutes = [
    splash,
    onboarding,
    getStarted,
    login,
    signup,
    forgotPassword,
    home,
    carteira,
    conjuntura,
    perfil,
    sofiaHome,
    sofiaChat,
    sofiaTest,
  ];

  /// Bottom navigation accessible routes
  static const List<String> bottomNavRoutes = [
    home,
    conjuntura,
    sofiaHome,
    carteira,
    perfil,
  ];

  /// Routes that require authentication
  static const List<String> protectedRoutes = [
    home,
    carteira,
    conjuntura,
    perfil,
    sofiaHome,
    sofiaChat,
    sofiaTest,
  ];

  /// Public routes (no authentication required)
  static const List<String> publicRoutes = [
    splash,
    onboarding,
    getStarted,
    login,
    signup,
    forgotPassword,
  ];
}