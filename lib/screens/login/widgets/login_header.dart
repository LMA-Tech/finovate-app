import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_strings.dart';
import '../../../utils/helpers/helper_functions.dart';

class FinLoginHeader extends StatelessWidget {
  const FinLoginHeader({
    super.key,
  });
  
  @override
  Widget build(BuildContext context) {
    final dark = FinHelperFunctions.isDarkMode(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image(
          height: 100,
          image: AssetImage(
              dark ? FinImages.lightAppLogo : FinImages.darkAppLogo),
        ),
        Text(FinTexts.loginTitle,
            style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: FinSizes.sm),
        Text(FinTexts.loginSubTitle,
            style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}