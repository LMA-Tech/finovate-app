import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class FinChipTheme {
  FinChipTheme._();

  static ChipThemeData lightChipTheme = ChipThemeData(
    disabledColor: FinColors.grey.withOpacity(0.4),
    labelStyle: const TextStyle(color: FinColors.black),
    selectedColor: FinColors.primary,
    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
    checkmarkColor: FinColors.white,
  );

  static ChipThemeData darkChipTheme = const ChipThemeData(
    disabledColor: FinColors.darkerGrey,
    labelStyle: TextStyle(color: FinColors.white),
    selectedColor: FinColors.primary,
    padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
    checkmarkColor: FinColors.white,
  );
}
