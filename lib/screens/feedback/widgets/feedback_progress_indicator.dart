import 'package:flutter/material.dart';
import '../../../utils/constants/colors.dart';

/// Progress indicator for the 3-step feedback flow
/// Shows current step with active highlighting
class FeedbackProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const FeedbackProgressIndicator({
    required this.currentStep,
    this.totalSteps = 3,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps, (index) {
        final isActive = index <= currentStep;
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(
              right: index < totalSteps - 1 ? 8 : 0,
            ),
            height: 6,
            decoration: BoxDecoration(
              color: isActive
                  ? FinColors.primary
                  : FinColors.progressInactive,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        );
      }),
    );
  }
}
