import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/widgets/app_background.dart';
import '../../common/widgets/error_state.dart';
import '../../common/widgets/scrollable_header.dart';
import '../../common/widgets/segmented_tabs.dart';
import '../../utils/constants/sizes.dart';
import '../../utils/constants/text_strings.dart';
import 'stock_detail_screen.dart';
import 'stocks_controller.dart';
import 'widgets/pagination_controls.dart';
import 'widgets/search_suggestions.dart';
import 'widgets/stock_list_item.dart';
import 'widgets/stock_search_bar.dart';

/// Main stocks list screen ("Ações")
class StocksScreen extends StatelessWidget {
  const StocksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StocksController());
    final searchController = TextEditingController();

    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Obx(() {
            if (controller.error.value.isNotEmpty) {
              return ErrorState(
                message: controller.error.value,
                onRetry: () => controller.loadStocks(),
              );
            }

            return _buildStockList(searchController, controller);
          }),
        ),
      ),
    );
  }

  Widget _buildSearchAndFilters(
    TextEditingController searchController,
    StocksController controller,
  ) {
    return Column(
      children: [
        // Header with back button and centered title
        const ScrollableHeader(title: FinTexts.stocksScreenTitle),

        const SizedBox(height: FinSizes.lg), // 32

        // Search bar
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: FinSizes.md,
            vertical: FinSizes.sm,
          ),
          child: StockSearchBar(
            controller: searchController,
            onChanged: (value) => controller.searchStocks(value),
            onSubmitted: () => controller.applySearch(),
            onClear: () {
              searchController.clear();
              controller.clearSearch();
            },
          ),
        ),

        // Search suggestions dropdown
        Obx(() {
          if (controller.searchSuggestions.isEmpty &&
              !controller.isSearching.value) {
            return const SizedBox.shrink();
          }
          return SearchSuggestions(
            suggestions: controller.searchSuggestions,
            isLoading: controller.isSearching.value,
            onSuggestionTap: (suggestion) {
              searchController.text = suggestion.ticker;
              controller.selectSuggestion(suggestion);
            },
          );
        }),

        const SizedBox(height: FinSizes.md), // 16

        // Filter tabs
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: FinSizes.md),
          child: Obx(() => SegmentedTabs(
                tabs: StocksController.filterOptions,
                selectedIndex: controller.selectedFilter.value,
                onTabChanged: (index) => controller.changeFilter(index),
              )),
        ),

        const SizedBox(height: FinSizes.xl), // 32
      ],
    );
  }

  Widget _buildStockList(
    TextEditingController searchController,
    StocksController controller,
  ) {
    // Total items = 1 for search/filters + stocks + 1 for pagination controls
    final itemCount = controller.stocks.length + 2;

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        // First item is search bar and filters
        if (index == 0) {
          return _buildSearchAndFilters(searchController, controller);
        }

        // Last item is pagination controls
        if (index == itemCount - 1) {
          return Obx(() => PaginationControls(
                currentPage: controller.currentPage,
                totalPages: controller.totalPages,
                hasPrevious: controller.hasPreviousPage,
                hasNext: controller.hasNextPage,
                onPrevious: () => controller.previousPage(),
                onNext: () => controller.nextPage(),
              ));
        }

        // Stock items (index - 1 because first item is search/filters)
        final stock = controller.stocks[index - 1];
        return StockListItem(
          stock: stock,
          onTap: () {
            Get.to(() => StockDetailScreen(
              ticker: stock.ticker,
              basicStock: stock,
            ));
          },
        );
      },
    );
  }
}
