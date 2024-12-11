import 'package:flutter/material.dart';
import 'package:finovate_app/utils/theme/theme.dart';
import 'package:get/get.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/home_screen.dart';

void main() => runApp(const FinovateApp());


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
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnBoardingScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
