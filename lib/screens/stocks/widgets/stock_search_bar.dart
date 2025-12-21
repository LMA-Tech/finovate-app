import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_strings.dart';

/// Search bar widget for stocks screen
class StockSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onSubmitted;
  final VoidCallback? onClear;

  const StockSearchBar({
    required this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: FinSizes.searchBarHeight,
      decoration: BoxDecoration(
        color: FinColors.cardBackground,
        borderRadius: BorderRadius.circular(FinSizes.borderRadiusLg),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        onSubmitted: (_) => onSubmitted?.call(),
        style: const TextStyle(
          fontSize: FinSizes.fontSizeMd,
          fontWeight: FontWeight.w400,
          color: FinColors.textWhite,
          height: 1.50,
        ),
        decoration: InputDecoration(
          hintText: FinTexts.stocksSearchPlaceholder,
          hintStyle: const TextStyle(
            fontSize: FinSizes.fontSizeMd,
            fontWeight: FontWeight.w400,
            color: FinColors.neutralGray,
            height: 1.50,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: FinColors.neutralGray,
            size: FinSizes.iconMd,
          ),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: FinColors.textGray300,
                    size: FinSizes.iconSm,
                  ),
                  onPressed: () {
                    controller.clear();
                    onClear?.call();
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: FinSizes.md,
            vertical: FinSizes.md,
          ),
        ),
      ),
    );
  }
}
