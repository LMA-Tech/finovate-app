import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/session_manager.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';

class SignupStep6 extends StatelessWidget {
  const SignupStep6({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(FinSizes.defaultSpace),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Success illustration placeholder
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: FinColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(100),
            ),
            child: const Icon(
              Icons.celebration,
              size: 100,
              color: FinColors.primary,
            ),
          ),

          const SizedBox(height: FinSizes.spaceBtwSections),

          // Success message
          const Text(
            'Conta criada com sucesso, Bernardo!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              height: 1.33,
              letterSpacing: -0.48,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
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
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: FinSizes.largeSpaceBtwSections),

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
                  // Clear signup flag and navigate to home
                  Get.find<SessionManager>().isInSignupFlow.value = false;
                  Get.offAllNamed('/home');
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
        ],
      ),
    );
  }
}