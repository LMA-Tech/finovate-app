import 'package:flutter/material.dart';
import 'image_strings.dart';

class BackgroundDecorations {
  BackgroundDecorations._();

  // Static decorations - created once, reused everywhere
  static const BoxDecoration darkBackground = BoxDecoration(
    image: DecorationImage(
      image: AssetImage(FinImages.darkAppBg2),
      fit: BoxFit.cover,
    ),
  );

  static const BoxDecoration lightBackground = BoxDecoration(
    color: Color(0xFFFFFFFF), // Your light background color
  );
}