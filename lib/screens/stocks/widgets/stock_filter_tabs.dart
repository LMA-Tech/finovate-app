import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';

/// Filter tabs (segmented pills) for stocks screen
class StockFilterTabs extends StatelessWidget {
  final List<String> options;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const StockFilterTabs({
    required this.options,
    required this.selectedIndex,
    required this.onSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: FinSizes.listItemSm,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: options.length,
        separatorBuilder: (_, __) => const SizedBox(width: FinSizes.sm),
        itemBuilder: (context, index) {
          final isSelected = index == selectedIndex;
          return _FilterTab(
            label: options[index],
            isSelected: isSelected,
            onTap: () => onSelected(index),
          );
        },
      ),
    );
  }
}

class _FilterTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: FinSizes.md,
          vertical: FinSizes.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? FinColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(FinSizes.lg + FinSizes.xs), // 20px
          border: isSelected
              ? null
              : Border.all(
                  color: FinColors.textGray300,
                  width: 1,
                ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: FinSizes.fontSizeMd,
              fontWeight: FontWeight.w500,
              color: isSelected ? FinColors.textWhite : FinColors.textGray200,
            ),
          ),
        ),
      ),
    );
  }
}
