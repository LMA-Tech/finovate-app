import '../utils/formatters.dart';

/// Market indicator model for economic data (USD, SELIC, IPCA, etc.)
class MarketIndicator {
  final String id; // "usd_brl", "selic", "ipca", etc.
  final String name;
  final String? category; // "currency", "interest", "inflation"
  final double value;
  final String? formattedValueFromApi; // Pre-formatted value from API
  final double changePercent;
  final String trend; // "up", "down", "stable"
  final String? unit; // "%", "R$", etc.
  final String? source; // "brapi.dev"

  const MarketIndicator({
    required this.id,
    required this.name,
    this.category,
    required this.value,
    this.formattedValueFromApi,
    required this.changePercent,
    required this.trend,
    this.unit,
    this.source,
  });

  /// Alias for backward compatibility
  String get code => id;

  bool get isPositive => trend == 'up';
  bool get isNegative => trend == 'down';

  /// Format value - use API formatted value if available, else format based on type
  String get formattedValue {
    if (formattedValueFromApi != null) {
      return formattedValueFromApi!;
    }
    if (unit == '%') {
      return FinFormatters.formatPercent(value, showSign: false);
    } else if (unit == 'R\$' || id.contains('usd') || id.contains('eur')) {
      return FinFormatters.formatCurrency(value);
    }
    return FinFormatters.formatNumber(value, decimals: 2);
  }

  /// Format change percent with sign: 0.45 → "+0,45%"
  String get formattedChangePercent => FinFormatters.formatPercent(changePercent);

  factory MarketIndicator.fromJson(Map<String, dynamic> json) {
    return MarketIndicator(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String?,
      value: (json['value'] as num?)?.toDouble() ?? 0.0,
      formattedValueFromApi: json['formatted_value'] as String?,
      changePercent: (json['change_percent'] as num?)?.toDouble() ?? 0.0,
      trend: json['trend'] as String? ?? 'stable',
      unit: json['unit'] as String?,
      source: json['source'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'value': value,
      'formatted_value': formattedValueFromApi,
      'change_percent': changePercent,
      'trend': trend,
      'unit': unit,
      'source': source,
    };
  }
}

/// Response wrapper for market indicators list
class MarketIndicatorsResponse {
  final List<MarketIndicator> indicators;
  final bool isMock;

  const MarketIndicatorsResponse({
    required this.indicators,
    this.isMock = false,
  });

  factory MarketIndicatorsResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return MarketIndicatorsResponse(
      indicators: (data['indicators'] as List)
          .map((i) => MarketIndicator.fromJson(i as Map<String, dynamic>))
          .toList(),
      isMock: data['is_mock'] as bool? ?? false,
    );
  }
}
