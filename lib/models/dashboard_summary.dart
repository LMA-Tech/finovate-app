import '../utils/formatters.dart';
import 'stock.dart';
import 'market_indicator.dart';

/// Dashboard summary response from /dashboard/summary endpoint
class DashboardSummary {
  final DashboardUser user;
  final MarketOverview marketOverview;
  final PortfolioSummary? portfolio;
  final ComposicaoData? composicao;
  final NotificationsData notifications;
  final List<Stock> featuredStocks;
  final List<MarketIndicator> indicators;

  const DashboardSummary({
    required this.user,
    required this.marketOverview,
    this.portfolio,
    this.composicao,
    required this.notifications,
    required this.featuredStocks,
    required this.indicators,
  });

  factory DashboardSummary.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return DashboardSummary(
      user: DashboardUser.fromJson(data['user'] as Map<String, dynamic>),
      marketOverview: MarketOverview.fromJson(data['market_overview'] as Map<String, dynamic>),
      portfolio: data['portfolio'] != null
          ? PortfolioSummary.fromJson(data['portfolio'] as Map<String, dynamic>)
          : null,
      composicao: data['composicao'] != null
          ? ComposicaoData.fromJson(data['composicao'] as Map<String, dynamic>)
          : null,
      notifications: NotificationsData.fromJson(data['notifications'] as Map<String, dynamic>),
      featuredStocks: (data['featured_stocks'] as List? ?? [])
          .where((s) => s != null)
          .map((s) => Stock.fromJson(s as Map<String, dynamic>))
          .toList(),
      indicators: (data['indicators'] as List? ?? [])
          .where((i) => i != null)
          .map((i) => MarketIndicator.fromJson(i as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// User data from dashboard summary
class DashboardUser {
  final String firstName;
  final String lastName;
  final bool hasB3Connected;
  final String subscriptionTier;
  final int trialDaysRemaining;

  const DashboardUser({
    required this.firstName,
    required this.lastName,
    required this.hasB3Connected,
    required this.subscriptionTier,
    required this.trialDaysRemaining,
  });

  String get fullName => '$firstName $lastName';
  bool get isFreeUser => subscriptionTier == 'free';
  bool get isTrialActive => trialDaysRemaining > 0;

  factory DashboardUser.fromJson(Map<String, dynamic> json) {
    return DashboardUser(
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      hasB3Connected: json['has_b3_connected'] as bool? ?? false,
      subscriptionTier: json['subscription_tier'] as String? ?? 'free',
      trialDaysRemaining: json['trial_days_remaining'] as int? ?? 0,
    );
  }
}

/// Market overview with IBOV and portfolio data per period
class MarketOverview {
  final DateTime? updatedAt;
  final Map<String, PeriodData> periods;
  final Map<String, String>? historyAvailableAt;

  const MarketOverview({
    this.updatedAt,
    required this.periods,
    this.historyAvailableAt,
  });

  factory MarketOverview.fromJson(Map<String, dynamic> json) {
    final periodsJson = json['periods'] as Map<String, dynamic>? ?? {};

    return MarketOverview(
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      periods: periodsJson.map((key, value) =>
          MapEntry(key, PeriodData.fromJson(value as Map<String, dynamic>))),
      historyAvailableAt: json['history_available_at'] != null
          ? (json['history_available_at'] as Map<String, dynamic>)
              .map((key, value) => MapEntry(key, value as String))
          : null,
    );
  }
}

/// Period data containing IBOV and portfolio metrics
class PeriodData {
  final IbovMetrics ibov;
  final PortfolioMetrics? portfolio;

  const PeriodData({
    required this.ibov,
    this.portfolio,
  });

  factory PeriodData.fromJson(Map<String, dynamic> json) {
    return PeriodData(
      ibov: IbovMetrics.fromJson(json['ibov'] as Map<String, dynamic>),
      portfolio: json['portfolio'] != null
          ? PortfolioMetrics.fromJson(json['portfolio'] as Map<String, dynamic>)
          : null,
    );
  }
}

/// IBOV metrics for a period (rentabilidade, risco, chart)
class IbovMetrics {
  final double rentabilidade;
  final RiscoData risco;
  final ChartData chart;

  const IbovMetrics({
    required this.rentabilidade,
    required this.risco,
    required this.chart,
  });

  bool get isPositive => rentabilidade >= 0;
  bool get isNegative => rentabilidade < 0;

  /// Format rentabilidade: -3.81 → "-3,81%"
  String get formattedRentabilidade => FinFormatters.formatPercent(rentabilidade);

  factory IbovMetrics.fromJson(Map<String, dynamic> json) {
    return IbovMetrics(
      rentabilidade: (json['rentabilidade'] as num).toDouble(),
      risco: RiscoData.fromJson(json['risco'] as Map<String, dynamic>),
      chart: ChartData.fromJson(json['chart'] as Map<String, dynamic>),
    );
  }
}

/// Portfolio metrics for a period (when available)
class PortfolioMetrics {
  final double rentabilidade;
  final RiscoData risco;
  final ChartData chart;

  const PortfolioMetrics({
    required this.rentabilidade,
    required this.risco,
    required this.chart,
  });

  bool get isPositive => rentabilidade >= 0;
  bool get isNegative => rentabilidade < 0;

  /// Format rentabilidade: -3.81 → "-3,81%"
  String get formattedRentabilidade => FinFormatters.formatPercent(rentabilidade);

  factory PortfolioMetrics.fromJson(Map<String, dynamic> json) {
    return PortfolioMetrics(
      rentabilidade: (json['rentabilidade'] as num).toDouble(),
      risco: RiscoData.fromJson(json['risco'] as Map<String, dynamic>),
      chart: ChartData.fromJson(json['chart'] as Map<String, dynamic>),
    );
  }
}

/// Risco data for a period
class RiscoData {
  final String level; // "low", "moderate", "high"
  final String label; // "Baixo", "Moderado", "Alto"
  final double? volatility; // Raw annualized volatility (e.g., 0.28 = 28%)

  const RiscoData({
    required this.level,
    required this.label,
    this.volatility,
  });

  /// Format volatility as percentage: 0.28 → "28%"
  String get formattedVolatility {
    if (volatility == null) return '--';
    return FinFormatters.formatPercent(volatility! * 100, decimals: 0, showSign: false);
  }

  factory RiscoData.fromJson(Map<String, dynamic> json) {
    return RiscoData(
      level: json['level'] as String? ?? 'moderate',
      label: json['label'] as String? ?? 'Moderado',
      volatility: json['volatility'] != null
          ? (json['volatility'] as num).toDouble()
          : null,
    );
  }
}

/// Chart data with labels and values
class ChartData {
  final List<String> labels;
  final List<double> values;

  const ChartData({
    required this.labels,
    required this.values,
  });

  /// Get formatted values: 164456 → "164.456"
  List<String> get formattedValues =>
      values.map((v) => FinFormatters.formatNumber(v)).toList();

  factory ChartData.fromJson(Map<String, dynamic> json) {
    return ChartData(
      labels: (json['labels'] as List? ?? []).cast<String>(),
      values: (json['values'] as List? ?? [])
          .map((v) => (v as num).toDouble())
          .toList(),
    );
  }
}

/// Portfolio summary for dashboard (when B3 is connected)
class PortfolioSummary {
  final double totalValue;
  final double? dailyChange;
  final double? dailyChangePercent;
  final DateTime? connectedAt;
  final DateTime? lastSyncAt;

  const PortfolioSummary({
    required this.totalValue,
    this.dailyChange,
    this.dailyChangePercent,
    this.connectedAt,
    this.lastSyncAt,
  });

  bool get hasDailyChange => dailyChange != null && dailyChangePercent != null;
  bool get isPositive => (dailyChange ?? 0) >= 0;
  bool get isNegative => (dailyChange ?? 0) < 0;

  /// Format total value: 19100.00 → "R$ 19.100,00"
  String get formattedTotalValue => FinFormatters.formatCurrency(totalValue);

  /// Format change percent: -1.21 → "-1,21%"
  String get formattedChangePercent {
    if (dailyChangePercent == null) return '--';
    return FinFormatters.formatPercent(dailyChangePercent!);
  }

  /// Format change value: -234.50 → "-R$ 234,50"
  String get formattedChangeValue {
    if (dailyChange == null) return '--';
    return FinFormatters.formatCurrency(dailyChange!, showSign: true);
  }

  factory PortfolioSummary.fromJson(Map<String, dynamic> json) {
    return PortfolioSummary(
      totalValue: (json['total_value'] as num).toDouble(),
      dailyChange: json['daily_change'] != null
          ? (json['daily_change'] as num).toDouble()
          : null,
      dailyChangePercent: json['daily_change_percent'] != null
          ? (json['daily_change_percent'] as num).toDouble()
          : null,
      connectedAt: json['connected_at'] != null
          ? DateTime.parse(json['connected_at'] as String)
          : null,
      lastSyncAt: json['last_sync_at'] != null
          ? DateTime.parse(json['last_sync_at'] as String)
          : null,
    );
  }
}

/// Composicao (asset allocation) data
class ComposicaoData {
  final bool available;
  final String? reason;
  final DateTime? updatedAt;
  final List<ComposicaoBreakdown> breakdown;

  const ComposicaoData({
    required this.available,
    this.reason,
    this.updatedAt,
    this.breakdown = const [],
  });

  factory ComposicaoData.fromJson(Map<String, dynamic> json) {
    return ComposicaoData(
      available: json['available'] as bool? ?? false,
      reason: json['reason'] as String?,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      breakdown: json['breakdown'] != null
          ? (json['breakdown'] as List)
              .map((item) => ComposicaoBreakdown.fromJson(item as Map<String, dynamic>))
              .toList()
          : [],
    );
  }
}

/// Asset allocation breakdown item
class ComposicaoBreakdown {
  final String type;
  final String label;
  final double percentage;
  final double value;

  const ComposicaoBreakdown({
    required this.type,
    required this.label,
    required this.percentage,
    required this.value,
  });

  /// Format percentage: 65.4 → "65,4%"
  String get formattedPercentage =>
      FinFormatters.formatPercent(percentage, decimals: 1, showSign: false);

  /// Format value: 12500.00 → "R$ 12.500,00"
  String get formattedValue => FinFormatters.formatCurrency(value);

  factory ComposicaoBreakdown.fromJson(Map<String, dynamic> json) {
    return ComposicaoBreakdown(
      type: json['type'] as String,
      label: json['label'] as String,
      percentage: (json['percentage'] as num).toDouble(),
      value: (json['value'] as num).toDouble(),
    );
  }
}

/// Notifications data
class NotificationsData {
  final int unreadCount;

  const NotificationsData({
    required this.unreadCount,
  });

  bool get hasUnread => unreadCount > 0;

  factory NotificationsData.fromJson(Map<String, dynamic> json) {
    return NotificationsData(
      unreadCount: json['unread_count'] as int? ?? 0,
    );
  }
}
