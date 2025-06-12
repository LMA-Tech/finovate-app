import 'package:flutter/material.dart';
import '../../utils/constants/background_decorations.dart';
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

    return Container(
      decoration: dark
          ? BackgroundDecorations.darkBackground
          : BackgroundDecorations.lightBackground,
      child: child,
    );
  }
}