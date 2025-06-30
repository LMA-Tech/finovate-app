import 'package:flutter/material.dart';

import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_strings.dart';

class FinLoginHeader extends StatelessWidget {
  const FinLoginHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          FinTexts.loginTitle,
          style: TextStyle(
            fontSize: FinSizes.fontSizeLg + 6, // 24px
            fontWeight: FontWeight.w600,
            height: 1.33,
            letterSpacing: -0.48,
            color: Colors.white,
          ),
        ),
        SizedBox(height: FinSizes.sm),
        Text(
          FinTexts.loginSubTitle,
          style: TextStyle(
            color: Color(0xFFDFDFE0), // Neutral-gray-200
            fontSize: FinSizes.fontSizeMd,
            fontWeight: FontWeight.w400,
            height: 1.50,
            letterSpacing: -0.16,
          ),
        ),
      ],
    );
  }
}