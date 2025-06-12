import 'package:finovate_app/screens/login/widgets/login_form.dart';
import 'package:finovate_app/screens/login/widgets/login_header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../common/styles/spacing_styles.dart';
import '../../common/widgets/app_background.dart';
import '../../utils/constants/colors.dart';
import '../../utils/helpers/helper_functions.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        /// App Bar and Back Button
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.chevron_left,
              color: FinHelperFunctions.isDarkMode(context)
                  ? FinColors.white
                  : FinColors.dark,
            ),
            onPressed: () {
              // Check if we came from Get Started
              if (Get.previousRoute == '/getStarted' || Get.previousRoute.isEmpty) {
                Get.back();
              } else {
                // Fallback to Get Started if navigation stack is unclear
                Get.offAllNamed('/getStarted');
              }
            },
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),

        body: const SingleChildScrollView(  // REMOVE: AppBackground from here
          child: Padding(
            padding: FinSpacingStyle.paddingWithAppBarHeight,
            child: Column(
              children: [
                /// Logo, Title, & Sub-Title
                FinLoginHeader(),

                /// Form
                FinLoginForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}