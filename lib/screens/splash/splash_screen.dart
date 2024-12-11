import 'package:flutter/material.dart';
import 'package:finovate_app/services/onboarding_service.dart';
import 'package:finovate_app/utils/constants/image_strings.dart';
part 'splash_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  createState() => _SplashScreen();
}

class _SplashScreen extends SplashController {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
            FinImages.lightAppLogo,
          width: 200,
          height: 200,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}