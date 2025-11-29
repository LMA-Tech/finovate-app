import 'package:get/get.dart';

import '../../utils/constants/routes.dart';

class GetStartedController extends GetxController {
  static GetStartedController get instance => Get.find();

  // Navigate to login screen
  void navigateToLogin() {
    Get.toNamed(AppRoutes.login);
  }

  // Navigate to signup screen
  void navigateToSignup() {
    Get.toNamed(AppRoutes.signup);
  }
}