import 'package:flutter/material.dart';

import '../../utils/constants/image_strings.dart';
import '../../utils/helpers/helper_functions.dart';

class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final dark = FinHelperFunctions.isDarkMode(context);

    if (dark) {
      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF252532), // 1%
              Color(0xFF030D2C), // 72%
            ],
            stops: [0.01, 0.72],
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                FinImages.darkAppBgOverlay,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
            child,
          ],
        ),
      );
    }

    return Container(
      color: Colors.white,
      child: child,
    );
  }
}
