
import 'package:flutter/cupertino.dart';

import '../../utils/constants/image_strings.dart';
import '../../utils/helpers/helper_functions.dart';

class FinDarkBg extends StatelessWidget {
  const FinDarkBg({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = FinHelperFunctions.isDarkMode(context);
    if (dark) {
      return Stack(
        children: [
          /// SVG Background
          Positioned.fill(
            child: Image.asset(
              FinImages.darkAppBg2, // Ensure this is a PNG
              fit: BoxFit.cover, // Cover the entire screen
            ),
          ),
        ],
      );
    }
    return const SizedBox.shrink(); // Return an empty widget when dark mode is false
  }
}
