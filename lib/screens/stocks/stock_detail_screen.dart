import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/widgets/app_background.dart';
import '../../common/widgets/error_state.dart';
import '../../common/widgets/loading_state.dart';
import '../../models/stock.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/sizes.dart';
import 'stock_detail_controller.dart';
import 'widgets/stock_detail_header.dart';
import 'widgets/stock_info_section.dart';
import 'widgets/price_history_chart.dart';
import 'widgets/company_info_section.dart';
import 'widgets/financial_indicators_section.dart';
import 'widgets/basic_stock_info_section.dart';

/// Stock detail screen showing price chart, company info, and financial indicators
class StockDetailScreen extends StatelessWidget {
  final String ticker;
  final Stock? basicStock; // Basic data from list (used when detail unavailable)

  const StockDetailScreen({
    required this.ticker,
    this.basicStock,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      StockDetailController(ticker: ticker),
      tag: ticker,
    );

    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              // Header with back button, ticker, and bookmark
              StockDetailHeader(
                ticker: ticker,
                controller: controller,
              ),

              // Content
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const LoadingState();
                  }

                  // Connection/server errors - show retry option
                  if (controller.error.value.isNotEmpty) {
                    return ErrorState(
                      message: controller.error.value,
                      onRetry: () => controller.loadStockDetail(),
                    );
                  }

                  // Stock data not available (404/not found)
                  if (controller.isDataUnavailable.value) {
                    return _buildPartialDataView();
                  }

                  final stock = controller.stockDetail.value;
                  if (stock == null) {
                    return const LoadingState();
                  }

                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: FinSizes.md,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: FinSizes.md),

                        // Stock info (logo, name, type, price)
                        StockInfoSection(stock: stock, controller: controller),

                        const SizedBox(height: FinSizes.md),

                        // Price history chart
                        PriceHistoryChartSection(
                          controller: controller,
                        ),

                        const SizedBox(height: FinSizes.xl),

                        // About company
                        if (stock.company?.description != null ||
                            stock.industry != null)
                          CompanyInfoSection(stock: stock),

                        if (stock.company?.description != null ||
                            stock.industry != null)
                          const SizedBox(height: FinSizes.xl),

                        // Financial indicators
                        FinancialIndicatorsSection(
                          stock: stock,
                          controller: controller,
                        ),

                        const SizedBox(height: FinSizes.xl),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build view when we have basic stock data but detailed data is unavailable
  Widget _buildPartialDataView() {
    if (basicStock == null) {
      // No basic data available - show simple message
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(FinSizes.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.info_outline,
                size: 48,
                color: FinColors.textGray300,
              ),
              const SizedBox(height: FinSizes.md),
              Text(
                'Dados detalhados indisponíveis',
                style: TextStyle(
                  fontSize: FinSizes.fontSizeMd,
                  fontWeight: FontWeight.w500,
                  color: FinColors.textWhite,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: FinSizes.sm),
              Text(
                'Não foi possível carregar as informações detalhadas de $ticker.',
                style: TextStyle(
                  fontSize: FinSizes.fontSizeSm,
                  color: FinColors.textGray200,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    // Show basic stock info + unavailable message for the rest
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: FinSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: FinSizes.md),

          // Basic stock info from list
          BasicStockInfoSection(stock: basicStock!),

          const SizedBox(height: FinSizes.xl),

          // Unavailable data card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(FinSizes.lg),
            decoration: BoxDecoration(
              color: FinColors.cardBackground,
              borderRadius: BorderRadius.circular(FinSizes.borderRadiusMd),
              border: Border.all(
                color: FinColors.textGray300.withValues(alpha: 0.2),
                width: FinSizes.borderWidthSm,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 32,
                  color: FinColors.textGray300,
                ),
                const SizedBox(height: FinSizes.sm),
                Text(
                  'Dados detalhados indisponíveis',
                  style: TextStyle(
                    fontSize: FinSizes.fontSizeSm,
                    fontWeight: FontWeight.w500,
                    color: FinColors.textWhite,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: FinSizes.xs),
                Text(
                  'Histórico de preços, indicadores financeiros e informações da empresa não estão disponíveis para esta ação no momento.',
                  style: TextStyle(
                    fontSize: FinSizes.fontSizeXs,
                    color: FinColors.textGray300,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: FinSizes.xl),
        ],
      ),
    );
  }
}
