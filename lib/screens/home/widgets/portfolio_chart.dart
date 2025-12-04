import 'package:flutter/material.dart';
import '../../../common/widgets/charts/custom_line_chart.dart';
import '../../../common/widgets/charts/chart_legend.dart';
import '../../../utils/constants/chart_colors.dart';
import '../../../utils/constants/sizes.dart';

/// Portfolio Chart Component
/// Displays a line chart with portfolio performance vs benchmark (IBOV)
/// Using fl_chart via CustomLineChart component
class PortfolioChart extends StatelessWidget {
  const PortfolioChart({
    super.key,
    this.height = 200,
    this.portfolioReturn = 9.21,
    this.benchmarkReturn = 7.13,
    this.portfolioData,
    this.benchmarkData,
    this.selectedPeriod = 0,
  });

  final double height;
  final double portfolioReturn;
  final double benchmarkReturn;
  final List<ChartDataPoint>? portfolioData;
  final List<ChartDataPoint>? benchmarkData;
  final int selectedPeriod;

  @override
  Widget build(BuildContext context) {
    final data = _getChartData();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: FinSizes.defaultSpace),
      child: Column(
        children: [
          // Chart (no performance indicators above - they show in tooltip only)
          CustomLineChart(
            dataSeries: data,
            height: height,
            showGrid: true,
            showTooltip: true,
            showBottomLabels: false, // No month labels per Figma
          ),

          const SizedBox(height: 16),

          // Legend below chart, aligned to the right per Figma
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ChartLegend(
                mainAxisAlignment: MainAxisAlignment.end,
                items: [
                  LegendItem(
                    label: 'IBOV',
                    color: ChartColors.ibovLine, // Blue to match the IBOV line
                    strokeColor: const Color(0xFF68686E),
                  ),
                  LegendItem(
                    label: 'Sua carteira',
                    color: ChartColors.portfolioLine, // Green to match portfolio line
                    strokeColor: const Color(0xFF39DDA2),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Get chart data - uses provided data or sample data
  List<LineChartSeries> _getChartData() {
    // Use provided data or generate sample data
    final portfolio = portfolioData ?? _generateSamplePortfolioData();
    final benchmark = benchmarkData ?? _generateSampleBenchmarkData();

    return [
      LineChartSeries(
        label: 'IBOV',
        dataPoints: benchmark,
        color: ChartColors.ibovLine,
        lineWidth: 2,
        isCurved: true,
      ),
      LineChartSeries(
        label: 'Sua carteira',
        dataPoints: portfolio,
        color: ChartColors.portfolioLine,
        lineWidth: 2,
        isCurved: true,
      ),
    ];
  }

  /// Generate sample portfolio data for demonstration
  List<ChartDataPoint> _generateSamplePortfolioData() {
    // Sample data showing portfolio performance (percentage change from base)
    return const [
      ChartDataPoint(x: 0, y: 0, label: 'Jan'),
      ChartDataPoint(x: 1, y: 1.5, label: 'Fev'),
      ChartDataPoint(x: 2, y: 3.2, label: 'Mar'),
      ChartDataPoint(x: 3, y: 2.8, label: 'Abr'),
      ChartDataPoint(x: 4, y: 5.5, label: 'Mai'),
      ChartDataPoint(x: 5, y: 7.0, label: 'Jun'),
      ChartDataPoint(x: 6, y: 6.2, label: 'Jul'),
      ChartDataPoint(x: 7, y: 8.5, label: 'Ago'),
      ChartDataPoint(x: 8, y: 9.21, label: 'Set'),
    ];
  }

  /// Generate sample benchmark (IBOV) data for demonstration
  List<ChartDataPoint> _generateSampleBenchmarkData() {
    // Sample data showing IBOV performance (percentage change from base)
    return const [
      ChartDataPoint(x: 0, y: 0, label: 'Jan'),
      ChartDataPoint(x: 1, y: 0.8, label: 'Fev'),
      ChartDataPoint(x: 2, y: 2.1, label: 'Mar'),
      ChartDataPoint(x: 3, y: 1.5, label: 'Abr'),
      ChartDataPoint(x: 4, y: 3.8, label: 'Mai'),
      ChartDataPoint(x: 5, y: 4.5, label: 'Jun'),
      ChartDataPoint(x: 6, y: 5.2, label: 'Jul'),
      ChartDataPoint(x: 7, y: 6.0, label: 'Ago'),
      ChartDataPoint(x: 8, y: 7.13, label: 'Set'),
    ];
  }

}
