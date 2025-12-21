import 'package:flutter/material.dart';

import '../../../common/widgets/stock_logo.dart';
import '../../../common/widgets/trend_change_pill.dart';
import '../../../models/stock.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';

/// Basic stock info section using data from the stock list.
/// Used when detailed stock data is unavailable.
class BasicStockInfoSection extends StatelessWidget {
  final Stock stock;

  const BasicStockInfoSection({
    required this.stock,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Row(
            children: [
              StockLogo(
                ticker: stock.ticker,
                logoUrl: stock.logoUrl,
              ),
              const SizedBox(width: FinSizes.sm + FinSizes.xs),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stock.name,
                      style: const TextStyle(
                        fontSize: FinSizes.fontSizeMd,
                        fontWeight: FontWeight.w500,
                        color: FinColors.textWhite,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: FinSizes.xs / 2),
                    Text(
                      _getTypeLabel(),
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
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              stock.formattedPrice,
              style: const TextStyle(
                fontSize: FinSizes.fontSizeXXLg,
                fontWeight: FontWeight.w700,
                color: FinColors.textWhite,
              ),
            ),
            const SizedBox(height: FinSizes.xs),
            TrendChangePill.fromState(
              changeValue: stock.changeValue ?? 0,
              changePercent: stock.changePercent,
              isPositive: stock.isPositive,
              isNegative: stock.isNegative,
              showValue: stock.formattedChangeValue != null,
            ),
          ],
        ),
      ],
    );
  }

  String _getTypeLabel() {
    switch (stock.type) {
      case 'stock':
        return 'Ação';
      case 'fund':
        return 'FII';
      case 'bdr':
        return 'BDR';
      case 'etf':
        return 'ETF';
      default:
        return 'Ação';
    }
  }
}
