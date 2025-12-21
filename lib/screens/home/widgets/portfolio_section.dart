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

          // Period filter buttons - only show for Rentabilidade and Risco tabs (not Composição)
          if (selectedTab != 2) ...[
            const SizedBox(height: 24),
            TimePeriodSelector(
              periods: const [
                TimePeriod(label: 'Semana', value: 'week'),
                TimePeriod(label: '1 mês', value: 'month'),
                TimePeriod(label: '3 meses', value: 'three_months'),
                TimePeriod(label: '12 meses', value: 'twelve_months'),
              ],
              selectedIndex: selectedPeriod,
              onPeriodChanged: (index) => onPeriodChanged?.call(index),
              scrollable: false,
            ),
          ],
        ],
      ),
    );
  }
}
