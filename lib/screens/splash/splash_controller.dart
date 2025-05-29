part of 'splash_screen.dart';

abstract class SplashController extends State<SplashScreen> {
  final OnboardingService _onboardingService = OnboardingService();

  @override
  void initState() {
    super.initState();
    navigateToNextScreen();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _precacheImages();
  }

  Future<void> _precacheImages() async {
    try {
      await Future.wait([
        precacheImage(const AssetImage(FinImages.onboardingImage1), context),
        precacheImage(const AssetImage(FinImages.onboardingImage2), context),
        precacheImage(const AssetImage(FinImages.onboardingImage3), context),
      ]);
    } catch (e) {
      debugPrint('Error precaching onboarding images: $e');
    }
  }

  void navigateToNextScreen() async {
    // Show splash for 3 seconds
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    // Check authentication state first
    final user = Supabase.instance.client.auth.currentUser;

    if (user != null) {
      // User is authenticated, go to home
      Get.offAllNamed('/home');
      return;
    }

    // User not authenticated, check if first launch
    bool isFirstLaunch = await _onboardingService.isFirstLaunch();

    if (isFirstLaunch) {
      // First launch, show onboarding
      Get.offAllNamed('/onboarding');
    } else {
      // Not first launch, show get started screen
      Get.offAllNamed('/getStarted');
    }
  }
}