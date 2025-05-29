import 'package:flutter/material.dart';
import 'package:finovate_app/utils/constants/image_strings.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../services/onboarding_service.dart';
import '../../utils/constants/colors.dart';
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

    // Calculate responsive dimensions
    final screenWidth = FinHelperFunctions.screenWidth();
    final logoWidth = screenWidth * 0.8; // 30% of screen width

    // Define colors for the loading indicator
    final indicatorColor = dark ? FinColors.white : FinColors.primary;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Logo centered in screen
          Center(
            child: SvgPicture.asset(
              FinImages.darkLogoTipo ,
              width: logoWidth,
              fit: BoxFit.contain,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
            ),
          ),

          // Loading indicator positioned at bottom
          Positioned(
            bottom: 60.0,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: 50, // Control the size of the indicator
                height: 50,
                child: LoadingIndicator(
                  indicatorType: Indicator.ballClipRotatePulse, // Using ballClipRotatePulse animation
                  colors: [indicatorColor],
                  strokeWidth: 3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}