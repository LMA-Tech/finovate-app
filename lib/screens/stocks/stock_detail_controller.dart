import 'package:get/get.dart';

import '../../models/stock.dart';
import '../../services/app_logger.dart';
import '../../services/finovate_api_service.dart';
import '../../utils/helpers/helper_functions.dart';

/// Controller for the stock detail screen
class StockDetailController extends GetxController {
  static const String _tag = 'StockDetailController';

  final String ticker;

  StockDetailController({required this.ticker});

  // State
  final Rx<StockDetail?> stockDetail = Rx<StockDetail?>(null);
  final RxBool isLoading = true.obs;
  final RxBool isChartLoading = false.obs; // Separate loading state for chart range changes
  final RxString error = ''.obs;
  final RxBool isDataUnavailable = false.obs; // True when stock data not found (404)
  final RxBool isFavorite = false.obs;
  final RxString selectedRange = '6mo'.obs;
  final RxBool isIndicatorsExpanded = false.obs;

  // Chart touch state - for updating price display while scrubbing
  final RxnInt touchedChartIndex = RxnInt(null);
  final RxnDouble touchedPrice = RxnDouble(null);
  final RxnString touchedDate = RxnString(null);

  // Available chart ranges
  static const List<String> chartRanges = ['1d', '1w', '1mo', '3mo', '6mo', '1y', 'max'];

  @override
  void onInit() {
    super.onInit();
    loadStockDetail();
  }

  /// Load stock detail from API
  Future<void> loadStockDetail() async {
    isLoading.value = true;
    error.value = '';
    isDataUnavailable.value = false;

    try {
      final detail = await FinovateApiService.getStockDetail(
        ticker: ticker,
        range: selectedRange.value,
      );

      stockDetail.value = detail;
      isFavorite.value = detail.isFavorite;
    } catch (e) {
      AppLogger.error('Error loading stock detail', error: e, tag: _tag);
      final errorString = e.toString().toLowerCase();

      // Check if it's a "not found" error (data unavailable)
      if (errorString.contains('404') ||
          errorString.contains('not found') ||
          errorString.contains('no data')) {
        isDataUnavailable.value = true;
      } else {
        // Connection or other errors
        error.value = FinHelperFunctions.getErrorMessage(e);
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// Change chart time range - only reloads chart data, not entire page
  Future<void> changeRange(String range) async {
    if (selectedRange.value == range) return;

    selectedRange.value = range;
    isChartLoading.value = true;

    try {
      final detail = await FinovateApiService.getStockDetail(
        ticker: ticker,
        range: range,
      );

      // Only update the chart data, keep other data
      stockDetail.value = detail;
    } catch (e) {
      AppLogger.error('Error loading chart data', error: e, tag: _tag);
      // Don't show error for range changes, just keep existing data
    } finally {
      isChartLoading.value = false;
    }
  }

  /// Toggle favorite status
  Future<void> toggleFavorite() async {
    final wasFavorite = isFavorite.value;

    // Optimistic update
    isFavorite.value = !wasFavorite;

    try {
      if (wasFavorite) {
        // Remove from favorites
        await FinovateApiService.removeFavorite(ticker: ticker);
      } else {
        // Add to favorites
        await FinovateApiService.addFavorite(ticker: ticker);
      }
    } catch (e) {
      AppLogger.error('Error toggling favorite', error: e, tag: _tag);
      // Revert on error
      isFavorite.value = wasFavorite;
    }
  }

  /// Toggle indicators expanded state
  void toggleIndicatorsExpanded() {
    isIndicatorsExpanded.value = !isIndicatorsExpanded.value;
  }

  /// Update chart touch state (called when user drags on chart)
  void updateChartTouch(int? index, double? price, String? date) {
    touchedChartIndex.value = index;
    touchedPrice.value = price;
    touchedDate.value = date;
  }

  /// Clear chart touch state (called when user releases)
  void clearChartTouch() {
    touchedChartIndex.value = null;
    touchedPrice.value = null;
    touchedDate.value = null;
  }

  /// Get formatted last update date
  String get formattedLastUpdate {
    if (stockDetail.value == null) return '';

    final date = stockDetail.value!.chart.updatedAt;
    final months = [
      'Janeiro',
      'Fevereiro',
      'Março',
      'Abril',
      'Maio',
      'Junho',
      'Julho',
      'Agosto',
      'Setembro',
      'Outubro',
      'Novembro',
      'Dezembro'
    ];

    return '${date.day} de ${months[date.month - 1]} ${date.year}';
  }
}
