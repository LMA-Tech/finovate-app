import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_strings.dart';

/// Pagination controls widget for navigating between pages
/// Shows two styled buttons: "Anterior" and "Próxima"
class PaginationControls extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final bool hasPrevious;
  final bool hasNext;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  const PaginationControls({
    required this.currentPage,
    required this.totalPages,
    required this.hasPrevious,
    required this.hasNext,
    this.onPrevious,
    this.onNext,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Don't show pagination if there's only one page
    if (!hasPrevious && !hasNext) {
      return const SizedBox(height: FinSizes.lg);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: FinSizes.lg,
        horizontal: FinSizes.md,
      ),
      child: Row(
        children: [
          // Previous button (only show if there's a previous page)
          if (hasPrevious)
            Expanded(
              child: _PaginationButton(
                label: FinTexts.stocksPaginationPrevious,
                enabled: true,
                onTap: onPrevious,
              ),
            ),

          if (hasPrevious && hasNext) const SizedBox(width: FinSizes.md),

          // Next button (only show if there's a next page)
          if (hasNext)
            Expanded(
              child: _PaginationButton(
                label: FinTexts.stocksPaginationNext,
                enabled: true,
                onTap: onNext,
              ),
            ),
        ],
      ),
    );
  }
}

class _PaginationButton extends StatelessWidget {
  final String label;
  final bool enabled;
  final VoidCallback? onTap;

  const _PaginationButton({
    required this.label,
    required this.enabled,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = enabled ? FinColors.textWhite : FinColors.textGray300;
    final borderColor = enabled ? FinColors.cardBackground : FinColors.cardBackground.withValues(alpha: 0.5);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: FinSizes.lg), // 24px
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: FinSizes.borderWidthSm,
              color: borderColor,
            ),
            borderRadius: BorderRadius.circular(FinSizes.borderRadiusMd),
          ),
        ),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: color,
              fontSize: FinSizes.fontSizeS, // 13px
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
