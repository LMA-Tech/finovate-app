import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/sizes.dart';

class FinSocialButtons extends StatelessWidget {
  const FinSocialButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: FinColors.grey),
              borderRadius: BorderRadius.circular(100)),
          child: IconButton(
            onPressed: () {},
            icon: const Image(
              width: FinSizes.iconMd,
              height: FinSizes.iconMd,
              image: AssetImage(FinImages.google),
            ),
          ),
        ),
        const SizedBox(width: FinSizes.spaceBtwItems),
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: FinColors.grey),
              borderRadius: BorderRadius.circular(100)),
          child: IconButton(
            onPressed: () {},
            icon: const Image(
              width: FinSizes.iconMd,
              height: FinSizes.iconMd,
              image: AssetImage(FinImages.facebook),
            ),
          ),
        ),
      ],
    );
  }
}