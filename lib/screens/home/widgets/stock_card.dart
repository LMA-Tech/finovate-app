import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    this.logoUrl,
    this.onTap,
  });

  final String symbol;
  final String companyName;
  final String price;
  final String change;
  final String changePercent;
  final bool isPositive;
  final String? logoPath; // Local asset path
  final String? logoUrl; // Network URL
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
                children: [
                  // Logo
                  Container(
                    width: 41,
                    height: 41,
                    decoration: BoxDecoration(
                      color: FinColors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: _buildLogo(),
                  ),

                  const SizedBox(width: 8),

                  // Symbol and company name - Expanded to prevent overflow
                  Expanded(
                    child: Column(
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
                          overflow: TextOverflow.ellipsis,
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
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Trend indicator
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: isPositive
                          ? FinColors.trendPositiveBg
                          : FinColors.trendNegativeIconBg,
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

  /// Build logo widget - network image (SVG or raster), asset image, or fallback to letter
  Widget _buildLogo() {
    // Try network image first
    if (logoUrl != null && logoUrl!.isNotEmpty) {
      // Check if it's an SVG
      if (logoUrl!.toLowerCase().endsWith('.svg')) {
        return SvgPicture.network(
          logoUrl!,
          width: 41,
          height: 41,
          fit: BoxFit.contain,
          placeholderBuilder: (context) => _buildFallbackLogo(),
        );
      }
      // Regular raster image
      return Image.network(
        logoUrl!,
        width: 41,
        height: 41,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildFallbackLogo(),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildFallbackLogo();
        },
      );
    }
    // Try local asset
    if (logoPath != null && logoPath!.isNotEmpty) {
      return Image.asset(
        logoPath!,
        width: 41,
        height: 41,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildFallbackLogo(),
      );
    }
    // Fallback to letter
    return _buildFallbackLogo();
  }

  /// Fallback logo showing first letter of symbol
  Widget _buildFallbackLogo() {
    return Center(
      child: Text(
        symbol.isNotEmpty ? symbol[0] : '?',
        style: const TextStyle(
          color: FinColors.black,
          fontSize: 18,
          fontWeight: FontWeight.w600,
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

        // Stocks horizontal list or empty state
        SizedBox(
          height: 140,
          child: stocks.isEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: FinSizes.defaultSpace),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: FinColors.cardBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        'Não foi possível carregar as ações',
                        style: TextStyle(
                          color: FinColors.textGray300,
                          fontSize: FinSizes.fontSizeSm,
                        ),
                      ),
                    ),
                  ),
                )
              : ListView.builder(
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
                        logoUrl: stock.logoUrl,
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
    this.logoUrl,
    this.onTap,
  });

  final String symbol;
  final String companyName;
  final String price;
  final String change;
  final String changePercent;
  final bool isPositive;
  final String? logoPath; // Local asset path
  final String? logoUrl; // Network URL
  final VoidCallback? onTap;
}