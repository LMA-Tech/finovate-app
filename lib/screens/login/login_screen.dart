import 'package:finovate_app/common/styles/spacing_styles.dart';
import 'package:finovate_app/screens/login/widgets/login_form.dart';
import 'package:finovate_app/screens/login/widgets/login_header.dart';
import 'package:flutter/material.dart';

import '../../utils/constants/colors.dart';
import '../../utils/helpers/helper_functions.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// App Bar and Back Button
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: FinHelperFunctions.isDarkMode(context)
                ? FinColors.white
                : FinColors.dark,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: const SingleChildScrollView(
        child: Padding(
          padding: FinSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              /// Logo, Title, & Sub-Title
              FinLoginHeader(),

              /// Form
              FinLoginForm(),

              /// Divider
              ///FinFormDivider(dividerText: FinTexts.orSignInWith.capitalize!),
              ///const SizedBox(height: FinSizes.spaceBtwSections),

              /// Footer
              ///const FinSocialButtons()
            ],
          ),
        ),
      ),
    );
  }
}
