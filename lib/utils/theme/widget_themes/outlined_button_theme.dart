import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/sizes.dart';

/* -- Light & Dark Outlined Button Themes -- */
class FinOutlinedButtonTheme {
  FinOutlinedButtonTheme._(); //To avoid creating instances


  /* -- Light Theme -- */
  static final lightOutlinedButtonTheme  = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      elevation: 0,
      foregroundColor: FinColors.dark,
      side: const BorderSide(color: FinColors.borderPrimary),
      textStyle: const TextStyle(fontSize: 16, color: FinColors.black, fontWeight: FontWeight.w600),
      padding: const EdgeInsets.symmetric(vertical: FinSizes.buttonHeight, horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(FinSizes.buttonRadius)),
    ),
  );

  /* -- Dark Theme -- */
  static final darkOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: FinColors.light,
      side: const BorderSide(color: FinColors.borderPrimary),
      textStyle: const TextStyle(fontSize: 16, color: FinColors.textWhite, fontWeight: FontWeight.w600),
      padding: const EdgeInsets.symmetric(vertical: FinSizes.buttonHeight, horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(FinSizes.buttonRadius)),
    ),
  );
}
