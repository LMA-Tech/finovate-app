import 'package:flutter/material.dart';
import 'package:finovate_app/utils/constants/sizes.dart';
import '../../constants/colors.dart';

class FinAppBarTheme{
  FinAppBarTheme._();

  static const lightAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    iconTheme: IconThemeData(color: FinColors.black, size: FinSizes.iconMd),
    actionsIconTheme: IconThemeData(color: FinColors.black, size: FinSizes.iconMd),
    titleTextStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: FinColors.black),
  );
  static const darkAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    iconTheme: IconThemeData(color: FinColors.black, size: FinSizes.iconMd),
    actionsIconTheme: IconThemeData(color: FinColors.white, size: FinSizes.iconMd),
    titleTextStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: FinColors.white),
  );
}