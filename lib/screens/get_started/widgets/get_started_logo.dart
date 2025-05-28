import 'package:finovate_app/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../utils/constants/image_strings.dart';
import '../../../utils/helpers/helper_functions.dart';

class GetStartedLogo extends StatelessWidget {
  const GetStartedLogo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = FinHelperFunctions.isDarkMode(context);

    // Calculate responsive dimensions
    final screenWidth = FinHelperFunctions.screenWidth();
    final logoWidth = screenWidth * 0.35; // 35% of screen width

    return SvgPicture.asset(
      dark ? FinImages.darkAppLogo : FinImages.lightAppLogo,
      width: logoWidth,
      fit: BoxFit.contain,
      colorFilter: const ColorFilter.mode(
        FinColors.cyan,
        BlendMode.srcIn,
      ),
    );
  }
}