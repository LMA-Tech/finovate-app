// lib/main.dart

import 'package:finovate_app/screens/carteira/carteria_screen.dart';
import 'package:finovate_app/screens/forgot_password/forgot_password_screen.dart';
import 'package:finovate_app/screens/signup/signup_screen.dart';
import 'package:finovate_app/screens/sofia/sofia_chat_screen.dart';
import 'package:finovate_app/screens/sofia/sofia_test_screen.dart';
import 'package:finovate_app/services/activity_tracker.dart';
import 'package:finovate_app/services/asset_cache_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:finovate_app/utils/theme/theme.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'config/env_config.dart';
import 'services/session_manager.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/get_started/get_started_screen.dart';
import 'screens/login/login_screen.dart';
import 'screens/home/home_screen.dart';
import 'services/auth_gate.dart';
import 'controllers/bottom_navigation_controller.dart';
import 'screens/sofia/sofia_home_screen.dart';
import 'screens/conjuntura/conjuntura_screen.dart';
import 'screens/perfil/perfil_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Load environment variables first
    await EnvConfig.load();

    // Debug config in development
    if (kDebugMode) {
      EnvConfig.debugPrintConfig();
    }

    // Validate configuration
    if (!EnvConfig.isConfigValid) {
      throw Exception('Invalid environment configuration');
    }

    // Initialize Supabase with loaded config
    await Supabase.initialize(
      url: EnvConfig.supabaseUrl,
      anonKey: EnvConfig.supabaseAnonKey,
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
      ),
    );

    await AssetCacheManager.preloadCriticalAssets();

    runApp(const FinovateApp());
  } catch (e) {
    if (kDebugMode) {
      debugPrint('Initialization error: $e');
    }
    runApp(const ErrorApp());
  }
}

class FinovateApp extends StatelessWidget {
  const FinovateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Finovate',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: FinAppTheme.lightTheme,
      darkTheme: FinAppTheme.darkTheme,
      home: const SplashScreen(),
      initialBinding: BindingsBuilder(() {
        // Initialize SessionManager once for the entire app
        Get.put(SessionManager(), permanent: true);
        Get.put(ActivityTracker(), permanent: true);
        // Initialize BottomNavigationController for bottom navigation state
        Get.put(BottomNavigationController(), permanent: true);
      }),
      getPages: [
        GetPage(name: '/', page: () => const SplashScreen()),
        GetPage(name: '/onboarding', page: () => const OnBoardingScreen()),
        GetPage(name: '/getStarted', page: () => const GetStartedScreen()),
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/signup', page: () => const SignupScreen()),
        GetPage(name: '/forgotPassword', page: () => const ForgotPasswordScreen()),
        GetPage(name: '/home', page: () => const HomeScreen()),
        GetPage(name: '/auth', page: () => const AuthGate()),

        // Bottom Navigation Routes
        GetPage(name: '/conjuntura', page: () => const ConjunturaScreen()),
        GetPage(name: '/sofia/home', page: () => const SofiaHomeScreen()),
        GetPage(name: '/sofia/test', page: () => const SofiaTestScreen()),
        GetPage(name: '/sofia/chat', page: () => const SofiaChatScreen()),
        GetPage(name: '/carteira', page: () => const CarteiraScreen()),
        GetPage(name: '/perfil', page: () => const PerfilScreen()),
      ],
      // Security: Disable debug banner and overlays in production
      showPerformanceOverlay: false,
      showSemanticsDebugger: false,
    );
  }
}

// Fallback error app
class ErrorApp extends StatelessWidget {
  const ErrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text(
                'Configuration Error',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Please check your app configuration and try again.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // In production, you might want to retry initialization
                  // or contact support
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}