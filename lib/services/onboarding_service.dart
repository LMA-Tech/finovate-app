import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class OnboardingService {
  static const _isFirstLaunchKey = 'isFirstLaunch';

  // Singleton pattern using GetX
  static final OnboardingService _instance = OnboardingService._internal();
  factory OnboardingService() => _instance;
  OnboardingService._internal();

  /// Checks if the app is launching for the first time.
  Future<bool> isFirstLaunch() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_isFirstLaunchKey) ?? true;
    } catch (e) {
      // Fall back to showing onboarding if there's an error
      printError(info: 'Error checking first launch: $e');
      return true;
    }
  }

  /// Sets onboarding as complete so it doesn't show again.
  Future<void> completeOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isFirstLaunchKey, false);
    } catch (e) {
      printError(info: 'Error saving onboarding status: $e');
    }
  }
}