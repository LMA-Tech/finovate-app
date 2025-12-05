import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/widgets/primary_button.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../feedback_controller.dart';
import 'feedback_progress_indicator.dart';

/// Step 2: Focus areas selection (multi-select checkboxes)
/// "Em quais aspectos você acha que devemos focar?"
class FocusAreasStep extends StatelessWidget {
  final FeedbackController controller;

  const FocusAreasStep({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(FinSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress indicator
          const FeedbackProgressIndicator(currentStep: 1),
          const SizedBox(height: 32),

          // Title - centered
          const Center(
            child: Text(
              'Em quais aspectos você acha que\ndevemos focar?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: FinColors.textWhite,
                fontSize: FinSizes.fontSizeXLg,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Focus area options
          Expanded(
            child: ListView.separated(
              itemCount: controller.focusAreas.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final area = controller.focusAreas[index];
                return Obx(() => _FocusAreaCard(
                      area: area,
                      isSelected: controller.isFocusAreaSelected(area.id),
                      onTap: () => controller.toggleFocusArea(area.id),
                    ));
              },
            ),
          ),

          const SizedBox(height: 16),

          // Single continue button (no Voltar - back arrow is in app bar)
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
}

class _FocusAreaCard extends StatelessWidget {
  final FocusArea area;
  final bool isSelected;
  final VoidCallback onTap;

  const _FocusAreaCard({
    required this.area,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: FinColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? FinColors.borderBlue // Selected: Blue border
                : FinColors.borderMint, // Unselected: Light mint/teal border (same as signup)
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Title
            Expanded(
              child: Text(
                area.title,
                style: TextStyle(
                  color: isSelected
                      ? FinColors.textWhite
                      : FinColors.textGray200, // Match signup questionnaire
                  fontSize: FinSizes.fontSizeMd,
                  fontWeight: FontWeight.w600,
                  height: 1.50,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Checkbox indicator
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                border: Border.all(
                  color: isSelected
                      ? FinColors.borderBlue
                      : FinColors.textWhite.withValues(alpha: 0.1),
                  width: 1,
                ),
                color: isSelected ? FinColors.borderBlue : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      color: FinColors.textWhite,
                      size: 14,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
