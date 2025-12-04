import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:finovate_app/utils/constants/chart_colors.dart';

/// A reusable bar chart component with Finovate styling.
///
/// Supports single bars, grouped bars, and stacked bars.
/// Based on Figma design specs from docs/figma-chart-requirements.md
class CustomBarChart extends StatefulWidget {
  final List<BarChartGroup> groups;
  final double height;
  final bool showGrid;
  final bool showTooltip;
  final bool showLeftLabels;
  final bool showBottomLabels;
  final String Function(double value)? leftLabelFormatter;
  final List<String>? bottomLabels;
  final double? maxY;
  final BarChartType type;

  const CustomBarChart({
    required this.groups,
    this.height = 200,
    this.showGrid = true,
    this.showTooltip = true,
    this.showLeftLabels = false,
    this.showBottomLabels = true,
    this.leftLabelFormatter,
    this.bottomLabels,
    this.maxY,
    this.type = BarChartType.single,
    super.key,
  });

  @override
  State<CustomBarChart> createState() => _CustomBarChartState();
}

class _CustomBarChartState extends State<CustomBarChart> {
  int? _touchedIndex;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          barGroups: _buildBarGroups(),
          gridData: _buildGridData(),
          titlesData: _buildTitlesData(),
          borderData: FlBorderData(show: false),
          barTouchData: _buildBarTouchData(),
          maxY: widget.maxY ?? _calculateMaxY(),
        ),
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    return widget.groups.asMap().entries.map((entry) {
      final index = entry.key;
      final group = entry.value;
      final isTouched = index == _touchedIndex;

      switch (widget.type) {
        case BarChartType.single:
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: group.values.first,
                color: isTouched
                    ? group.colors.first.withValues(alpha: 0.8)
                    : group.colors.first,
                width: 24,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(4),
                ),
              ),
            ],
          );
        case BarChartType.grouped:
          return BarChartGroupData(
            x: index,
            barRods: group.values.asMap().entries.map((valueEntry) {
              final valueIndex = valueEntry.key;
              final value = valueEntry.value;
              final color = valueIndex < group.colors.length
                  ? group.colors[valueIndex]
                  : ChartColors.barPrimary;
              return BarChartRodData(
                toY: value,
                color:
                    isTouched ? color.withValues(alpha: 0.8) : color,
                width: 12,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(4),
                ),
              );
            }).toList(),
          );
        case BarChartType.stacked:
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: group.values.reduce((a, b) => a + b),
                color: Colors.transparent,
                width: 24,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(4),
                ),
                rodStackItems: _buildStackItems(group),
              ),
            ],
          );
      }
    }).toList();
  }

  List<BarChartRodStackItem> _buildStackItems(BarChartGroup group) {
    final items = <BarChartRodStackItem>[];
    double fromY = 0;

    for (int i = 0; i < group.values.length; i++) {
      final value = group.values[i];
      final color =
          i < group.colors.length ? group.colors[i] : ChartColors.barPrimary;
      items.add(BarChartRodStackItem(fromY, fromY + value, color));
      fromY += value;
    }

    return items;
  }

  FlGridData _buildGridData() {
    if (!widget.showGrid) {
      return const FlGridData(show: false);
    }

    return FlGridData(
      show: true,
      drawVerticalLine: false,
      drawHorizontalLine: true,
      horizontalInterval: _calculateMaxY() / 4,
      getDrawingHorizontalLine: (value) {
        return FlLine(
          color: ChartColors.gridLines,
          strokeWidth: 1,
        );
      },
    );
  }

  FlTitlesData _buildTitlesData() {
    return FlTitlesData(
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: widget.showLeftLabels,
          reservedSize: 45,
          interval: _calculateMaxY() / 4,
          getTitlesWidget: (value, meta) {
            final label =
                widget.leftLabelFormatter?.call(value) ?? value.toStringAsFixed(0);
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(
                label,
                style: const TextStyle(
                  color: ChartColors.labelColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            );
          },
        ),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: widget.showBottomLabels,
          reservedSize: 30,
          getTitlesWidget: (value, meta) {
            final index = value.toInt();
            final label = widget.bottomLabels != null &&
                    index < widget.bottomLabels!.length
                ? widget.bottomLabels![index]
                : index < widget.groups.length
                    ? widget.groups[index].label ?? ''
                    : '';
            return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                label,
                style: const TextStyle(
                  color: ChartColors.labelColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            );
          },
        ),
      ),
      rightTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      topTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
    );
  }

  BarTouchData _buildBarTouchData() {
    if (!widget.showTooltip) {
      return BarTouchData(enabled: false);
    }

    return BarTouchData(
      enabled: true,
      touchCallback: (event, response) {
        setState(() {
          if (!event.isInterestedForInteractions ||
              response == null ||
              response.spot == null) {
            _touchedIndex = null;
            return;
          }
          _touchedIndex = response.spot!.touchedBarGroupIndex;
        });
      },
      touchTooltipData: BarTouchTooltipData(
        getTooltipColor: (_) => ChartColors.tooltipBackground,
        tooltipRoundedRadius: 8,
        tooltipPadding: const EdgeInsets.all(12),
        getTooltipItem: (group, groupIndex, rod, rodIndex) {
          final barGroup = widget.groups[groupIndex];
          return BarTooltipItem(
            '${barGroup.label ?? ''}\n',
            const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
            children: [
              TextSpan(
                text: widget.leftLabelFormatter?.call(rod.toY) ??
                    rod.toY.toStringAsFixed(2),
                style: const TextStyle(
                  color: Color(0xFFBADBC1),
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  double _calculateMaxY() {
    double max = 0;
    for (final group in widget.groups) {
      if (widget.type == BarChartType.stacked) {
        final sum = group.values.reduce((a, b) => a + b);
        if (sum > max) max = sum;
      } else {
        for (final value in group.values) {
          if (value > max) max = value;
        }
      }
    }
    return max * 1.2; // Add 20% padding
  }
}

/// Represents a group of bars in the chart.
class BarChartGroup {
  final String? label;
  final List<double> values;
  final List<Color> colors;

  const BarChartGroup({
    this.label,
    required this.values,
    required this.colors,
  });

  /// Factory for a single bar
  factory BarChartGroup.single({
    String? label,
    required double value,
    Color color = ChartColors.barPrimary,
  }) {
    return BarChartGroup(
      label: label,
      values: [value],
      colors: [color],
    );
  }
}

/// The type of bar chart to display.
enum BarChartType {
  single,
  grouped,
  stacked,
}
