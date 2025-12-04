import 'package:flutter/material.dart';

/// A reusable chart legend component with Finovate styling.
///
/// Matches Figma pill style legend design.
/// Based on docs/figma-chart-requirements.md specification.
class ChartLegend extends StatelessWidget {
  final List<LegendItem> items;
  final Axis direction;
  final bool usePillStyle;
  final MainAxisAlignment mainAxisAlignment;
  final Function(int index)? onItemTap;

  const ChartLegend({
    required this.items,
    this.direction = Axis.horizontal,
    this.usePillStyle = true,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.onItemTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final legendItems = items.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      return _buildItem(item, index);
    }).toList();

    if (direction == Axis.horizontal) {
      return Row(
        mainAxisAlignment: mainAxisAlignment,
        mainAxisSize: MainAxisSize.min,
        children: legendItems
            .expand((item) => [item, const SizedBox(width: 8)]) // 8px gap per Figma
            .toList()
          ..removeLast(),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: legendItems
          .expand((item) => [item, const SizedBox(height: 8)])
          .toList()
        ..removeLast(),
    );
  }

  Widget _buildItem(LegendItem item, int index) {
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Dot with optional stroke
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: item.color,
            shape: BoxShape.circle,
            border: item.strokeColor != null
                ? Border.all(color: item.strokeColor!, width: 1)
                : null,
          ),
        ),
        const SizedBox(width: 4), // 4px gap per Figma
        Text(
          item.label,
          style: const TextStyle(
            color: Color(0xFFDFDFE0),
            fontSize: 13,
            fontWeight: FontWeight.w500,
            height: 1.85, // 24px line height / 13px font size
            letterSpacing: 0.1,
          ),
        ),
        if (item.value != null) ...[
          const SizedBox(width: 8),
          Text(
            item.value!,
            style: TextStyle(
              color: item.color,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );

    Widget legendItem;

    if (usePillStyle) {
      legendItem = Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4), // 6px horizontal per Figma
        decoration: BoxDecoration(
          color: const Color(0xFF15254E),
          borderRadius: BorderRadius.circular(6),
        ),
        child: content,
      );
    } else {
      legendItem = content;
    }

    if (onItemTap != null) {
      return GestureDetector(
        onTap: () => onItemTap!(index),
        child: legendItem,
      );
    }

    return legendItem;
  }
}

/// Represents a single legend item.
class LegendItem {
  final String label;
  final Color color;
  final Color? strokeColor; // Optional stroke/border color for the dot
  final String? value;

  const LegendItem({
    required this.label,
    required this.color,
    this.strokeColor,
    this.value,
  });
}

/// A performance indicator widget showing percentage values above the chart.
///
/// Used to display portfolio return vs benchmark comparison.
class PerformanceIndicators extends StatelessWidget {
  final List<PerformanceIndicator> indicators;
  final MainAxisAlignment mainAxisAlignment;

  const PerformanceIndicators({
    required this.indicators,
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      children: indicators.map((indicator) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              indicator.formattedValue,
              style: TextStyle(
                color: indicator.color,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                height: 1.33,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              indicator.label,
              style: const TextStyle(
                color: Color(0xFFDFDFE0),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}

/// Represents a performance indicator.
class PerformanceIndicator {
  final String label;
  final double value;
  final Color color;
  final String? customFormat;

  const PerformanceIndicator({
    required this.label,
    required this.value,
    required this.color,
    this.customFormat,
  });

  String get formattedValue {
    if (customFormat != null) return customFormat!;
    final prefix = value >= 0 ? '+' : '';
    return '$prefix${value.toStringAsFixed(2)}%';
  }
}

/// A combined widget showing chart with legend and performance indicators.
class ChartWithHeader extends StatelessWidget {
  final Widget chart;
  final List<PerformanceIndicator>? indicators;
  final List<LegendItem>? legendItems;
  final String? title;
  final Widget? titleAction;
  final bool showLegend;
  final double spacing;

  const ChartWithHeader({
    required this.chart,
    this.indicators,
    this.legendItems,
    this.title,
    this.titleAction,
    this.showLegend = true,
    this.spacing = 16,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              if (titleAction != null) titleAction!,
            ],
          ),
          SizedBox(height: spacing),
        ],
        if (indicators != null && indicators!.isNotEmpty) ...[
          PerformanceIndicators(indicators: indicators!),
          SizedBox(height: spacing),
        ],
        chart,
        if (showLegend && legendItems != null && legendItems!.isNotEmpty) ...[
          SizedBox(height: spacing),
          Center(child: ChartLegend(items: legendItems!)),
        ],
      ],
    );
  }
}
