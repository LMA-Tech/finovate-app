import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:finovate_app/utils/constants/chart_colors.dart';

/// A reusable line chart component with Finovate styling.
///
/// Supports multiple data series for comparing portfolio vs benchmarks.
/// Based on Figma design specs from docs/figma-chart-requirements.md
class CustomLineChart extends StatelessWidget {
  final List<LineChartSeries> dataSeries;
  final double height;
  final bool showGrid;
  final bool showTooltip;
  final bool showLeftLabels;
  final bool showBottomLabels;
  final String Function(double value)? leftLabelFormatter;
  final String Function(double value)? bottomLabelFormatter;
  final Function(FlTouchEvent, LineTouchResponse?)? onTooltipCallback;

  const CustomLineChart({
    required this.dataSeries,
    this.height = 200,
    this.showGrid = true,
    this.showTooltip = true,
    this.showLeftLabels = false,
    this.showBottomLabels = true,
    this.leftLabelFormatter,
    this.bottomLabelFormatter,
    this.onTooltipCallback,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: LineChart(
        LineChartData(
          gridData: _buildGridData(),
          titlesData: _buildTitlesData(),
          borderData: FlBorderData(show: false),
          lineBarsData: _buildLineBarsData(),
          lineTouchData: _buildLineTouchData(),
          minX: _getMinX(),
          maxX: _getMaxX(),
          minY: _getMinY(),
          maxY: _getMaxY(),
        ),
        duration: const Duration(milliseconds: 250),
      ),
    );
  }

