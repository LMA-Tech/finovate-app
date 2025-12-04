import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:finovate_app/utils/constants/chart_colors.dart';

/// A reusable donut/pie chart component with Finovate styling.
///
/// Used for portfolio composition, asset allocation, and similar visualizations.
/// Based on Figma design specs from docs/figma-chart-requirements.md
class CustomPieChart extends StatefulWidget {
  final List<PieChartSegment> segments;
  final double size;
  final double strokeWidth;
  final bool showLabels;
  final bool showCenterContent;
  final Widget? centerWidget;
  final Function(int index)? onSegmentTap;

  const CustomPieChart({
    required this.segments,
    this.size = 200,
    this.strokeWidth = 30,
    this.showLabels = true,
    this.showCenterContent = true,
    this.centerWidget,
    this.onSegmentTap,
    super.key,
  });

  @override
  State<CustomPieChart> createState() => _CustomPieChartState();
}

class _CustomPieChartState extends State<CustomPieChart> {
  int? _touchedIndex;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: widget.showCenterContent
                  ? (widget.size / 2) - widget.strokeWidth - 10
                  : 0,
              sections: _buildSections(),
              pieTouchData: PieTouchData(
                touchCallback: (event, response) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        response == null ||
                        response.touchedSection == null) {
                      _touchedIndex = null;
                      return;
                    }
                    _touchedIndex =
                        response.touchedSection!.touchedSectionIndex;
                  });
                  if (event is FlTapUpEvent && _touchedIndex != null) {
                    widget.onSegmentTap?.call(_touchedIndex!);
                  }
                },
              ),
            ),
          ),
          if (widget.showCenterContent && widget.centerWidget != null)
            widget.centerWidget!,
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildSections() {
    return widget.segments.asMap().entries.map((entry) {
      final index = entry.key;
      final segment = entry.value;
      final isTouched = index == _touchedIndex;
      final radius =
          isTouched ? widget.strokeWidth + 5 : widget.strokeWidth;

      return PieChartSectionData(
        value: segment.value,
        color: segment.color,
        radius: radius,
        title: widget.showLabels ? '${segment.percentage.toStringAsFixed(1)}%' : '',
        titleStyle: TextStyle(
          fontSize: isTouched ? 14 : 12,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        titlePositionPercentageOffset: 0.55,
        badgeWidget: isTouched && segment.label != null
            ? _buildBadge(segment)
            : null,
        badgePositionPercentageOffset: 1.2,
      );
    }).toList();
  }

  Widget _buildBadge(PieChartSegment segment) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: ChartColors.tooltipBackground,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        segment.label!,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );
  }
}

/// Represents a segment in the pie chart.
class PieChartSegment {
  final String? label;
  final double value;
  final double percentage;
  final Color color;
  final String? formattedValue;

  const PieChartSegment({
    this.label,
    required this.value,
    required this.percentage,
    required this.color,
    this.formattedValue,
  });
}

/// A center widget for the donut chart showing total value.
class PieChartCenterContent extends StatelessWidget {
  final String title;
  final String value;

  const PieChartCenterContent({
    required this.title,
    required this.value,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFFDFDFE0),
          ),
        ),
      ],
    );
  }
}

/// A legend widget for the pie chart.
class PieChartLegend extends StatelessWidget {
  final List<PieChartSegment> segments;
  final Axis direction;
  final Function(int index)? onItemTap;

  const PieChartLegend({
    required this.segments,
    this.direction = Axis.vertical,
    this.onItemTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final items = segments.asMap().entries.map((entry) {
      final index = entry.key;
      final segment = entry.value;
      return GestureDetector(
        onTap: () => onItemTap?.call(index),
        child: Padding(
          padding: direction == Axis.vertical
              ? const EdgeInsets.symmetric(vertical: 4)
              : const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: segment.color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  segment.label ?? '',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFFDFDFE0),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${segment.percentage.toStringAsFixed(1)}%',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();

    if (direction == Axis.vertical) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: items,
      );
    }

    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: items,
    );
  }
}
