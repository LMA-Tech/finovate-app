import 'package:get/get.dart';
import '../login/login_screen.dart';
import '../signup/signup_screen.dart';

class GetStartedController extends GetxController {
  static GetStartedController get instance => Get.find();

  // Navigate to login screen
  void navigateToLogin() {
    Get.toNamed('/login'); // Use named route instead of Get.to()
  }

  // Navigate to signup screen
  void navigateToSignup() {
    Get.toNamed('/signup'); // Use named route instead of Get.to()
  }
}