import 'package:shared_preferences/shared_preferences.dart';

class OnboardingService {
  static const _isFirstLaunchKey = 'isFirstLaunch';

  /// Checks if the app is launching for the first time.
  Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isFirstLaunchKey) ?? true;
  }

  /// Sets onboarding as complete so it doesn’t show again.
  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isFirstLaunchKey, false);
  }
}
