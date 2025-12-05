import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/widgets/primary_button.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../feedback_controller.dart';
import 'feedback_progress_indicator.dart';

// Note: SecondaryButton removed - using back arrow in app bar instead

/// Step 3: Additional comments text input
/// "Há algo mais que deseja falar? Nos conte!"
class CommentsStep extends StatelessWidget {
  final FeedbackController controller;

  const CommentsStep({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(FinSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress indicator
          const FeedbackProgressIndicator(currentStep: 2),
          const SizedBox(height: 32),

          // Title - centered
          const Center(
            child: Text(
              'Há algo mais que deseja falar?\nNos conte!',
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

          // Text input - fixed initial height, grows if needed
          Container(
            constraints: const BoxConstraints(
              minHeight: 56,
              maxHeight: 200,
            ),
            decoration: BoxDecoration(
              color: FinColors.cardBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: FinColors.borderBlue,
                width: 2,
              ),
            ),
            child: TextField(
              controller: controller.commentsController,
              maxLines: null,
              minLines: 1,
              textAlignVertical: TextAlignVertical.top,
              style: const TextStyle(
                color: FinColors.textWhite,
                fontSize: FinSizes.fontSizeMd,
              ),
              decoration: InputDecoration(
                hintText: 'Digite aqui seus comentários (opcional)...',
                hintStyle: TextStyle(
                  color: FinColors.textWhite.withValues(alpha: 0.4),
                  fontSize: FinSizes.fontSizeMd,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(FinSizes.md),
              ),
            ),
          ),

          const Spacer(),

          // Single submit button (no Voltar - back arrow is in app bar)
          Obx(() => PrimaryButton(
                text: 'Finalizar feedback',
                isLoading: controller.isSubmitting.value,
                onPressed: controller.submitFeedback,
              )),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