  FlGridData _buildGridData() {
    if (!showGrid) {
      return const FlGridData(show: false);
    }

    return FlGridData(
      show: true,
      drawVerticalLine: true,
      drawHorizontalLine: true,
      horizontalInterval: _getYInterval(),
      verticalInterval: _getXInterval(),
      getDrawingHorizontalLine: (value) {
        return FlLine(
          color: ChartColors.gridLines,
          strokeWidth: 1,
        );
      },
      getDrawingVerticalLine: (value) {
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
          showTitles: showLeftLabels,
          reservedSize: 45,
          interval: _getYInterval(),
          getTitlesWidget: (value, meta) {
            final label = leftLabelFormatter?.call(value) ??
                value.toStringAsFixed(0);
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
          showTitles: showBottomLabels,
          reservedSize: 30,
          interval: _getXInterval(),
          getTitlesWidget: (value, meta) {
            final label = bottomLabelFormatter?.call(value) ?? '';
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

  List<LineChartBarData> _buildLineBarsData() {
    return dataSeries.map((series) {
      return LineChartBarData(
        spots: series.dataPoints
            .map((point) => FlSpot(point.x, point.y))
            .toList(),
        color: series.color,
        barWidth: series.lineWidth,
        isCurved: series.isCurved,
        curveSmoothness: 0.3,
        dotData: FlDotData(
          show: series.showDots,
          getDotPainter: (spot, percent, bar, index) {
            return FlDotCirclePainter(
              radius: 3,
              color: series.color,
              strokeWidth: 0,
            );
          },
        ),
        belowBarData: series.showFill
            ? BarAreaData(
                show: true,
                color: series.color.withValues(alpha: 0.1),
              )
            : BarAreaData(show: false),
      );
    }).toList();
  }

  LineTouchData _buildLineTouchData() {
    if (!showTooltip) {
      return const LineTouchData(enabled: false);
    }

    return LineTouchData(
      enabled: true,
      touchCallback: onTooltipCallback,
      handleBuiltInTouches: true,
      touchTooltipData: LineTouchTooltipData(
        getTooltipColor: (touchedSpot) => const Color(0xFF2D3245), // Figma: #2D3245
        tooltipRoundedRadius: 11.266, // Figma: rounded-[11.266px]
        tooltipPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        getTooltipItems: (touchedSpots) {
          if (touchedSpots.isEmpty) return [];

          // Build custom tooltip with date header and values
          final List<LineTooltipItem> items = [];

          // First item includes the date header
          final firstSpot = touchedSpots.first;
          final spotIndex = firstSpot.spotIndex;
          final firstSeries = dataSeries[firstSpot.barIndex];
          final dataPoint = spotIndex < firstSeries.dataPoints.length
              ? firstSeries.dataPoints[spotIndex]
              : null;

          // Get date label
          String dateLabel = '';
          if (dataPoint?.date != null) {
            final date = dataPoint!.date!;
            final months = ['Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun', 'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'];
            dateLabel = '${date.day} de ${months[date.month - 1]} ${date.year}';
          } else if (dataPoint?.label != null) {
            dateLabel = dataPoint!.label!;
          }

          for (int i = 0; i < touchedSpots.length; i++) {
            final spot = touchedSpots[i];
            final series = dataSeries[spot.barIndex];

            // Determine dot color for this series
            Color dotColor;
            if (series.label == 'IBOV') {
              dotColor = const Color(0xFFDFDFE0);
            } else {
              dotColor = const Color(0xFFBADBC1);
            }

            final valueText = '${spot.y.toStringAsFixed(2)}%';

            if (i == 0 && dateLabel.isNotEmpty) {
              // First item: date header + first value
              items.add(LineTooltipItem(
                '$dateLabel\n',
                const TextStyle(
                  color: Color(0xFFDFDFE0),
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.1878,
                ),
                children: [
                  TextSpan(
                    text: '● $valueText',
                    style: TextStyle(
                      color: dotColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.1878,
                    ),
                  ),
                ],
              ));
            } else {
              // Subsequent items: just the value with dot
              items.add(LineTooltipItem(
                '● $valueText',
                TextStyle(
                  color: dotColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.1878,
                ),
              ));
            }
          }

          return items;
        },
      ),
      getTouchedSpotIndicator: (barData, spotIndexes) {
        return spotIndexes.map((index) {
          return TouchedSpotIndicatorData(
            FlLine(
              color: Colors.white.withValues(alpha: 0.3),
              strokeWidth: 1,
              dashArray: [5, 5],
            ),
            FlDotData(
              show: true,
              getDotPainter: (spot, percent, bar, _) {
                return FlDotCirclePainter(
                  radius: 5,
                  color: bar.color ?? ChartColors.portfolioLine,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
          );
        }).toList();
      },
    );
  }

  double _getMinX() {
    double minX = double.infinity;
    for (final series in dataSeries) {
      for (final point in series.dataPoints) {
        if (point.x < minX) minX = point.x;
      }
    }
    return minX.isFinite ? minX : 0;
  }

  double _getMaxX() {
    double maxX = double.negativeInfinity;
    for (final series in dataSeries) {
      for (final point in series.dataPoints) {
        if (point.x > maxX) maxX = point.x;
      }
    }
    return maxX.isFinite ? maxX : 100;
  }

  double _getMinY() {
    double minY = double.infinity;
    for (final series in dataSeries) {
      for (final point in series.dataPoints) {
        if (point.y < minY) minY = point.y;
      }
    }
    // Add some padding
    return minY.isFinite ? minY - (minY.abs() * 0.1) : 0;
  }

  double _getMaxY() {
    double maxY = double.negativeInfinity;
    for (final series in dataSeries) {
      for (final point in series.dataPoints) {
        if (point.y > maxY) maxY = point.y;
      }
    }
    // Add some padding
    return maxY.isFinite ? maxY + (maxY.abs() * 0.1) : 100;
  }

  double _getXInterval() {
    final range = _getMaxX() - _getMinX();
    if (range <= 0) return 1;
    return range / 5; // 5 vertical grid lines
  }

  double _getYInterval() {
    final range = _getMaxY() - _getMinY();
    if (range <= 0) return 1;
    return range / 4; // 4 horizontal grid lines
  }
}

/// Represents a single data series in the line chart.
class LineChartSeries {
  final String label;
  final List<ChartDataPoint> dataPoints;
  final Color color;
  final double lineWidth;
  final bool isCurved;
  final bool showDots;
  final bool showFill;

  const LineChartSeries({
    required this.label,
    required this.dataPoints,
    required this.color,
    this.lineWidth = 2,
    this.isCurved = true,
    this.showDots = false,
    this.showFill = false,
  });
}

/// Represents a single data point in the chart.
class ChartDataPoint {
  final double x;
  final double y;
  final DateTime? date;
  final String? label;

  const ChartDataPoint({
    required this.x,
    required this.y,
    this.date,
    this.label,
  });
}
