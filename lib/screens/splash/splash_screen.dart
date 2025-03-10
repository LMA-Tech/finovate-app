import 'package:flutter/material.dart';
import 'package:finovate_app/services/onboarding_service.dart';
import 'package:finovate_app/utils/constants/image_strings.dart';
import 'package:flutter_svg/svg.dart';

import '../../common/styles/dark_mode_bg.dart';
import '../../utils/helpers/helper_functions.dart';
part 'splash_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  createState() => _SplashScreen();
}

class _SplashScreen extends SplashController {
  @override
  Widget build(BuildContext context) {
    final dark = FinHelperFunctions.isDarkMode(context);
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          /// If dark mode, apply background theme
          const FinDarkBg(),

          /// Centered Logo
          Center(
            child: SvgPicture.asset(
              dark ? FinImages.lightAppLogo : FinImages.darkAppLogo,
              width: FinHelperFunctions.screenWidth() * 0.2, // Scale to 30% of screen width
              fit: BoxFit.contain, // Ensures the logo scales proportionally
            ),
          ),
        ],
      ),
    );
  }
}

