part of 'home_screen.dart';

abstract class HomeController extends State<HomeScreen> {
  // Period keys that match the API
  static const List<String> periodKeys = ['week', 'month', 'three_months', 'twelve_months'];

  // Reactive state for UI interactions
  final selectedTab = 0.obs; // 0: Rentabilidade, 1: Risco, 2: Composição
  final selectedPeriod = 0.obs; // 0: week, 1: month, 2: three_months, 3: twelve_months

  // Loading state - single loading state for all home data
  final isLoading = true.obs;

  // Data state
  final Rx<DashboardSummary?> dashboardSummary = Rx<DashboardSummary?>(null);

  // Error state
  final RxString error = ''.obs;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// Load all home screen data from single dashboard endpoint
  Future<void> _loadDashboardData() async {
    isLoading.value = true;
    error.value = '';

    try {
      final summary = await FinovateApiService.getDashboardSummary();
      dashboardSummary.value = summary;
      log('Dashboard loaded: user=${summary.user.firstName}, b3Connected=${summary.user.hasB3Connected}');
      log('Featured stocks: ${summary.featuredStocks.length}');
      log('Indicators: ${summary.indicators.length}');
    } catch (e) {
      log('Error loading dashboard: $e');
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh all data (for pull-to-refresh)
  Future<void> refreshData() async {
    await _loadDashboardData();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // CONVENIENCE GETTERS - For backward compatibility with existing widgets
  // ═══════════════════════════════════════════════════════════════════════════

  /// Get stocks from dashboard summary (replaces separate stocks loading)
  List<Stock> get stocks => dashboardSummary.value?.featuredStocks ?? [];

  /// Get indicators from dashboard summary (replaces separate indicators loading)
  List<MarketIndicator> get indicators => dashboardSummary.value?.indicators ?? [];

  // Indicators to show on home screen (in order) - for filtering
  static const List<String> _homeIndicatorIds = ['usd_brl', 'eur_brl', 'selic'];

  /// Get filtered indicators for home screen display
  List<MarketIndicator> get filteredIndicators {
    final allIndicators = dashboardSummary.value?.indicators ?? [];
    final filtered = <MarketIndicator>[];

    for (final id in _homeIndicatorIds) {
      final indicator = allIndicators.firstWhere(
        (i) => i.id.toLowerCase() == id,
        orElse: () => allIndicators.firstWhere(
          (i) => i.id.toLowerCase().contains(id.split('_').first),
          orElse: () => MarketIndicator(
            id: id, name: id, value: 0, changePercent: 0, trend: 'stable',
          ),
        ),
      );
      if (indicator.value > 0) {
        filtered.add(indicator);
      }
    }
    return filtered;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // GETTERS - Expose data to UI
  // ═══════════════════════════════════════════════════════════════════════════

  /// Get user's full name from dashboard
  String get userName => dashboardSummary.value?.user.fullName ?? 'Usuário';

  /// Get user's first name from dashboard
  String get userFirstName => dashboardSummary.value?.user.firstName ?? 'Usuário';

  /// Check if B3 is connected
  bool get b3Connected => dashboardSummary.value?.user.hasB3Connected ?? false;

  /// Check if user is on free tier
  bool get isFreeUser => dashboardSummary.value?.user.isFreeUser ?? true;

  /// Get trial days remaining
  int get trialDaysRemaining => dashboardSummary.value?.user.trialDaysRemaining ?? 0;

  /// Check if user has unread notifications
  bool get hasNotifications => dashboardSummary.value?.notifications.hasUnread ?? false;

  /// Get unread notification count
  int get notificationCount => dashboardSummary.value?.notifications.unreadCount ?? 0;

  /// Get current period key based on selected period
  String get currentPeriodKey => periodKeys[selectedPeriod.value];

  /// Get period data for the selected period (contains both IBOV and portfolio metrics)
  PeriodData? get currentPeriodData {
    return dashboardSummary.value?.marketOverview.periods[currentPeriodKey];
  }

  /// Get IBOV metrics for the selected period
  IbovMetrics? get currentIbovMetrics {
    return currentPeriodData?.ibov;
  }

  /// Get portfolio metrics for the selected period (null if not yet available)
  PortfolioMetrics? get currentPortfolioMetrics {
    return currentPeriodData?.portfolio;
  }

  /// Get rentabilidade value for display (IBOV)
  String get rentabilidadeFormatted {
    return currentIbovMetrics?.formattedRentabilidade ?? '0%';
  }

  /// Get rentabilidade trend (IBOV)
  bool get rentabilidadeIsPositive {
    return currentIbovMetrics?.isPositive ?? true;
  }

  /// Get risco label for display (IBOV)
  String get riscoLabel {
    return currentIbovMetrics?.risco.label ?? 'Moderado';
  }

  /// Get IBOV risco data for display (level, label, volatility)
  RiscoData? get currentIbovRiscoData {
    return currentIbovMetrics?.risco;
  }

  /// Get portfolio risco data for display (when available)
  RiscoData? get currentPortfolioRiscoData {
    return currentPortfolioMetrics?.risco;
  }

  /// Convert IBOV chart data to ChartDataPoint list for the chart widget
  /// Values are already percentage changes from API (first value = 0, last = rentabilidade)
  List<ChartDataPoint>? getIbovChartData() {
    final chartData = currentIbovMetrics?.chart;
    if (chartData == null || chartData.values.isEmpty) return null;

    return chartData.values.asMap().entries.map((entry) {
      final index = entry.key;
      final value = entry.value;
      final label = index < chartData.labels.length ? chartData.labels[index] : '';
      return ChartDataPoint(
        x: index.toDouble(),
        y: value,
        label: label,
      );
    }).toList();
  }

  /// Convert portfolio chart data to ChartDataPoint list (when available)
  /// Values are already percentage changes from API (first value = 0, last = rentabilidade)
  List<ChartDataPoint>? getPortfolioChartData() {
    final chartData = currentPortfolioMetrics?.chart;
    if (chartData == null || chartData.values.isEmpty) return null;

    return chartData.values.asMap().entries.map((entry) {
      final index = entry.key;
      final value = entry.value;
      final label = index < chartData.labels.length ? chartData.labels[index] : '';
      return ChartDataPoint(
        x: index.toDouble(),
        y: value,
        label: label,
      );
    }).toList();
  }

  /// Get IBOV return percentage for display
  double get ibovReturnPercent {
    return currentIbovMetrics?.rentabilidade ?? 0.0;
  }

  /// Get portfolio return percentage for display (null if not available)
  double? get portfolioReturnPercent {
    return currentPortfolioMetrics?.rentabilidade;
  }

  /// Check if portfolio history is available for current period
  bool get hasPortfolioHistory {
    return currentPortfolioMetrics != null;
  }

  /// Get composicao (asset allocation) data
  ComposicaoData? get composicaoData {
    return dashboardSummary.value?.composicao;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // DATA MAPPERS - Convert API models to widget data models
  // ═══════════════════════════════════════════════════════════════════════════

  /// Map Stock model to StockData for widget
  List<StockData> getStockDataList() {
    return stocks.map((stock) => StockData(
      symbol: stock.ticker,
      companyName: stock.name,
      price: stock.formattedPrice,
      change: stock.formattedChangeValue ?? '',
      changePercent: stock.formattedChangePercent,
      isPositive: stock.isPositive,
      logoUrl: stock.logoUrl,
      onTap: () => _handleStockTap(stock),
    )).toList();
  }

  /// Map MarketIndicator model to EconomyIndicatorData for widget
  List<EconomyIndicatorData> getIndicatorDataList() {
    return filteredIndicators.map((indicator) => EconomyIndicatorData(
      title: _getIndicatorDisplayName(indicator.id, indicator.name),
      value: indicator.formattedValue,
      change: '',
      changePercent: indicator.formattedChangePercent,
      isPositive: indicator.isPositive,
      onTap: () => _handleIndicatorTap(indicator),
    )).toList();
  }

  /// Get display name for indicator - use API name or fallback to custom mapping
  String _getIndicatorDisplayName(String id, String apiName) {
    // First try to use the API-provided name
    if (apiName.isNotEmpty) {
      // Override some names for better display
      switch (id.toLowerCase()) {
        case 'selic':
          return 'Taxa de juros';
        default:
          return apiName;
      }
    }
    // Fallback mapping
    switch (id.toLowerCase()) {
      case 'usd_brl':
        return 'Dólar';
      case 'eur_brl':
        return 'Euro';
      case 'selic':
        return 'Taxa de juros';
      case 'ipca':
        return 'IPCA';
      case 'igpm':
        return 'IGP-M';
      default:
        return id;
    }
  }

  /// Handle stock card tap - navigate to stock detail screen
  void _handleStockTap(Stock stock) {
    log('Stock tapped: ${stock.ticker}');
    Get.to(
      () => StockDetailScreen(
        ticker: stock.ticker,
        basicStock: stock,
      ),
    );
  }

  /// Handle indicator card tap
  void _handleIndicatorTap(MarketIndicator indicator) {
    final bottomNav = Get.find<BottomNavigationController>();
    bottomNav.changeTab(1); // Navigate to Conjuntura tab
  }
}
