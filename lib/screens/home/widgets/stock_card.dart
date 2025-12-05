import 'package:flutter/material.dart';
import '../../../common/widgets/section_header.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';

/// Stock Card Component
/// Displays individual stock information with price and change data
class StockCard extends StatelessWidget {
  const StockCard({
    super.key,
    required this.symbol,
    required this.companyName,
    required this.price,
    required this.change,
    required this.changePercent,
    required this.isPositive,
    this.logoPath,
    this.onTap,
  });

  final String symbol;
  final String companyName;
  final String price;
  final String change;
  final String changePercent;
  final bool isPositive;
  final String? logoPath;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 212,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: FinColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with logo, symbol and trend indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo and symbol/company info
                  Row(
                    children: [
                      // Logo placeholder
                      Container(
                        width: 41,
                        height: 41,
                        decoration: BoxDecoration(
                          color: FinColors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: logoPath != null
                              ? Image.asset(logoPath!, width: 24, height: 24)
                              : Text(
                            symbol[0],
                            style: const TextStyle(
                              color: FinColors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      // Symbol and company name
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            symbol,
                            style: const TextStyle(
                              color: FinColors.textWhite,
                              fontSize: FinSizes.fontSizeMd,
                              fontWeight: FontWeight.w600,
                              height: 1.5,
                              letterSpacing: 0.1,
                            ),
                          ),
                          Text(
                            companyName,
                            style: const TextStyle(
                              color: FinColors.textSubtitle,
                              fontSize: FinSizes.fontSizeSm,
                              fontWeight: FontWeight.w500,
                              height: 1.14,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Trend indicator
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: isPositive
                          ? FinColors.trendPositiveBg
                          : FinColors.trendNegativeBg,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Icon(
                      isPositive
                          ? Icons.trending_up
                          : Icons.trending_down,
                      color: isPositive
                          ? FinColors.trendPositive
                          : FinColors.trendNegative,
                      size: 15,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Price and change information
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    price,
                    style: const TextStyle(
                      color: FinColors.textWhite,
                      fontSize: FinSizes.fontSizeSm,
                      fontWeight: FontWeight.w500,
                      height: 1.14,
                      letterSpacing: 0.4,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    '$change • $changePercent',
                    style: TextStyle(
                      color: isPositive
                          ? FinColors.trendPositive
                          : FinColors.trendNegative,
                      fontSize: FinSizes.fontSizeSm,
                      fontWeight: FontWeight.w500,
                      height: 1.14,
                      letterSpacing: 0.4,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Stocks Grid Component
/// Displays a horizontal scrollable list of stock cards
class StocksGrid extends StatelessWidget {
  const StocksGrid({
    super.key,
    required this.title,
    this.onSeeMorePressed,
    this.stocks = const [],
  });

  final String title;
  final VoidCallback? onSeeMorePressed;
  final List<StockData> stocks;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header using SectionHeader component
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: FinSizes.defaultSpace),
          child: SectionHeader(
            title: title,
            actionText: 'Ver mais',
            onActionTap: onSeeMorePressed,
          ),
        ),

        const SizedBox(height: 16),

        // Stocks horizontal list
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: FinSizes.defaultSpace),
            itemCount: stocks.length,
            itemBuilder: (context, index) {
              final stock = stocks[index];
              return Padding(
                padding: EdgeInsets.only(
                  right: index < stocks.length - 1 ? 12 : 0,
                ),
                child: StockCard(
                  symbol: stock.symbol,
                  companyName: stock.companyName,
                  price: stock.price,
                  change: stock.change,
                  changePercent: stock.changePercent,
                  isPositive: stock.isPositive,
                  logoPath: stock.logoPath,
                  onTap: stock.onTap,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Data model for stock information
class StockData {
  const StockData({
    required this.symbol,
    required this.companyName,
    required this.price,
    required this.change,
    required this.changePercent,
    required this.isPositive,
    this.logoPath,
    this.onTap,
  });

  final String symbol;
  final String companyName;
  final String price;
  final String change;
  final String changePercent;
  final bool isPositive;
  final String? logoPath;
  final VoidCallback? onTap;
}