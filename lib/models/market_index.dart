/// Market index model for indices like IBOV, S&P500, etc.
class MarketIndex {
  final String code;
  final String name;
  final double value;
  final double changePercent;
  final double? changeValue;
  final String trend; // "up", "down", "neutral"
  final DateTime? lastUpdate;

  const MarketIndex({
    required this.code,
    required this.name,
    required this.value,
    required this.changePercent,
    this.changeValue,
    required this.trend,
    this.lastUpdate,
  });

  bool get isPositive => trend == 'up';
  bool get isNegative => trend == 'down';

  /// Format value with thousand separators (Brazilian format)
  String get formattedValue {
    final parts = value.toStringAsFixed(2).split('.');
    final intPart = parts[0].replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]}.',
    );
    return '$intPart,${parts[1]}';
  }

  /// Format change percent with sign
  String get formattedChangePercent {
    final sign = isPositive ? '+' : '';
    return '$sign${changePercent.toStringAsFixed(2).replaceAll('.', ',')}%';
  }

  factory MarketIndex.fromJson(Map<String, dynamic> json) {
    return MarketIndex(
      code: json['code'] as String,
      name: json['name'] as String,
      value: (json['value'] as num).toDouble(),
      changePercent: (json['change_percent'] as num).toDouble(),
      changeValue: json['change_value'] != null
          ? (json['change_value'] as num).toDouble()
          : null,
      trend: json['trend'] as String? ?? 'neutral',
      lastUpdate: json['last_update'] != null
          ? DateTime.parse(json['last_update'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'value': value,
      'change_percent': changePercent,
      'change_value': changeValue,
      'trend': trend,
      'last_update': lastUpdate?.toIso8601String(),
    };
  }
}

/// Response wrapper for market indices list
class MarketIndicesResponse {
  final List<MarketIndex> indices;
  final bool isMock;

  const MarketIndicesResponse({
    required this.indices,
    this.isMock = false,
  });

  factory MarketIndicesResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return MarketIndicesResponse(
      indices: (data['indices'] as List)
          .map((i) => MarketIndex.fromJson(i as Map<String, dynamic>))
          .toList(),
      isMock: data['is_mock'] as bool? ?? false,
    );
  }
}
