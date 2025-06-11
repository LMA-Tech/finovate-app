import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../services/session_manager.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../signup_controller.dart';

class SignupStep6 extends StatelessWidget {
  const SignupStep6({super.key});

  @override
  Widget build(BuildContext context) {
    final signupController = Get.find<SignupController>();
    final sessionManager = Get.find<SessionManager>();
    final dark = FinHelperFunctions.isDarkMode(context);

    // Get the user's first name once at build time (no need for Obx)
    final firstName = signupController.step2Form.control('firstName').value ?? 'Usuário';

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(FinSizes.defaultSpace),
          child: Column(
            children: [
              // Small logo at the top
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    dark ? FinImages.lightAppLogo : FinImages.lightAppLogo,
                    width: 40, // Small logo size
                    height: 40,
                    fit: BoxFit.contain,
                    colorFilter: const ColorFilter.mode(
                      FinColors.cyan, // Use your brand color
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: FinSizes.spaceBtwSections),

              // Flexible content section
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Success illustration placeholder
                    Container(
                      width: 150, // Reduced size to fit better
                      height: 150,
                      decoration: BoxDecoration(
                        color: FinColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(75),
                      ),
                      child: const Icon(
                        Icons.celebration,
                        size: 75, // Reduced icon size
                        color: FinColors.primary,
                      ),
                    ),

                    const SizedBox(height: FinSizes.spaceBtwSections),

                    // Success message - using the firstName directly (no Obx needed)
                    Text(
                      'Conta criada com sucesso, $firstName!',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        height: 1.33,
                        letterSpacing: -0.48,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.left,
                    ),

                    const SizedBox(height: FinSizes.spaceBtwItems),

                    // Subtitle message
                    const Text(
                      'Se você trocar seu número no futuro, ajudaremos você a verificar sua conta novamente.',
                      style: TextStyle(
                        color: Color(0xFFDFDFE0), // Neutral-gray-200
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        height: 1.50,
                        letterSpacing: -0.32,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),

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
                          print('=== STEP 6: User clicked "Tudo certo!" ===');
                          print('Current user: ${sessionManager.currentUser.value?.email}');
                          print('Is authenticated: ${sessionManager.isAuthenticated.value}');

                          // NOW clear the signup flow flag - this allows normal navigation
                          sessionManager.isInSignupFlow.value = false;
                          print('Cleared signup flow flag');

                          // Navigate to home - SessionManager should handle this automatically
                          // but we'll be explicit to ensure it works
                          Get.offAllNamed('/home');
                          print('Navigated to home');
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 56, vertical: 12),
                          child: Center(
                            child: Text(
                              'Tudo certo!',
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