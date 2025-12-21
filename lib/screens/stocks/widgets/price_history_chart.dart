import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/widgets/info_bottom_sheet.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_strings.dart';
import '../stock_detail_controller.dart';

/// Price history chart section with touch-to-scrub price display.
class PriceHistoryChartSection extends StatelessWidget {
  final StockDetailController controller;

  const PriceHistoryChartSection({
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final stock = controller.stockDetail.value;
      final isChartLoading = controller.isChartLoading.value;
      final touchedDate = controller.touchedDate.value;

      if (stock == null) {
        return const SizedBox(height: 300);
      }

      final prices = stock.chart.prices;
      final labels = stock.chart.labels;

      if (prices.isEmpty) {
        return SizedBox(
          height: 300,
          child: Center(
            child: Text(
              FinTexts.dataNotAvailable,
              style: const TextStyle(
                color: FinColors.textGray300,
                fontSize: FinSizes.fontSizeSm,
              ),
            ),
          ),
        );
      }

      final isPositiveTrend = prices.last >= prices.first;
      final lineColor =
          isPositiveTrend ? FinColors.trendPositive : FinColors.trendNegative;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 24,
            child: touchedDate != null
                ? Center(
                    child: Text(
                      touchedDate.toUpperCase(),
                      style: const TextStyle(
                        fontSize: FinSizes.fontSizeSm,
                        fontWeight: FontWeight.w400,
                        color: FinColors.textGray300,
                      ),
                    ),
                  )
                : Align(
                    alignment: Alignment.centerRight,
                    child: InfoIconButton(
                      title: FinTexts.stockDetailChartInfoTitle,
                      description: FinTexts.stockDetailChartInfoDescription,
                      color: FinColors.textGray300,
                    ),
                  ),
          ),
          SizedBox(
            height: 250,
            width: double.infinity,
            child: Stack(
              children: [
                AnimatedOpacity(
                  opacity: isChartLoading ? 0.5 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: _buildChart(prices, labels, lineColor),
                ),
                if (isChartLoading)
                  const Center(
                    child: CircularProgressIndicator(
                      color: FinColors.primary,
                      strokeWidth: 2,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: FinSizes.md),
          _buildTimeRangeSelector(),
          const SizedBox(height: 30),
          Text(
            '${FinTexts.stockDetailLastUpdate} ${controller.formattedLastUpdate}',
            style: const TextStyle(
              fontSize: FinSizes.fontSizeXs,
              fontWeight: FontWeight.w400,
              color: FinColors.textWhite,
              height: 1.98,
              letterSpacing: 0.08,
            ),
          ),
        ],
      );
    });
  }

  Widget _buildChart(List<double> prices, List<String> labels, Color lineColor) {
    final spots = <FlSpot>[];
    for (int i = 0; i < prices.length; i++) {
      spots.add(FlSpot(i.toDouble(), prices[i]));
    }

    final minY = prices.reduce((a, b) => a < b ? a : b);
    final maxY = prices.reduce((a, b) => a > b ? a : b);
    final yRange = maxY - minY;
    final yPadding = yRange > 0 ? yRange * 0.1 : minY * 0.1;

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: (prices.length - 1).toDouble(),
        minY: minY - yPadding,
        maxY: maxY + yPadding,
        clipData: const FlClipData.all(),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            curveSmoothness: 0.15,
            color: lineColor,
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
        ],
        lineTouchData: LineTouchData(
          enabled: true,
          handleBuiltInTouches: true,
          touchCallback: (FlTouchEvent event, LineTouchResponse? response) {
            if (event is FlPanEndEvent ||
                event is FlTapUpEvent ||
                event is FlLongPressEnd) {
              controller.clearChartTouch();
            } else if (response?.lineBarSpots != null &&
                response!.lineBarSpots!.isNotEmpty) {
              final index = response.lineBarSpots!.first.x.toInt();
              if (index >= 0 && index < prices.length) {
                final price = prices[index];
                final date = index < labels.length ? labels[index] : null;
                controller.updateChartTouch(index, price, date);
              }
            }
          },
          getTouchedSpotIndicator: (barData, spotIndexes) {
            return spotIndexes.map((index) {
              return TouchedSpotIndicatorData(
                const FlLine(
                  color: FinColors.textGray300,
                  strokeWidth: 1,
                ),
                FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, bar, index) {
                    return FlDotCirclePainter(
                      radius: 5,
                      color: lineColor,
                      strokeWidth: 2,
                      strokeColor: FinColors.textWhite,
                    );
                  },
                ),
              );
            }).toList();
          },
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (spot) => Colors.transparent,
            getTooltipItems: (spots) => spots.map((spot) => null).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeRangeSelector() {
    final ranges = ['1D', '1S', '1M', '3M', '6M', '1A', 'MAX'];
    final rangeValues = ['1d', '1w', '1mo', '3mo', '6mo', '1y', 'max'];

    return Obx(() {
      final selectedRange = controller.selectedRange.value;

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(ranges.length, (index) {
          final isSelected = selectedRange == rangeValues[index];

          return GestureDetector(
            onTap: () => controller.changeRange(rangeValues[index]),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: FinSizes.sm + 4,
                vertical: FinSizes.xs,
              ),
              decoration: BoxDecoration(
                color: isSelected ? FinColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(FinSizes.borderRadiusSm),
                border: isSelected
                    ? null
                    : Border.all(
                        color: FinColors.textGray300.withValues(alpha: 0.3)),
              ),
              child: Text(
                ranges[index],
                style: TextStyle(
                  fontSize: FinSizes.fontSizeSm,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? FinColors.textWhite : FinColors.textGray300,
                ),
              ),
            ),
          );
        }),
      );
    });
  }
}
