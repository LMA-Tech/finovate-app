import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/widgets/info_bottom_sheet.dart';
import '../../../models/stock.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_strings.dart';
import '../stock_detail_controller.dart';

/// Financial indicators section with expandable "Ver mais" for additional indicators.
class FinancialIndicatorsSection extends StatelessWidget {
  final StockDetail stock;
  final StockDetailController controller;

  const FinancialIndicatorsSection({
    required this.stock,
    required this.controller,
    super.key,
  });

  List<StockIndicator> _filterValidIndicators(List<StockIndicator> indicators) {
    return indicators
        .where((i) => i.formatted != '--' && i.formatted.isNotEmpty)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final defaultIndicators =
        _filterValidIndicators(stock.indicators.defaultIndicators);
    final additionalIndicators =
        _filterValidIndicators(stock.indicators.additionalIndicators);
    final hasAdditional = additionalIndicators.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              FinTexts.stockDetailIndicators,
              style: TextStyle(
                fontSize: FinSizes.fontSizeMd,
                fontWeight: FontWeight.w500,
                color: FinColors.textWhite,
              ),
            ),
            InfoIconButton(
              title: FinTexts.stockDetailIndicators,
              description: FinTexts.stockDetailIndicatorsInfo,
            ),
          ],
        ),
        const SizedBox(height: FinSizes.md),
        ...defaultIndicators.map(
          (indicator) => _IndicatorRow(indicator: indicator),
        ),
        if (hasAdditional)
          Obx(() {
            final isExpanded = controller.isIndicatorsExpanded.value;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isExpanded)
                  ...additionalIndicators.map(
                    (indicator) => _IndicatorRow(indicator: indicator),
                  ),
                const SizedBox(height: FinSizes.xs),
                GestureDetector(
                  onTap: controller.toggleIndicatorsExpanded,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: FinSizes.xs),
                    child: Text(
                      isExpanded
                          ? FinTexts.stockDetailSeeLess
                          : FinTexts.stockDetailSeeMore,
                      style: const TextStyle(
                        fontSize: FinSizes.fontSizeSm,
                        fontWeight: FontWeight.w500,
                        color: FinColors.primary,
                        decoration: TextDecoration.underline,
                        decorationColor: FinColors.primary,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
      ],
    );
  }
}

class _IndicatorRow extends StatelessWidget {
  final StockIndicator indicator;

  const _IndicatorRow({required this.indicator});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: FinSizes.listItemSm,
      margin: const EdgeInsets.only(bottom: FinSizes.sm),
      padding: const EdgeInsets.symmetric(
        horizontal: FinSizes.md,
        vertical: FinSizes.sm,
      ),
      decoration: BoxDecoration(
        color: FinColors.stockItemBackground,
        borderRadius: BorderRadius.circular(FinSizes.borderRadiusLg),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              indicator.label,
              style: const TextStyle(
                fontSize: FinSizes.fontSizeSm,
                fontWeight: FontWeight.w400,
                color: FinColors.textWhite,
              ),
            ),
          ),
          Text(
            indicator.formatted,
            style: const TextStyle(
              fontSize: FinSizes.fontSizeSm,
              fontWeight: FontWeight.w600,
              color: FinColors.textWhite,
            ),
          ),
        ],
      ),
    );
  }
}
