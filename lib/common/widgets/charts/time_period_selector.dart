import 'package:flutter/material.dart';

/// A reusable time period selector (pill buttons) for charts.
///
/// Matches Figma design: Semana, No mês, 1 mês, 12 meses, etc.
/// Based on docs/global-components.md Period Filter Pills specification.
class TimePeriodSelector extends StatelessWidget {
  final List<TimePeriod> periods;
  final int selectedIndex;
  final ValueChanged<int> onPeriodChanged;
  final bool scrollable;

  const TimePeriodSelector({
    required this.periods,
    required this.selectedIndex,
    required this.onPeriodChanged,
    this.scrollable = true,
    super.key,
  });

  /// Factory with common portfolio time periods
  factory TimePeriodSelector.portfolio({
    required int selectedIndex,
    required ValueChanged<int> onPeriodChanged,
  }) {
    return TimePeriodSelector(
      periods: const [
        TimePeriod(label: 'Semana', value: '1w'),
        TimePeriod(label: 'No mês', value: 'mtd'),
        TimePeriod(label: '1 mês', value: '1m'),
        TimePeriod(label: '12 meses', value: '12m'),
      ],
      selectedIndex: selectedIndex,
      onPeriodChanged: onPeriodChanged,
    );
  }

  /// Factory with variation periods (YTD, YoY, MoM)
  factory TimePeriodSelector.variations({
    required int selectedIndex,
    required ValueChanged<int> onPeriodChanged,
  }) {
    return TimePeriodSelector(
      periods: const [
        TimePeriod(label: 'YTD', value: 'ytd'),
        TimePeriod(label: 'YoY', value: 'yoy'),
        TimePeriod(label: 'MoM', value: 'mom'),
      ],
      selectedIndex: selectedIndex,
      onPeriodChanged: onPeriodChanged,
    );
  }

  /// Factory with year-based periods
  factory TimePeriodSelector.yearly({
    required int selectedIndex,
    required ValueChanged<int> onPeriodChanged,
    int startYear = 2020,
    int? endYear,
  }) {
    final end = endYear ?? DateTime.now().year;
    final periods = <TimePeriod>[];
    for (int year = end; year >= startYear; year--) {
      periods.add(TimePeriod(label: year.toString(), value: year.toString()));
    }
    return TimePeriodSelector(
      periods: periods,
      selectedIndex: selectedIndex,
      onPeriodChanged: onPeriodChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = periods.asMap().entries.map((entry) {
      final index = entry.key;
      final period = entry.value;
      final isSelected = index == selectedIndex;

      return GestureDetector(
        onTap: () => onPeriodChanged(index),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
              color: isSelected
                  ? const Color(0xFFBADBC1) // Selected: green border
                  : const Color(0xFF7C7C83), // Unselected: gray border
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            period.label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              height: 1.5,
              color: const Color(0xFFF0F5EF), // Figma: --brand/secondary-lighter
            ),
          ),
        ),
      );
    }).toList();

    if (scrollable) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: items.asMap().entries.map((entry) {
            return Padding(
              padding: EdgeInsets.only(right: entry.key < items.length - 1 ? 8 : 0),
              child: entry.value,
            );
          }).toList(),
        ),
      );
    }

    // Non-scrollable: spread across full width with justify-between
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: items,
    );
  }
}

/// Represents a time period option.
class TimePeriod {
  final String label;
  final String value;

  const TimePeriod({
    required this.label,
    required this.value,
  });
}

/// A toggle selector for switching between views (e.g., Por ano / Por mês).
class ViewToggleSelector extends StatelessWidget {
  final List<String> options;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const ViewToggleSelector({
    required this.options,
    required this.selectedIndex,
    required this.onChanged,
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
        children: options.asMap().entries.map((entry) {
          final index = entry.key;
          final option = entry.value;
          final isSelected = index == selectedIndex;

          return GestureDetector(
            onTap: () => onChanged(index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF1B6FFF)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
              ),
              alignment: Alignment.center,
              child: Text(
                option,
                style: TextStyle(
                  fontSize: 13,
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
