import 'package:flutter/material.dart';

/// A segmented tab control with Finovate styling.
///
/// Based on Figma design specs - selected tab "pops out" with shadow
/// and is slightly taller than the container.
class SegmentedTabs extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTabChanged;
  final double height;
  final double borderRadius;

  const SegmentedTabs({
    required this.tabs,
    required this.selectedIndex,
    required this.onTabChanged,
    this.height = 48,
    this.borderRadius = 12,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final containerWidth = constraints.maxWidth;
        final tabWidth = containerWidth / tabs.length;

        return Container(
          height: height,
          decoration: BoxDecoration(
            color: const Color(0xFF2D3245),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Background tabs (unselected)
              Row(
                children: tabs.asMap().entries.map((entry) {
                  final isSelected = entry.key == selectedIndex;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => onTabChanged(entry.key),
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          entry.value,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.1,
                            color: isSelected ? Colors.transparent : const Color(0xFFFEFEFE),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              // Selected tab overlay (pops out)
              AnimatedPositioned(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                left: selectedIndex * tabWidth,
                top: -3, // Pop out above container
                width: tabWidth,
                child: Container(
                  height: 54, // Taller than container (48px)
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B6FFF),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x3D1A2F5C), // rgba(26,47,92,0.24)
                        offset: Offset(2, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    tabs[selectedIndex],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.1,
                      color: Color(0xFFFEFEFE),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// A smaller compact version of segmented tabs.
class CompactSegmentedTabs extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTabChanged;

  const CompactSegmentedTabs({
    required this.tabs,
    required this.selectedIndex,
    required this.onTabChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: const Color(0xFF2D3245),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: tabs.asMap().entries.map((entry) {
          final isSelected = entry.key == selectedIndex;
          return GestureDetector(
            onTap: () => onTabChanged(entry.key),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF1B6FFF)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                entry.value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? Colors.white : const Color(0xFFDFDFE0),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
