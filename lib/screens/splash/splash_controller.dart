part of 'splash_screen.dart';

abstract class SplashController extends State<SplashScreen> {
  final OnboardingService _onboardingService = OnboardingService();

  @override
  void initState() {
    super.initState();
    // Pre-cache onboarding images for smoother transitions
    _precacheImages();
    // Start navigation after a delay
    navigateToNextScreen();
  }

  // Pre-cache images used in onboarding
  Future<void> _precacheImages() async {
    try {
      await Future.wait([
        precacheImage(const AssetImage(FinImages.onboardingImage1), context),
        precacheImage(const AssetImage(FinImages.onboardingImage2), context),
        precacheImage(const AssetImage(FinImages.onboardingImage3), context),
      ]);
    } catch (e) {
      // Fail silently, as this is just an optimization
      debugPrint('Error precaching onboarding images: $e');
    }
  }

  // Navigate to the appropriate screen based on first launch status
  void navigateToNextScreen() async {
    // Wait for 3 seconds to show splash screen
    await Future.delayed(const Duration(seconds: 3));

    // TEMPORARY FOR TESTING: Always go to onboarding
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/onboarding');
    }

    // // Check if this is the first launch
    // bool isFirstLaunch = await _onboardingService.isFirstLaunch();
    //
    // if (isFirstLaunch) {
    //   // If it's the first launch, show onboarding
    //   // Note: We're NOT marking onboarding as complete here
    //   // That will happen when the user completes or skips onboarding
    //   if (mounted) {
    //     Navigator.pushReplacementNamed(context, '/onboarding');
    //   }
    // } else {
    //   // If not the first launch, go directly to home
    //   if (mounted) {
    //     Navigator.pushReplacementNamed(context, '/home');
    //   }
    // }
  }
}