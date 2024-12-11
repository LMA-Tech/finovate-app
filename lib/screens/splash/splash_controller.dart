part of 'splash_screen.dart';

abstract class SplashController extends State<SplashScreen> {
  final OnboardingService _onboardingService = OnboardingService();

  @override
  void initState() {
    super.initState();
    navigateToNextScreen(); // Start navigation after a delay
  }

  void navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3)); // Wait for 3 seconds
    bool isFirstLaunch = await _onboardingService.isFirstLaunch();
    if (isFirstLaunch) {
      await _onboardingService.completeOnboarding();
      Navigator.pushReplacementNamed(context, '/onboarding');
    } else {
      Navigator.pushReplacementNamed(context, '/onboarding');
    }
  }
}