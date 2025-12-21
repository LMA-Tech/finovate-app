import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/widgets/stock_logo.dart';
import '../../../common/widgets/trend_change_pill.dart';
import '../../../models/stock.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/formatters.dart';
import '../stock_detail_controller.dart';

/// Stock info section showing logo, name, type, price, and change.
/// Price updates when user drags through the chart.
class StockInfoSection extends StatelessWidget {
  final StockDetail stock;
  final StockDetailController controller;

  const StockInfoSection({
    required this.stock,
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            StockLogo(
              ticker: stock.ticker,
              logoUrl: stock.logoUrl,
              borderRadius: BorderRadius.circular(FinSizes.borderRadiusXLg),
            ),
            const SizedBox(width: FinSizes.sm + FinSizes.xs),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stock.longName,
                    style: const TextStyle(
                      fontSize: FinSizes.fontSizeMd,
                      fontWeight: FontWeight.w500,
                      color: FinColors.textWhite,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: FinSizes.xs / 2),
                  Text(
                    stock.typeLabel,
                    style: const TextStyle(
                      fontSize: FinSizes.fontSizeS,
                      fontWeight: FontWeight.w400,
                      color: FinColors.textGray200,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: FinSizes.md),
        Obx(() => _buildPriceColumn()),
      ],
    );
  }

  Widget _buildPriceColumn() {
    final touchedPrice = controller.touchedPrice.value;
    final displayPrice = touchedPrice ?? stock.price.current;
    final isTouching = touchedPrice != null;

    double changeValue;
    double changePercent;
    bool isPositive;
    bool isNegative;

    if (isTouching && stock.chart.prices.isNotEmpty) {
      final firstPrice = stock.chart.prices.first;
      changeValue = displayPrice - firstPrice;
      changePercent = firstPrice > 0 ? (changeValue / firstPrice) * 100 : 0;
      isPositive = changeValue > 0;
      isNegative = changeValue < 0;
    } else {
      changeValue = stock.price.changeValue;
      changePercent = stock.price.changePercent;
      isPositive = stock.price.isPositive;
      isNegative = stock.price.isNegative;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          FinFormatters.formatCurrency(displayPrice),
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: FinColors.textWhite,
          ),
        ),
        const SizedBox(height: FinSizes.xs),
        TrendChangePill.fromState(
          changeValue: changeValue,
          changePercent: changePercent,
          isPositive: isPositive,
          isNegative: isNegative,
        ),
        if (controller.selectedRange.value == '1d' && !isTouching) ...[
          const SizedBox(height: FinSizes.xs),
          Text(
            FinFormatters.formatRelativeTime(stock.chart.updatedAt),
            style: const TextStyle(
              fontSize: FinSizes.fontSizeSm,
              fontWeight: FontWeight.w400,
              color: FinColors.textWhite,
            ),
          ),
        ],
      ],
    );
  }
}
