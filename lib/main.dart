import 'package:finovate_app/screens/get_started/get_started_screen.dart';
import 'package:finovate_app/screens/login/login_screen.dart';
import 'package:finovate_app/utils/theme/widget_themes/background_theme.dart';
import 'package:flutter/material.dart';
import 'package:finovate_app/utils/theme/theme.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  // Supabase client setup
  await Supabase.initialize(
      url: "https://utdovjscciieawadlvjg.supabase.co",
      anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InV0ZG92anNjY2lpZWF3YWRsdmpnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjgzNDI0ODUsImV4cCI6MjA0MzkxODQ4NX0.012k5Akg8jJF6rHCO9CbYzD4zxrGr-fxOqLErlbvs3Y"
  );
  runApp(const FinovateApp());
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
      builder: (context, child) {
        // This applies the background to every screen in the app
        return FinThemeBackground(child: child!);
      },
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnBoardingScreen(),
        '/getStarted': (context) => const GetStartedScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}


