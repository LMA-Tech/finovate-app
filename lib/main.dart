// lib/main.dart

import 'package:finovate_app/screens/carteira/carteria_screen.dart';
import 'package:finovate_app/screens/conjuntura/conjuntura_screen.dart';
import 'package:finovate_app/screens/feedback/feedback_screen.dart';
import 'package:finovate_app/screens/forgot_password/forgot_password_screen.dart';
import 'package:finovate_app/screens/get_started/get_started_screen.dart';
import 'package:finovate_app/screens/home/home_screen.dart';
import 'package:finovate_app/screens/login/login_screen.dart';
import 'package:finovate_app/screens/onboarding/onboarding_screen.dart';
import 'package:finovate_app/screens/perfil/perfil_screen.dart';
import 'package:finovate_app/screens/signup/signup_screen.dart';
import 'package:finovate_app/screens/stocks/stocks_screen.dart';
import 'package:finovate_app/screens/sofia/sofia_chat_screen.dart';
import 'package:finovate_app/screens/sofia/sofia_home_screen.dart';
import 'package:finovate_app/screens/splash/splash_screen.dart';
import 'package:finovate_app/services/activity_tracker.dart';
import 'package:finovate_app/services/asset_cache_manager.dart';
import 'package:finovate_app/services/auth_service.dart';
import 'package:finovate_app/services/session_manager.dart';
import 'package:finovate_app/controllers/bottom_navigation_controller.dart';
import 'package:finovate_app/utils/constants/routes.dart';
import 'package:finovate_app/utils/theme/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'config/env_config.dart';
import 'services/app_logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Load environment variables
    await EnvConfig.load();

    // Debug configuration in development
    EnvConfig.debugPrintConfig();

    // Validate required configuration
    if (!EnvConfig.isConfigValid) {
      throw Exception('Invalid environment configuration - check .env file');
    }

    // Initialize Supabase
    await Supabase.initialize(
      url: EnvConfig.supabaseUrl,
      anonKey: EnvConfig.supabaseAnonKey,
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
      ),
    );

    // Preload critical assets for better UX
    await AssetCacheManager.preloadCriticalAssets();

    runApp(const FinovateApp());
  } catch (e) {
    AppLogger.error('Initialization error', error: e, tag: 'Main');
    runApp(const ErrorApp());
  }
}

/// Main application widget
class FinovateApp extends StatelessWidget {
  const FinovateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Finovate',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: FinAppTheme.lightTheme,
      darkTheme: FinAppTheme.darkTheme,

      // Initial route
      initialRoute: AppRoutes.splash,

      // Route definitions using AppRoutes constants
      getPages: [
        // ═══════════════════════════════════════════════════════════════
        // AUTHENTICATION FLOW
        // ═══════════════════════════════════════════════════════════════
        GetPage(
          name: AppRoutes.splash,
          page: () => const SplashScreen(),
        ),
        GetPage(
          name: AppRoutes.onboarding,
          page: () => const OnBoardingScreen(),
        ),
        GetPage(
          name: AppRoutes.getStarted,
          page: () => const GetStartedScreen(),
        ),
        GetPage(
          name: AppRoutes.login,
          page: () => const LoginScreen(),
        ),
        GetPage(
          name: AppRoutes.signup,
          page: () => const SignupScreen(),
        ),
        GetPage(
          name: AppRoutes.forgotPassword,
          page: () => const ForgotPasswordScreen(),
        ),

        // ═══════════════════════════════════════════════════════════════
        // MAIN APPLICATION
        // ═══════════════════════════════════════════════════════════════
        GetPage(
          name: AppRoutes.home,
          page: () => const HomeScreen(),
        ),

        // ═══════════════════════════════════════════════════════════════
        // STOCKS SCREENS
        // ═══════════════════════════════════════════════════════════════
        GetPage(
          name: AppRoutes.stocks,
          page: () => const StocksScreen(),
        ),

        // ═══════════════════════════════════════════════════════════════
        // BOTTOM NAVIGATION SCREENS
        // Accessible via HomeScreen's bottom navigation bar
        // ═══════════════════════════════════════════════════════════════
        GetPage(
          name: AppRoutes.carteira,
          page: () => const CarteiraScreen(),
        ),
        GetPage(
          name: AppRoutes.conjuntura,
          page: () => const ConjunturaScreen(),
        ),
        GetPage(
          name: AppRoutes.perfil,
          page: () => const PerfilScreen(),
        ),

        // ═══════════════════════════════════════════════════════════════
        // SOFIA AI ASSISTANT SCREENS
        // Multiple screens for different Sofia interaction modes
        // ═══════════════════════════════════════════════════════════════

        // Sofia Home - Welcome screen (accessed via bottom nav)
        GetPage(
          name: AppRoutes.sofiaHome,
          page: () => const SofiaHomeScreen(),
        ),

        // Sofia Chat - Mock UI for testing chat interface
        GetPage(
          name: AppRoutes.sofiaChat,
          page: () => const SofiaChatScreen(),
        ),

        // ═══════════════════════════════════════════════════════════════
        // FEEDBACK
        // ═══════════════════════════════════════════════════════════════
        GetPage(
          name: AppRoutes.feedback,
          page: () => FeedbackScreen(),
        ),
      ],

      // Initialize global controllers
      initialBinding: BindingsBuilder(() {
        // Core services that persist throughout app lifecycle
        Get.put(AuthService(), permanent: true);
        Get.put(SessionManager(), permanent: true);
        Get.put(ActivityTracker(), permanent: true);
        Get.put(BottomNavigationController(), permanent: true);
      }),
    );
  }
}

/// Error screen displayed when app initialization fails
class ErrorApp extends StatelessWidget {
  const ErrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFF1E2332),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 64,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Failed to Initialize App',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Please check your .env configuration\nand try again',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 24),
                if (kDebugMode)
                  const Text(
                    'Check console for detailed error message',
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}