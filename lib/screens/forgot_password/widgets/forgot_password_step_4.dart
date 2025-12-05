import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../forgot_password_controller.dart';

class ForgotPasswordStep4 extends StatelessWidget {
  const ForgotPasswordStep4({super.key});

  @override
  Widget build(BuildContext context) {
    // Controller available if needed for future logic
    // ignore: unused_local_variable
    final _ = Get.find<ForgotPasswordController>();

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
              // Small logo at the top
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    FinImages.tealStripWhite,
                    width: 40, // Small logo size
                    height: 40,
                    fit: BoxFit.contain,
                  ),
                ],
              ),

              const SizedBox(height: FinSizes.spaceBtwItems),

              // Flexible content section
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Success image
                    SvgPicture.asset(
                      FinImages.trophySuccess,
                      height: FinHelperFunctions.screenHeight() * 0.35,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: FinSizes.spaceBtwSections),

                    // Success message
                    const SizedBox(
                      width: double.infinity, // Force full width
                      child: Text(
                        'Senha alterada com sucesso!',
                        style: TextStyle(
                          fontSize: FinSizes.fontSizeXLg,
                          fontWeight: FontWeight.w600,
                          height: 1.33,
                          letterSpacing: -0.48,
                          color: FinColors.textWhite,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    const SizedBox(height: FinSizes.spaceBtwItems),

                    // Subtitle message
                    const Text(
                      'Sua senha foi redefinida com sucesso. Use sua nova senha para fazer login.',
                      style: TextStyle(
                        color: FinColors.textGray200,
                        fontSize: FinSizes.fontSizeLg,
                        fontWeight: FontWeight.w400,
                        height: 1.50,
                        letterSpacing: -0.32,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: FinSizes.spaceBtwItems),

              // Fixed bottom section with button
              Column(
                children: [
                  // Continue button
                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: ShapeDecoration(
                      color: FinColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          // Navigate back to login screen
                          Get.offAllNamed('/login');
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 56, vertical: 12),
                          child: Center(
                            child: Text(
                              'Voltar para login',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                height: 1.50,
                                letterSpacing: -0.32,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Bottom padding for safe area
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