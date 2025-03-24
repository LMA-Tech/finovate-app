import 'package:get/get.dart';
import '../login/login_screen.dart';
// import '../signup/signup_screen.dart';

class GetStartedController extends GetxController {
  static GetStartedController get instance => Get.find();

  // Navigate to login screen
  void navigateToLogin() {
    Get.to(() => const LoginScreen());
  }

  // Navigate to signup screen
  void navigateToSignup() {
    // Get.to(() => const SignupScreen()); // Create this screen if it doesn't exist yet
  }
}