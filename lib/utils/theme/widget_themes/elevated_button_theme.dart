import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/sizes.dart';

/* -- Light & Dark Elevated Button Themes -- */
class FinElevatedButtonTheme {
  FinElevatedButtonTheme._(); //To avoid creating instances


  /* -- Light Theme -- */
  static final lightElevatedButtonTheme  = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: FinColors.light,
      backgroundColor: FinColors.primary,
      disabledForegroundColor: FinColors.darkGrey,
      disabledBackgroundColor: FinColors.buttonDisabled,
      side: const BorderSide(color: FinColors.primary),
      padding: const EdgeInsets.symmetric(vertical: FinSizes.buttonHeight),
      textStyle: const TextStyle(fontSize: 16, color: FinColors.textWhite, fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(FinSizes.buttonRadius)),
    ),
  );

  /* -- Dark Theme -- */
  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: FinColors.light,
      backgroundColor: FinColors.primary,
      disabledForegroundColor: FinColors.darkGrey,
      disabledBackgroundColor: FinColors.darkerGrey,
      side: const BorderSide(color: FinColors.primary),
      padding: const EdgeInsets.symmetric(vertical: FinSizes.buttonHeight),
      textStyle: const TextStyle(fontSize: 16, color: FinColors.textWhite, fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(FinSizes.buttonRadius)),
    ),
  );
}
