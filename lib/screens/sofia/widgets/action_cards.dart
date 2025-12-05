// lib/common/widgets/action_card.dart

import 'package:flutter/material.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';

/// Reusable Action Card Component for SofIA suggestions
///
/// This widget creates a styled card with an icon and text that users can tap
/// to send predefined messages to the AI assistant. Used in the SofIA welcome screen.
class ActionCard extends StatelessWidget {
  /// The icon to display on the left side of the card
  final IconData icon;

  /// The text content to display next to the icon
  final String text;

  /// Callback function when the card is tapped
  final VoidCallback onTap;

  /// Optional icon color (defaults to primary color)
  final Color? iconColor;

  /// Optional background color (defaults to dark container color)
  final Color? backgroundColor;

  const ActionCard({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
    this.iconColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(FinSizes.borderRadiusLg),
        child: Container(
          padding: const EdgeInsets.all(FinSizes.md),
          decoration: BoxDecoration(
            // Dark background similar to the design
            color: backgroundColor ?? FinColors.cardBackground,
            borderRadius: BorderRadius.circular(FinSizes.borderRadiusLg),
            border: Border.all(
              color: FinColors.textWhite.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Icon container
              Container(
                padding: const EdgeInsets.all(FinSizes.sm),
                decoration: BoxDecoration(
                  color: (iconColor ?? FinColors.primary).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(FinSizes.borderRadiusMd),
                ),
                child: Icon(
                  icon,
                  size: FinSizes.iconMd,
                  color: iconColor ?? FinColors.primary,
                ),
              ),

              const SizedBox(width: FinSizes.md),

              // Text content
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: FinSizes.fontSizeMd,
                    fontWeight: FontWeight.w500,
                    color: FinColors.textWhite,
                    height: 1.4, // Increased line height for better readability
                  ),
                  maxLines: 3, // Allow up to 3 lines instead of 2
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}