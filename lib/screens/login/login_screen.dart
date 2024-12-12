import 'package:finovate_app/common/styles/spacing_styles.dart';
import 'package:finovate_app/screens/login/widgets/login_form.dart';
import 'package:finovate_app/screens/login/widgets/login_header.dart';
import 'package:finovate_app/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/widgets/login_signup/form_divider.dart';
import '../../common/widgets/login_signup/social_buttons.dart';
import '../../utils/constants/sizes.dart';

part 'login_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  createState() => _LoginScreen();
}

class _LoginScreen extends LoginController {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: FinSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              /// Logo, Title, & Sub-Title
              const FinLoginHeader(),

              /// Form
              const FinLoginForm(),

              /// Divider
              FinFormDivider(dividerText: FinTexts.orSignInWith.capitalize!),
              const SizedBox(height: FinSizes.spaceBtwSections),

              /// Footer
              const FinSocialButtons()
            ],
          ),
        ),
      ),
    );
  }
}








