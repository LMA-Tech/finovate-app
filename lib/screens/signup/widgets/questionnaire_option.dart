import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';

/// Radio-button style option for questionnaire questions
///
/// Displays text with a selection indicator (circle) on the right
/// Changes appearance when selected
class QuestionnaireOption extends StatelessWidget {
  /// The option text to display
  final String text;

  /// Whether this option is currently selected
  final bool isSelected;

  /// Callback when option is tapped
  final VoidCallback onTap;

  const QuestionnaireOption({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        decoration: BoxDecoration(
          color: FinColors.cardBackground, // Background color from Figma
          border: Border.all(
            color: isSelected
                ? FinColors.borderBlue // Selected: Blue border
                : FinColors.borderMint, // Unselected: Light mint/teal border from Figma
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Option Text
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: isSelected
                      ? FinColors.textWhite // Selected: White text
                      : FinColors.textGray200, // Unselected: Light gray
                  fontSize: FinSizes.fontSizeMd,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w600,
                  height: 1.50,
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Selection Indicator (Radio Button)
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? FinColors.borderBlue // Selected: Blue
                      : FinColors.radioUnselected, // Unselected: Gray
                  width: 2,
                ),
                color: Colors.transparent,
              ),
              child: isSelected
                  ? Center(
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: FinColors.borderBlue, // Blue dot
                  ),
                ),
              )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}