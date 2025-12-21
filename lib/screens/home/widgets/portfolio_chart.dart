import 'package:flutter/material.dart';
import '../../../common/widgets/charts/custom_line_chart.dart';
import '../../../common/widgets/charts/chart_legend.dart';
import '../../../common/widgets/risk_gauge.dart';
import '../../../models/dashboard_summary.dart';
import '../../../utils/constants/chart_colors.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_strings.dart';
import '../../../utils/formatters.dart';

/// Portfolio Chart Component
/// Displays a line chart with portfolio performance vs benchmark (IBOV)
/// Using fl_chart via CustomLineChart component
/// When B3 is not connected or portfolio history not available, only shows IBOV data
class PortfolioChart extends StatelessWidget {
  const PortfolioChart({
    super.key,
    this.height = 200,
    this.portfolioReturn = 0.0,
    this.benchmarkReturn = 0.0,
    this.portfolioData,
    this.benchmarkData,
    this.selectedPeriod = 0,
    this.b3Connected = false,
    this.hasPortfolioHistory = false,
    this.selectedTab = 0,
    this.ibovRiscoData,
    this.portfolioRiscoData,
  });

  final double height;
  final double portfolioReturn;
  final double benchmarkReturn;
  final List<ChartDataPoint>? portfolioData;
  final List<ChartDataPoint>? benchmarkData;
  final int selectedPeriod;
  final bool b3Connected;
  final bool hasPortfolioHistory;
  final int selectedTab; // 0: Rentabilidade, 1: Risco, 2: Composição
  final RiscoData? ibovRiscoData; // IBOV risk data (level, label, volatility)
  final RiscoData? portfolioRiscoData; // Portfolio risk data (when available)

  @override
  Widget build(BuildContext context) {
    // Risco tab (selectedTab == 1) - show RiskGauge instead of chart
    if (selectedTab == 1) {
      return _buildRiscoTab();
    }

    // Rentabilidade or Composição tabs - show chart
    final data = _getChartData();
    final legendItems = _getLegendItems();

    // Check if we have any data to display
    if (data.isEmpty || (data.first.dataPoints.isEmpty)) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: FinSizes.defaultSpace),
        child: Container(
          height: height,
          decoration: BoxDecoration(
            color: FinColors.cardBackground,
            borderRadius: BorderRadius.circular(FinSizes.borderRadiusLg),
          ),
          child: const Center(
            child: Text(
              FinTexts.dataNotAvailable,
              style: TextStyle(
                color: FinColors.textGray300,
                fontSize: FinSizes.fontSizeMd,
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: FinSizes.defaultSpace),
      child: Column(
        children: [
          // Chart with interaction hints for Rentabilidade tab
          CustomLineChart(
            dataSeries: data,
            height: height,
            showGrid: true,
            showTooltip: true,
            showBottomLabels: true,
            showInteractionHints: selectedTab == 0, // Pulse dots on Rentabilidade tab
            bottomLabelFormatter: _getBottomLabel,
            tooltipValueFormatter: _getTooltipValue,
          ),

          const SizedBox(height: FinSizes.md),

          // Legend below chart, aligned to the right per Figma
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ChartLegend(
                mainAxisAlignment: MainAxisAlignment.end,
                items: legendItems,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build the Risco tab content with RiskGauge widget
  Widget _buildRiscoTab() {
    // Use IBOV risco data as primary, fall back to defaults
    final riscoData = ibovRiscoData;

    if (riscoData == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: FinSizes.defaultSpace),
        child: Container(
          height: height,
          decoration: BoxDecoration(
            color: FinColors.cardBackground,
            borderRadius: BorderRadius.circular(FinSizes.borderRadiusLg),
          ),
          child: const Center(
            child: Text(
              FinTexts.riskDataNotAvailable,
              style: TextStyle(
                color: FinColors.textGray300,
                fontSize: FinSizes.fontSizeMd,
              ),
            ),
          ),
        ),
      );
    }

    // Show dual indicators when B3 is connected and portfolio risco data is available
    final showPortfolio = b3Connected && portfolioRiscoData != null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: FinSizes.defaultSpace),
      child: RiskGauge(
        level: riscoData.level,
        label: riscoData.label,
        volatility: riscoData.volatility,
        portfolioLevel: portfolioRiscoData?.level,
        portfolioLabel: portfolioRiscoData?.label,
        portfolioVolatility: portfolioRiscoData?.volatility,
        showPortfolio: showPortfolio,
      ),
    );
  }

  /// Get legend items based on B3 connection status and portfolio history availability
  List<LegendItem> _getLegendItems() {
    final items = <LegendItem>[
      LegendItem(
        label: 'IBOV',
        color: ChartColors.ibovLine,
        strokeColor: ChartColors.ibovStroke,
      ),
    ];

    // Only show portfolio legend if B3 is connected AND portfolio history is available
    if (b3Connected && hasPortfolioHistory) {
      items.add(
        LegendItem(
          label: 'Sua carteira',
          color: ChartColors.portfolioLine,
          strokeColor: ChartColors.portfolioStroke,
        ),
      );
    }

    return items;
  }

  /// Get tooltip value for Rentabilidade tab - shows percentage change
  String _getTooltipValue(double value) {
    return FinFormatters.formatPercent(value);
  }

  /// Get bottom label for x-axis from data point index
  String _getBottomLabel(double value) {
    final index = value.round();
    // Get label from benchmark data (IBOV) since it's always present
    if (benchmarkData != null && index >= 0 && index < benchmarkData!.length) {
      return benchmarkData![index].label ?? '';
    }
    return '';
  }

  /// Get chart data - uses provided data from API
  /// When B3 is not connected or portfolio history not available, only shows IBOV data
  List<LineChartSeries> _getChartData() {
    final series = <LineChartSeries>[];

    // IBOV benchmark line (always show if data available)
    if (benchmarkData != null && benchmarkData!.isNotEmpty) {
      series.add(
        LineChartSeries(
          label: 'IBOV',
          dataPoints: benchmarkData!,
          color: ChartColors.ibovLine,
          lineWidth: 2,
          isCurved: true,
        ),
      );
    }

    // Only add portfolio data if B3 is connected AND portfolio history is available
    if (b3Connected && hasPortfolioHistory && portfolioData != null && portfolioData!.isNotEmpty) {
      series.add(
        LineChartSeries(
          label: 'Sua carteira',
          dataPoints: portfolioData!,
          color: ChartColors.portfolioLine,
          lineWidth: 2,
          isCurved: true,
        ),
      );
    }

    return series;
  }
}
