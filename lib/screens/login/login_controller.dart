import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/auth_service.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  // Get Auth Service
  final authService = AuthService();

  // Text Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Login function
  void login(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    try {
      await authService.loginWithEmailPassword(email, password);

      // Redirect to another screen here using Get.to() or similar
    } catch (e) {
      // Show error using context
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  void onClose() {
    // Clean up controllers when the LoginController is destroyed
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
