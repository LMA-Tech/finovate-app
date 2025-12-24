part of 'splash_screen.dart';

abstract class SplashController extends State<SplashScreen> {
  static const String _tag = 'SplashController';
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
      AppLogger.warning('Error precaching onboarding images', error: e, tag: _tag);
    }
  }

  void navigateToNextScreen() async {
    AppLogger.debug('Starting navigation logic', tag: _tag);

    // Show splash for 3 seconds
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    // Check authentication state first
    final user = Supabase.instance.client.auth.currentUser;
    AppLogger.debug('Current user: ${user?.email ?? 'null'}', tag: _tag);

    if (user != null) {
      // User is authenticated, go to home
      AppLogger.info('User authenticated - going to home', tag: _tag);
      Get.offAllNamed(AppRoutes.home);
      return;
    }

    // User not authenticated, check if first launch
    AppLogger.debug('User not authenticated - checking first launch', tag: _tag);
    bool isFirstLaunch = await _onboardingService.isFirstLaunch();
    AppLogger.debug('Is first launch: $isFirstLaunch', tag: _tag);

    if (isFirstLaunch) {
      // First launch, show onboarding
      AppLogger.info('Going to onboarding', tag: _tag);
      Get.offAllNamed(AppRoutes.onboarding);
    } else {
      // Not first launch, show get started screen
      AppLogger.info('Going to get started', tag: _tag);
      Get.offAllNamed(AppRoutes.getStarted);
    }
  }
}