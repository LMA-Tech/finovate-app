import 'package:flutter/material.dart';
import 'package:finovate_app/utils/theme/widget_themes/appbar_theme.dart';
import 'package:finovate_app/utils/theme/widget_themes/bottom_sheet_theme.dart';
import 'package:finovate_app/utils/theme/widget_themes/checkbox_theme.dart';
import 'package:finovate_app/utils/theme/widget_themes/chip_theme.dart';
import 'package:finovate_app/utils/theme/widget_themes/elevated_button_theme.dart';
import 'package:finovate_app/utils/theme/widget_themes/outlined_button_theme.dart';
import 'package:finovate_app/utils/theme/widget_themes/text_field_theme.dart';
import 'package:finovate_app/utils/theme/widget_themes/text_theme.dart';

import '../constants/colors.dart';

class FinAppTheme {
  FinAppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'DMSans',
    disabledColor: FinColors.grey,
    brightness: Brightness.light,
    primaryColor: FinColors.primary,
    textTheme: FinTextTheme.lightTextTheme,
    chipTheme: FinChipTheme.lightChipTheme,
    scaffoldBackgroundColor: Colors.transparent,
    appBarTheme: FinAppBarTheme.lightAppBarTheme,
    checkboxTheme: FinCheckboxTheme.lightCheckboxTheme,
    bottomSheetTheme: FinBottomSheetTheme.lightBottomSheetTheme,
    elevatedButtonTheme: FinElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: FinOutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: FinTextFormFieldTheme.lightInputDecorationTheme,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'DMSans',
    disabledColor: FinColors.grey,
    brightness: Brightness.dark,
    primaryColor: FinColors.primary,
    textTheme: FinTextTheme.darkTextTheme,
    chipTheme: FinChipTheme.darkChipTheme,
    scaffoldBackgroundColor: Colors.transparent,
    appBarTheme: FinAppBarTheme.darkAppBarTheme,
    checkboxTheme: FinCheckboxTheme.darkCheckboxTheme,
    bottomSheetTheme: FinBottomSheetTheme.darkBottomSheetTheme,
    elevatedButtonTheme: FinElevatedButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: FinOutlinedButtonTheme.darkOutlinedButtonTheme,
    inputDecorationTheme: FinTextFormFieldTheme.darkInputDecorationTheme,
  );




}
