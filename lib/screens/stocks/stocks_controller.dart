import 'package:get/get.dart';

import '../../models/stock.dart';
import '../../services/app_logger.dart';
import '../../services/finovate_api_service.dart';
import '../../utils/constants/text_strings.dart';
import '../../utils/helpers/helper_functions.dart';

/// Controller for Stocks list screen
class StocksController extends GetxController {
  static const String _tag = 'StocksController';

  // Filter options
  static List<String> get filterOptions => [
        FinTexts.stocksFilterAll,
        FinTexts.stocksFilterTopGainers,
        FinTexts.stocksFilterTopLosers,
      ];

  // Pagination config
  static const int itemsPerPage = 10;

  // Observable state
  final RxInt selectedFilter = 0.obs;
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = true.obs;
  final RxString error = ''.obs;

  // Data state
  final RxList<Stock> stocks = <Stock>[].obs;
  final Rx<PaginationInfo?> pagination = Rx<PaginationInfo?>(null);

  // Search suggestions
  final RxList<StockSearchSuggestion> searchSuggestions = <StockSearchSuggestion>[].obs;
  final RxBool isSearching = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadStocks();
  }

  /// Load stocks for a specific page
  Future<void> loadStocks({int page = 1}) async {
    isLoading.value = true;
    error.value = '';

    try {
      final sortBy = _getSortBy();
      final sortOrder = _getSortOrder();

      final response = await FinovateApiService.getMarketStocks(
        page: page,
        limit: itemsPerPage,
        sortBy: sortBy,
        sortOrder: sortOrder,
        search: searchQuery.value.isNotEmpty ? searchQuery.value : null,
      );

      stocks.value = response.stocks;
      pagination.value = response.pagination;
      AppLogger.debug('Stocks loaded: ${stocks.length} items, page ${response.pagination.page} of ${response.pagination.totalPages}', tag: _tag);
    } catch (e) {
      AppLogger.error('Error loading stocks', error: e, tag: _tag);
      error.value = FinHelperFunctions.getErrorMessage(e);
    } finally {
      isLoading.value = false;
    }
  }

  /// Go to next page
  void nextPage() {
    if (!hasNextPage) return;
    final nextPageNum = (pagination.value?.page ?? 1) + 1;
    loadStocks(page: nextPageNum);
  }

  /// Go to previous page
  void previousPage() {
    if (!hasPreviousPage) return;
    final prevPageNum = (pagination.value?.page ?? 1) - 1;
    loadStocks(page: prevPageNum);
  }

  /// Search stocks with debounce
  Future<void> searchStocks(String query) async {
    searchQuery.value = query;

    if (query.isEmpty) {
      searchSuggestions.clear();
      loadStocks();
      return;
    }

    if (query.length < 2) return;

    isSearching.value = true;

    try {
      final suggestions = await FinovateApiService.searchStocks(
        search: query,
        limit: 10,
      );
      searchSuggestions.value = suggestions;
    } catch (e) {
      AppLogger.error('Error searching stocks', error: e, tag: _tag);
    } finally {
      isSearching.value = false;
    }
  }

  /// Apply search and load results
  void applySearch() {
    searchSuggestions.clear();
    loadStocks();
  }

  /// Clear search
  void clearSearch() {
    searchQuery.value = '';
    searchSuggestions.clear();
    loadStocks();
  }

  /// Select a suggestion from autocomplete
  void selectSuggestion(StockSearchSuggestion suggestion) {
    searchQuery.value = suggestion.ticker;
    searchSuggestions.clear();
    loadStocks();
  }

  /// Change filter and reload from page 1
  void changeFilter(int index) {
    if (selectedFilter.value == index) return;
    selectedFilter.value = index;
    loadStocks();
  }

  /// Get sort field based on selected filter
  String _getSortBy() {
    switch (selectedFilter.value) {
      case 1: // Maiores altas
      case 2: // Maiores baixas
        return 'change';
      default: // Todas
        return 'volume';
    }
  }

  /// Get sort order based on selected filter
  String _getSortOrder() {
    switch (selectedFilter.value) {
      case 1: // Maiores altas - highest change first
        return 'desc';
      case 2: // Maiores baixas - lowest change first
        return 'asc';
      default: // Todas - by volume desc
        return 'desc';
    }
  }

  // Pagination helpers
  bool get hasNextPage => pagination.value?.hasNext ?? false;
  bool get hasPreviousPage => pagination.value?.hasPrev ?? false;
  int get currentPage => pagination.value?.page ?? 1;
  int get totalPages => pagination.value?.totalPages ?? 1;

  /// Get filter label
  String get currentFilterLabel => filterOptions[selectedFilter.value];
}
