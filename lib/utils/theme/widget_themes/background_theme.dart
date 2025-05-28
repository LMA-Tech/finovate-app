import 'package:flutter/material.dart';
import '../../constants/image_strings.dart';
import '../../helpers/helper_functions.dart';
import '/../../utils/constants/colors.dart';

class FinThemeBackground extends StatelessWidget {
  final Widget child;

  const FinThemeBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final dark = FinHelperFunctions.isDarkMode(context);

    if (dark) {
      return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(FinImages.darkAppBg2), // Use your dark background image
            fit: BoxFit.cover, // Cover the entire screen
          ),
        ),
        child: child,
      );
    }
      // Dark theme gradient
    //   return Container(
    //     decoration: const BoxDecoration(
    //       gradient: LinearGradient(
    //         begin: Alignment.topCenter,
    //         end: Alignment.bottomCenter,
    //         colors: [
    //           FinColors.navy,             // Start with blue at the top
    //           FinColors.darkNavy,         // Transition
    //           FinColors.darkNavy,        // Transition
    //           FinColors.darkNavy,        // End
    //         ],
    //         stops: [0.0, 0.3, 0.7, 1.0], // Control the position of each color
    //       ),
    //     ),
    //     child: child,
    //   );
    // }
    else {
      // Light theme background (add a light gradient here later)
      return Container(
        color: FinColors.white, // Or whatever light background you want
        child: child,
      );
    }
  }
}