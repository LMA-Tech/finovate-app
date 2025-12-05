import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/widgets/primary_button.dart';
import '../../../services/session_manager.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../feedback_controller.dart';
import 'feedback_progress_indicator.dart';

/// Step 1: Star rating screen
/// "Olá, [Name]! Gostaríamos de saber sua opinião sobre o Finovate"
class RatingStep extends StatelessWidget {
  final FeedbackController controller;

  const RatingStep({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    final sessionManager = Get.find<SessionManager>();
    final userName = sessionManager.userFirstName ?? 'Usuário';

    return Padding(
      padding: const EdgeInsets.all(FinSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress indicator
          const FeedbackProgressIndicator(currentStep: 0),
          const SizedBox(height: 32),

          // Greeting text - centered
          Center(
            child: Text(
              'Olá, $userName! Gostaríamos de saber sua\nopinião sobre o nosso aplicativo.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: FinColors.textWhite,
                fontSize: FinSizes.fontSizeXLg,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: FinSizes.md),
          Center(
            child: Text(
              'Sua opinião é muito importante para tornar sua\nexperiência com o Finovate cada vez melhor.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: FinColors.textWhite.withValues(alpha: 0.6),
                fontSize: FinSizes.fontSizeMd,
                height: 1.4,
              ),
            ),
          ),

          // Star rating - 48px below text
          const SizedBox(height: 48),

          // Star rating
          Obx(() => _buildStarRating()),

          // Rating labels
          const SizedBox(height: FinSizes.sm),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: FinSizes.md),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ruim',
                  style: TextStyle(
                    color: FinColors.textWhite.withValues(alpha: 0.5),
                    fontSize: FinSizes.fontSizeSm,
                  ),
                ),
                Text(
                  'Ótimo',
                  style: TextStyle(
                    color: FinColors.textWhite.withValues(alpha: 0.5),
                    fontSize: FinSizes.fontSizeSm,
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          // Continue button
          Obx(() => PrimaryButton(
                text: 'Próxima pergunta',
                icon: const Icon(Icons.arrow_forward, size: 18, color: Colors.white),
                onPressed: controller.canProceed ? controller.nextStep : null,
              )),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildStarRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final starIndex = index + 1;
        final isSelected = starIndex <= controller.rating.value;

        return GestureDetector(
          onTap: () => controller.setRating(starIndex),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: FinSizes.xs),
            child: Icon(
              isSelected ? Icons.star_rounded : Icons.star_outline_rounded,
              color: isSelected
                  ? FinColors.starGold
                  : FinColors.textWhite.withValues(alpha: 0.3),
              size: 40,
            ),
          ),
        );
      }),
    );
  }
}
