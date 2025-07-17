import 'package:flutter/material.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';

/// Portfolio Section Component
/// Contains tab navigation and time period filters for portfolio analysis
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Minha carteira',
                style: TextStyle(
                  color: Color(0xFFFEFEFE),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                  letterSpacing: 0.1,
                ),
              ),
              GestureDetector(
                onTap: onSeeMorePressed,
                child: const Text(
                  'Ver mais',
                  style: TextStyle(
                    color: Color(0xFFBADBC1),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.43,
                    letterSpacing: 0.1,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Tab navigation
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF2D3245),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                // Rentabilidade tab
                _buildTab(
                  'Rentabilidade',
                  isSelected: selectedTab == 0,
                  onTap: () => onTabChanged?.call(0),
                ),

                // Risco tab
                _buildTab(
                  'Risco',
                  isSelected: selectedTab == 1,
                  onTap: () => onTabChanged?.call(1),
                ),

                // Composição tab
                _buildTab(
                  'Composição',
                  isSelected: selectedTab == 2,
                  onTap: () => onTabChanged?.call(2),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Period filter buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPeriodFilter('Semana', 0),
              _buildPeriodFilter('No mês', 1),
              _buildPeriodFilter('1 mês', 2),
              _buildPeriodFilter('12 meses', 3),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String text, {required bool isSelected, VoidCallback? onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 54,
          decoration: BoxDecoration(
            color: isSelected ? FinColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected ? [
              BoxShadow(
                color: const Color(0xFF1A2F5C).withValues(alpha: 0.24),
                blurRadius: 4,
                offset: const Offset(2, 2),
              ),
            ] : null,
          ),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xFFFEFEFE),
                fontSize: 16,
                fontWeight: FontWeight.w500,
                height: 1.5,
                letterSpacing: 0.1,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPeriodFilter(String text, int index) {
    final isSelected = selectedPeriod == index;

    return GestureDetector(
      onTap: () => onPeriodChanged?.call(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFFBADBC1) : const Color(0xFF7C7C83),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: const Color(0xFFF0F5EF),
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}