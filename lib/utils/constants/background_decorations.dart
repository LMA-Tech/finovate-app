import 'package:flutter/material.dart';

import 'colors.dart';

class BackgroundDecorations {
  BackgroundDecorations._();

  // Dark background gradient (use AppBackground widget for full background with overlay)
  static const BoxDecoration darkBackground = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        FinColors.bottomSheetGradientStart,
        FinColors.bottomSheetGradientEnd,
      ],
      stops: [0.01, 0.72],
    ),
  );

  static const BoxDecoration lightBackground = BoxDecoration(
    color: Color(0xFFFFFFFF),
  );
}