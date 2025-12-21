import 'package:flutter/material.dart';

import '../../utils/constants/colors.dart';
import '../../utils/constants/sizes.dart';

/// A segmented tab control with Finovate styling.
///
/// Based on Figma design specs - selected tab "pops out" with shadow
/// and is slightly taller than the container. Each tab takes equal space.
///
/// Used for both home screen (Rentabilidade, Risco, Composição) and
/// stocks screen (Todas, Maiores altas, Maiores baixas).
class SegmentedTabs extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTabChanged;

  /// Optional gradient for a specific tab index when selected.
  /// If provided, overrides the default solid color for that tab.
  final int? gradientTabIndex;
  final Gradient? selectedGradient;

  const SegmentedTabs({
    required this.tabs,
    required this.selectedIndex,
    required this.onTabChanged,
    this.gradientTabIndex,
    this.selectedGradient,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: FinSizes.tabHeight,
      decoration: BoxDecoration(
        color: FinColors.cardBackground,
        borderRadius: BorderRadius.circular(FinSizes.borderRadiusLg),
      ),
      child: Row(
        children: tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final label = entry.value;
          final isSelected = index == selectedIndex;

          // Check if this tab should use gradient when selected
          final useGradient = isSelected &&
              gradientTabIndex == index &&
              selectedGradient != null;

          Widget tab = Container(
            height: FinSizes.tabHeightSelected,
            decoration: BoxDecoration(
              color: useGradient
                  ? null
                  : (isSelected ? FinColors.primary : Colors.transparent),
              gradient: useGradient ? selectedGradient : null,
              borderRadius: BorderRadius.circular(FinSizes.borderRadiusLg),
              boxShadow: isSelected
                  ? const [
                      BoxShadow(
                        color: FinColors.segmentShadow,
                        offset: Offset(2, 2),
                        blurRadius: 4,
                      ),
                    ]
                  : null,
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: FinSizes.fontSizeMd,
                fontWeight: FontWeight.w500,
                height: 1.50,
                letterSpacing: 0.10,
                color: FinColors.segmentUnselectedText,
              ),
            ),
          );

          // Apply pop-out effect for selected tab
          if (isSelected) {
            tab = Transform.translate(
              offset: const Offset(0, -3),
              child: tab,
            );
          }

          return Expanded(
            child: GestureDetector(
              onTap: () => onTabChanged(index),
              child: tab,
            ),
          );
        }).toList(),
      ),
    );
  }
}
