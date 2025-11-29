import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';
import 'signup_continue_button.dart';

/// Reusable milestone screen template for signup flow
///
/// Used for:
/// - Success screen (Step 6: "Conta criada com sucesso")
/// - Questionnaire intro (Step 7: "Queremos te conhecer!")
/// - Final welcome (Step 11: "Seja bem-vindo")
///
/// Features:
/// - Logo at top (configurable size)
/// - Optional illustration (SVG)
/// - Title text
/// - Subtitle text
/// - Single action button
class SignupMilestoneScreen extends StatelessWidget {
  /// Size of the logo at the top
  final double logoHeight;

  /// Optional illustration to show (SVG asset path)
  /// If null, no illustration is shown
  final String? illustration;

  /// Height of the illustration (if provided)
  final double? illustrationHeight;

  /// Title text (e.g., "Conta criada com sucesso, Bernardo!")
  final String title;

  /// Subtitle text
  final String subtitle;

  /// Button text
  final String buttonText;

  /// Whether to show arrow on button
  final bool showButtonArrow;

  /// Button action
  final VoidCallback onButtonPressed;

  const SignupMilestoneScreen({
    super.key,
    this.logoHeight = 40,
    this.illustration,
    this.illustrationHeight,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    this.showButtonArrow = false,
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            top: FinSizes.sm,
            left: FinSizes.defaultSpace,
            right: FinSizes.defaultSpace,
            bottom: FinSizes.defaultSpace,
          ),
          child: Column(
            children: [
              // Logo at top
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    FinImages.tealStripWhite,
                    height: logoHeight,
                    fit: BoxFit.contain,
                  ),
                ],
              ),

              const SizedBox(height: FinSizes.spaceBtwItems),

              // Content section
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Illustration (if provided)
                    if (illustration != null) ...[
                      SvgPicture.asset(
                        illustration!,
                        height: illustrationHeight ??
                            FinHelperFunctions.screenHeight() * 0.35,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: FinSizes.spaceBtwSections),
                    ],

                    // Title
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        title,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontSize: FinSizes.fontSizeXXLg,
                          fontWeight: FontWeight.w600,
                          height: 1.33,
                          letterSpacing: -0.48,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: FinSizes.spaceBtwItems),

                    // Subtitle
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        subtitle,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          color: Color(0xFFDFDFE0),
                          fontSize: FinSizes.fontSizeLg,
                          fontWeight: FontWeight.w400,
                          height: 1.50,
                          letterSpacing: -0.32,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: FinSizes.spaceBtwItems),

              // Button
              Column(
                children: [
                  SignupContinueButton(
                    showArrow: showButtonArrow,
                    customText: buttonText,
                    customOnTap: onButtonPressed,
                  ),
                  const SizedBox(height: FinSizes.spaceBtwSections),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}