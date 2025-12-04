import 'package:flutter/material.dart';
import '../../../common/widgets/section_header.dart';
import '../../../common/widgets/segmented_tabs.dart';
import '../../../common/widgets/charts/time_period_selector.dart';
import '../../../utils/constants/sizes.dart';

/// Portfolio Section Component
/// Contains tab navigation and time period filters for portfolio analysis
/// Using new common components (SegmentedTabs, TimePeriodSelector)
class PortfolioSection extends StatelessWidget {
  const PortfolioSection({
    super.key,
    this.selectedTab = 0,
    this.selectedPeriod = 0,
    this.onTabChanged,
    this.onPeriodChanged,
    this.onSeeMorePressed,
  });

  final int selectedTab;
  final int selectedPeriod;
  final Function(int)? onTabChanged;
  final Function(int)? onPeriodChanged;
  final VoidCallback? onSeeMorePressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: FinSizes.defaultSpace),
      child: Column(
        children: [
          // Header with title and "Ver mais" button
          SectionHeader(
            title: 'Minha carteira',
            actionText: 'Ver mais',
            onActionTap: onSeeMorePressed,
          ),

          const SizedBox(height: 16),

          // Tab navigation using SegmentedTabs
          SegmentedTabs(
            tabs: const ['Rentabilidade', 'Risco', 'Composição'],
            selectedIndex: selectedTab,
            onTabChanged: (index) => onTabChanged?.call(index),
          ),

          const SizedBox(height: 24),

          // Period filter buttons using TimePeriodSelector
          // Using non-scrollable layout to match Figma (justify-between)
          TimePeriodSelector(
            periods: const [
              TimePeriod(label: 'Semana', value: '1w'),
              TimePeriod(label: 'No mês', value: 'mtd'),
              TimePeriod(label: '1 mês', value: '1m'),
              TimePeriod(label: '12 meses', value: '12m'),
            ],
            selectedIndex: selectedPeriod,
            onPeriodChanged: (index) => onPeriodChanged?.call(index),
            scrollable: false,
          ),
        ],
      ),
    );
  }
}
