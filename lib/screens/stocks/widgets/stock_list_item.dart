import 'package:flutter/material.dart';

import '../../../common/widgets/stock_logo.dart';
import '../../../models/stock.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';

/// Stock list item widget for stocks list screen.
class StockListItem extends StatelessWidget {
  final Stock stock;
  final VoidCallback? onTap;

  const StockListItem({
    required this.stock,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: FinSizes.md,
        vertical: FinSizes.xs,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(FinSizes.borderRadiusLg),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: FinSizes.sm + FinSizes.xs,
            horizontal: FinSizes.md,
          ),
          decoration: BoxDecoration(
            color: FinColors.stockItemBackground,
            borderRadius: BorderRadius.circular(FinSizes.borderRadiusLg),
            border: Border(
              left: BorderSide(
                width: FinSizes.borderWidthMd,
                color: _getBorderColor(),
              ),
            ),
          ),
          child: Row(
            children: [
              StockLogo(
                ticker: stock.ticker,
                logoUrl: stock.logoUrl,
                showBorder: true,
                borderRadius: BorderRadius.circular(FinSizes.avatarMd / 2),
              ),
              const SizedBox(width: FinSizes.sm + FinSizes.xs),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stock.ticker,
                      style: const TextStyle(
                        fontSize: FinSizes.fontSizeMd,
                        fontWeight: FontWeight.w600,
                        color: FinColors.textWhite,
                        height: 1.50,
                        letterSpacing: 0.10,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: FinSizes.xs / 2),
                    Text(
                      stock.name,
                      style: const TextStyle(
                        fontSize: FinSizes.fontSizeSm,
                        fontWeight: FontWeight.w500,
                        color: FinColors.textSubtitle,
                        height: 1.14,
                        letterSpacing: 0.40,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    stock.formattedPrice,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: FinSizes.fontSizeSm,
                      fontWeight: FontWeight.w500,
                      color: FinColors.textWhite,
                      height: 1.71,
                      letterSpacing: 0.10,
                    ),
                  ),
                  const SizedBox(height: FinSizes.xs / 2),
                  Text(
                    stock.formattedChangePercent,
                    style: TextStyle(
                      fontSize: FinSizes.fontSizeSm,
                      fontWeight: FontWeight.w500,
                      color: _getChangeColor(),
                      height: 1.14,
                      letterSpacing: 0.33,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: FinSizes.md),
              const Icon(
                Icons.chevron_right,
                size: FinSizes.iconLg,
                color: FinColors.textGray300,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getBorderColor() {
    if (stock.isPositive) return FinColors.avatarBorder;
    if (stock.isNegative) return FinColors.trendNegative;
    return FinColors.textGray300;
  }

  Color _getChangeColor() {
    if (stock.isPositive) return FinColors.avatarBorder;
    if (stock.isNegative) return FinColors.trendNegative;
    return FinColors.textGray300;
  }
}
