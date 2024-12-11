import 'package:flutter/material.dart';
import 'package:finovate_app/utils/constants/colors.dart';
import '../../constants/sizes.dart';

class FinTextFormFieldTheme {
  FinTextFormFieldTheme._();

  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: FinColors.darkGrey,
    suffixIconColor: FinColors.darkGrey,
    // constraints: const BoxConstraints.expand(height: TSizes.inputFieldHeight),
    labelStyle: const TextStyle().copyWith(fontSize: FinSizes.fontSizeMd, color: FinColors.black),
    hintStyle: const TextStyle().copyWith(fontSize: FinSizes.fontSizeSm, color: FinColors.black),
    errorStyle: const TextStyle().copyWith(fontStyle: FontStyle.normal),
    floatingLabelStyle: const TextStyle().copyWith(color: FinColors.black.withOpacity(0.8)),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(FinSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: FinColors.grey),
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(FinSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: FinColors.grey),
    ),
    focusedBorder:const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(FinSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: FinColors.dark),
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(FinSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: FinColors.warning),
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(FinSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 2, color: FinColors.warning),
    ),
  );

  static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 2,
    prefixIconColor: FinColors.darkGrey,
    suffixIconColor: FinColors.darkGrey,
    // constraints: const BoxConstraints.expand(height: FinSizes.inputFieldHeight),
    labelStyle: const TextStyle().copyWith(fontSize: FinSizes.fontSizeMd, color: FinColors.white),
    hintStyle: const TextStyle().copyWith(fontSize: FinSizes.fontSizeSm, color: FinColors.white),
    floatingLabelStyle: const TextStyle().copyWith(color: FinColors.white.withOpacity(0.8)),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(FinSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: FinColors.darkGrey),
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(FinSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: FinColors.darkGrey),
    ),
    focusedBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(FinSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: FinColors.white),
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(FinSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: FinColors.warning),
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(FinSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 2, color: FinColors.warning),
    ),
  );
}
