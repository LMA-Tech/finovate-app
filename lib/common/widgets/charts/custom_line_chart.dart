import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:finovate_app/utils/constants/chart_colors.dart';
import 'package:finovate_app/utils/formatters.dart';

/// A reusable line chart component with Finovate styling.
///
/// Supports multiple data series for comparing portfolio vs benchmarks.
/// Based on Figma design specs from docs/figma-chart-requirements.md
class CustomLineChart extends StatefulWidget {
  final List<LineChartSeries> dataSeries;
  final double height;
  final bool showGrid;
  final bool showTooltip;
  final bool showLeftLabels;
  final bool showBottomLabels;
  final bool showInteractionHints;
  final String Function(double value)? leftLabelFormatter;
  final String Function(double value)? bottomLabelFormatter;
  final String Function(double value)? tooltipValueFormatter;
  final Function(FlTouchEvent, LineTouchResponse?)? onTooltipCallback;

  const CustomLineChart({
    required this.dataSeries,
    this.height = 200,
    this.showGrid = true,
    this.showTooltip = true,
    this.showLeftLabels = false,
    this.showBottomLabels = true,
    this.showInteractionHints = false,
    this.leftLabelFormatter,
    this.bottomLabelFormatter,
    this.tooltipValueFormatter,
    this.onTooltipCallback,
    super.key,
  });

  @override
  State<CustomLineChart> createState() => _CustomLineChartState();
}

class _CustomLineChartState extends State<CustomLineChart>
    with SingleTickerProviderStateMixin {
  AnimationController? _pulseController;
  Animation<double>? _pulseAnimation;

  @override
  void initState() {
    super.initState();
    if (widget.showInteractionHints) {
      _initPulseAnimation();
    }
  }

  void _initPulseAnimation() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Pulse effect: 1.0 -> 1.4 -> 1.0
    _pulseAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.4)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.4, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
    ]).animate(_pulseController!);

    // Run animation once
    _pulseController!.forward();
  }

  @override
  void dispose() {
    _pulseController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.showInteractionHints && _pulseAnimation != null) {
      return AnimatedBuilder(
        animation: _pulseAnimation!,
        builder: (context, child) => _buildChart(),
      );
    }
    return _buildChart();
  }

  Widget _buildChart() {
    return SizedBox(
      height: widget.height,
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
    if (!widget.showGrid) {
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
          showTitles: widget.showLeftLabels,
          reservedSize: 45,
          interval: _getYInterval(),
          getTitlesWidget: (value, meta) {
            final label = widget.leftLabelFormatter?.call(value) ??
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
          showTitles: widget.showBottomLabels,
          reservedSize: 30,
          interval: 1,
          getTitlesWidget: (value, meta) {
            // Only show labels at integer indices (actual data points)
            if (value != value.roundToDouble()) {
              return const SizedBox.shrink();
            }

            final index = value.toInt();
            final totalPoints = _getTotalDataPoints();

            // Calculate which indices to show labels for (max 5 labels)
            if (!_shouldShowLabelAtIndex(index, totalPoints)) {
              return const SizedBox.shrink();
            }

            final label = widget.bottomLabelFormatter?.call(value) ?? '';
            // Skip empty labels
            if (label.isEmpty) {
              return const SizedBox.shrink();
            }
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
    return widget.dataSeries.map((series) {
      final spots = series.dataPoints
          .map((point) => FlSpot(point.x, point.y))
          .toList();
      final lastIndex = spots.length - 1;

      // Determine if we should show dots (either from series config or interaction hints)
      final shouldShowDots = series.showDots || widget.showInteractionHints;

      return LineChartBarData(
        spots: spots,
        color: series.color,
        barWidth: series.lineWidth,
        isCurved: series.isCurved,
        curveSmoothness: 0.3,
        dotData: FlDotData(
          show: shouldShowDots,
          checkToShowDot: (spot, barData) {
            if (series.showDots) {
              // If series wants all dots, show all
              return true;
            }
            if (widget.showInteractionHints) {
              // Only show first and last dots for interaction hints
              final spotIndex = barData.spots.indexOf(spot);
              return spotIndex == 0 || spotIndex == lastIndex;
            }
            return false;
          },
          getDotPainter: (spot, percent, bar, index) {
            // Get pulse scale (1.0 if no animation or animation complete)
            final pulseScale = _pulseAnimation?.value ?? 1.0;

            // Check if this is an endpoint dot (for interaction hints)
            final isEndpoint = index == 0 || index == lastIndex;
            final shouldPulse = widget.showInteractionHints && isEndpoint;

            return FlDotCirclePainter(
              radius: shouldPulse ? 4 * pulseScale : 3,
              color: series.color,
              strokeWidth: shouldPulse ? 1.5 : 0,
              strokeColor: Colors.white.withValues(alpha: 0.6),
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
    if (!widget.showTooltip) {
      return const LineTouchData(enabled: false);
    }

    return LineTouchData(
      enabled: true,
      touchCallback: widget.onTooltipCallback,
      handleBuiltInTouches: true,
      // Larger threshold for easier touch detection, especially with fewer data points
      touchSpotThreshold: 40,
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
          final firstSeries = widget.dataSeries[firstSpot.barIndex];
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
            final series = widget.dataSeries[spot.barIndex];

            // Determine dot color for this series
            Color dotColor;
            if (series.label == 'IBOV') {
              dotColor = const Color(0xFFDFDFE0);
            } else {
              dotColor = const Color(0xFFBADBC1);
            }

            final valueText = widget.tooltipValueFormatter?.call(spot.y) ??
                FinFormatters.formatNumber(spot.y);

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
    for (final series in widget.dataSeries) {
      for (final point in series.dataPoints) {
        if (point.x < minX) minX = point.x;
      }
    }
    return minX.isFinite ? minX : 0;
  }

  double _getMaxX() {
    double maxX = double.negativeInfinity;
    for (final series in widget.dataSeries) {
      for (final point in series.dataPoints) {
        if (point.x > maxX) maxX = point.x;
      }
    }
    return maxX.isFinite ? maxX : 100;
  }

  double _getMinY() {
    double minY = double.infinity;
    for (final series in widget.dataSeries) {
      for (final point in series.dataPoints) {
        if (point.y < minY) minY = point.y;
      }
    }
    // Add some padding
    return minY.isFinite ? minY - (minY.abs() * 0.1) : 0;
  }

  double _getMaxY() {
    double maxY = double.negativeInfinity;
    for (final series in widget.dataSeries) {
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

  /// Get total number of data points from the first series
  int _getTotalDataPoints() {
    if (widget.dataSeries.isEmpty) return 0;
    return widget.dataSeries.first.dataPoints.length;
  }

  /// Determine if a label should be shown at a given index
  /// Shows max 5 labels evenly distributed across the data points
  bool _shouldShowLabelAtIndex(int index, int totalPoints) {
    if (totalPoints <= 5) {
      // Show all labels if 5 or fewer data points
      return true;
    }

    // For more data points, show labels at evenly spaced intervals
    // Always show first and last, plus 3 in between (5 total)
    const maxLabels = 5;
    final step = (totalPoints - 1) / (maxLabels - 1);

    // Check if this index is at one of the label positions
    for (int i = 0; i < maxLabels; i++) {
      final labelIndex = (i * step).round();
      if (index == labelIndex) {
        return true;
      }
    }
    return false;
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
