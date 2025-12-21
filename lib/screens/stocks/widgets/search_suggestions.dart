import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../../models/stock.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';

/// Dropdown list showing search autocomplete suggestions
class SearchSuggestions extends StatelessWidget {
  final List<StockSearchSuggestion> suggestions;
  final bool isLoading;
  final ValueChanged<StockSearchSuggestion> onSuggestionTap;

  const SearchSuggestions({
    required this.suggestions,
    required this.isLoading,
    required this.onSuggestionTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (suggestions.isEmpty && !isLoading) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: FinSizes.md),
      decoration: BoxDecoration(
        color: FinColors.cardBackground,
        borderRadius: BorderRadius.circular(FinSizes.borderRadiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: FinSizes.sm,
            offset: const Offset(0, FinSizes.xs),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(FinSizes.borderRadiusLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isLoading)
              const Padding(
                padding: EdgeInsets.all(FinSizes.md),
                child: SizedBox(
                  height: FinSizes.iconLg,
                  width: FinSizes.iconLg,
                  child: LoadingIndicator(
                    indicatorType: Indicator.ballSpinFadeLoader,
                    colors: [FinColors.primary],
                    strokeWidth: 2,
                  ),
                ),
              )
            else
              ...suggestions.map((suggestion) => _SuggestionItem(
                    suggestion: suggestion,
                    onTap: () => onSuggestionTap(suggestion),
                  )),
          ],
        ),
      ),
    );
  }
}

class _SuggestionItem extends StatelessWidget {
  final StockSearchSuggestion suggestion;
  final VoidCallback onTap;

  const _SuggestionItem({
    required this.suggestion,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: FinSizes.md,
          vertical: FinSizes.sm + FinSizes.xs,
        ),
        child: Row(
          children: [
            // Ticker
            Text(
              suggestion.ticker,
              style: const TextStyle(
                fontSize: FinSizes.fontSizeMd,
                fontWeight: FontWeight.w600,
                color: FinColors.textWhite,
              ),
            ),
            const SizedBox(width: FinSizes.sm),
            // Company name
            Expanded(
              child: Text(
                suggestion.name,
                style: const TextStyle(
                  fontSize: FinSizes.fontSizeS,
                  fontWeight: FontWeight.w400,
                  color: FinColors.textGray200,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // Search icon
            const Icon(
              Icons.north_west,
              size: FinSizes.iconSm,
              color: FinColors.textGray300,
            ),
          ],
        ),
      ),
    );
  }
}
