import '../utils/formatters.dart';

/// Stock model for market data
class Stock {
  final String ticker;
  final String name;
  final String? logoUrl;
  final double price;
  final double changePercent;
  final double? changeValue;
  final String trend; // "up", "down", "neutral"
  final String? type; // "stock", "fii", "etf", "bdr"

  const Stock({
    required this.ticker,
    required this.name,
    this.logoUrl,
    required this.price,
    required this.changePercent,
    this.changeValue,
    required this.trend,
    this.type,
  });

  bool get isPositive => trend == 'up';
  bool get isNegative => trend == 'down';

  /// Format price as Brazilian Real: 38.20 → "R$ 38,20"
  String get formattedPrice => FinFormatters.formatCurrency(price);

  /// Format change percent with sign: 1.25 → "+1,25%"
  String get formattedChangePercent => FinFormatters.formatPercent(changePercent);

  /// Format change value with sign: 0.47 → "+R$ 0,47"
  String? get formattedChangeValue {
    if (changeValue == null) return null;
    return FinFormatters.formatCurrency(changeValue!, showSign: true);
  }

  /// Create from API JSON response
  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      ticker: json['ticker'] as String,
      name: json['name'] as String,
      logoUrl: json['logo_url'] as String?,
      price: (json['price'] as num).toDouble(),
      changePercent: (json['change_percent'] as num).toDouble(),
      changeValue: json['change_value'] != null
          ? (json['change_value'] as num).toDouble()
          : null,
      trend: json['trend'] as String? ?? 'neutral',
      type: json['type'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ticker': ticker,
      'name': name,
      'logo_url': logoUrl,
      'price': price,
      'change_percent': changePercent,
      'change_value': changeValue,
      'trend': trend,
      'type': type,
    };
  }
}

/// Response wrapper for paginated stock list
class StockListResponse {
  final List<Stock> stocks;
  final PaginationInfo pagination;
  final bool isMock;

  const StockListResponse({
    required this.stocks,
    required this.pagination,
    this.isMock = false,
  });

  factory StockListResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return StockListResponse(
      stocks: (data['stocks'] as List)
          .map((s) => Stock.fromJson(s as Map<String, dynamic>))
          .toList(),
      pagination: PaginationInfo.fromJson(data['pagination'] as Map<String, dynamic>),
      isMock: data['is_mock'] as bool? ?? false,
    );
  }
}

/// Pagination info for list responses
class PaginationInfo {
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final bool hasNext;
  final bool hasPrev;

  const PaginationInfo({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrev,
  });

  factory PaginationInfo.fromJson(Map<String, dynamic> json) {
    return PaginationInfo(
      page: json['page'] as int,
      limit: json['limit'] as int,
      total: json['total'] as int,
      totalPages: json['total_pages'] as int,
      hasNext: json['has_next'] as bool,
      hasPrev: json['has_prev'] as bool,
    );
  }
}

/// Lightweight stock suggestion for autocomplete search
class StockSearchSuggestion {
  final String ticker;
  final String name;

  const StockSearchSuggestion({
    required this.ticker,
    required this.name,
  });

  factory StockSearchSuggestion.fromJson(Map<String, dynamic> json) {
    return StockSearchSuggestion(
      ticker: json['ticker'] as String,
      name: json['name'] as String,
    );
  }
}

/// Detailed stock information for the detail screen
class StockDetail {
  final String ticker;
  final String name;
  final String longName;
  final String? logoUrl;
  final String type; // "stock", "bdr", "fii"
  final String? sector;
  final String? industry;
  final bool isFavorite;
  final StockPrice price;
  final StockChart chart;
  final StockCompany? company;
  final StockIndicators indicators;
  final DateTime updatedAt;
  final String dataSource;

  const StockDetail({
    required this.ticker,
    required this.name,
    required this.longName,
    this.logoUrl,
    required this.type,
    this.sector,
    this.industry,
    required this.isFavorite,
    required this.price,
    required this.chart,
    this.company,
    required this.indicators,
    required this.updatedAt,
    required this.dataSource,
  });

  /// Get stock type label in Portuguese
  String get typeLabel {
    switch (type) {
      case 'stock':
        return 'Ação ordinária';
      case 'bdr':
        return 'BDR';
      case 'fii':
        return 'Fundo Imobiliário';
      default:
        return 'Ação';
    }
  }

  factory StockDetail.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    return StockDetail(
      ticker: data['ticker'] as String,
      name: data['name'] as String,
      longName: data['long_name'] as String? ?? data['name'] as String,
      logoUrl: data['logo_url'] as String?,
      type: data['type'] as String? ?? 'stock',
      sector: data['sector'] as String?,
      industry: data['industry'] as String?,
      isFavorite: data['is_favorite'] as bool? ?? false,
      price: StockPrice.fromJson(data['price'] as Map<String, dynamic>),
      chart: StockChart.fromJson(data['chart'] as Map<String, dynamic>),
      company: data['company'] != null
          ? StockCompany.fromJson(data['company'] as Map<String, dynamic>)
          : null,
      indicators:
          StockIndicators.fromJson(data['indicators'] as Map<String, dynamic>),
      updatedAt: DateTime.parse(data['updated_at'] as String),
      dataSource: data['data_source'] as String? ?? 'brapi.dev',
    );
  }
}

/// Price information for stock detail
class StockPrice {
  final double current;
  final double changeValue;
  final double changePercent;
  final String trend;
  final double? open;
  final double? high;
  final double? low;
  final double? previousClose;
  final int? volume;

  const StockPrice({
    required this.current,
    required this.changeValue,
    required this.changePercent,
    required this.trend,
    this.open,
    this.high,
    this.low,
    this.previousClose,
    this.volume,
  });

  bool get isPositive => trend == 'up';
  bool get isNegative => trend == 'down';

  /// Format price as Brazilian Real
  String get formattedPrice => FinFormatters.formatCurrency(current);

  /// Format change value with sign
  String get formattedChangeValue =>
      FinFormatters.formatCurrency(changeValue, showSign: true);

  /// Format change percent with sign
  String get formattedChangePercent =>
      FinFormatters.formatPercent(changePercent);

  factory StockPrice.fromJson(Map<String, dynamic> json) {
    return StockPrice(
      current: (json['current'] as num).toDouble(),
      changeValue: (json['change_value'] as num).toDouble(),
      changePercent: (json['change_percent'] as num).toDouble(),
      trend: json['trend'] as String? ?? 'stable',
      open: json['open'] != null ? (json['open'] as num).toDouble() : null,
      high: json['high'] != null ? (json['high'] as num).toDouble() : null,
      low: json['low'] != null ? (json['low'] as num).toDouble() : null,
      previousClose: json['previous_close'] != null
          ? (json['previous_close'] as num).toDouble()
          : null,
      volume: json['volume'] as int?,
    );
  }
}

/// Chart data for stock detail
class StockChart {
  final String range;
  final List<String> labels;
  final List<double> prices;
  final DateTime updatedAt;

  const StockChart({
    required this.range,
    required this.labels,
    required this.prices,
    required this.updatedAt,
  });

  factory StockChart.fromJson(Map<String, dynamic> json) {
    return StockChart(
      range: json['range'] as String? ?? '6mo',
      labels:
          (json['labels'] as List<dynamic>).map((e) => e as String).toList(),
      prices: (json['prices'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}

/// Company information for stock detail
class StockCompany {
  final String? description;
  final String? website;
  final int? employees;
  final String? phone;
  final String? headquarters; // Combined from address1, city, state, country

  const StockCompany({
    this.description,
    this.website,
    this.employees,
    this.phone,
    this.headquarters,
  });

  factory StockCompany.fromJson(Map<String, dynamic> json) {
    // Build headquarters string from address components
    String? headquarters;
    final parts = <String>[];
    if (json['city'] != null) parts.add(json['city'] as String);
    if (json['state'] != null) parts.add(json['state'] as String);
    if (json['country'] != null) parts.add(json['country'] as String);
    if (parts.isNotEmpty) {
      headquarters = parts.join(', ');
    }

    return StockCompany(
      description: json['description'] as String?,
      website: json['website'] as String?,
      employees: json['employees'] as int?,
      phone: json['phone'] as String?,
      headquarters: headquarters,
    );
  }
}

/// Financial indicators for stock detail
class StockIndicators {
  final List<StockIndicator> defaultIndicators;
  final List<StockIndicator> additionalIndicators;

  const StockIndicators({
    required this.defaultIndicators,
    required this.additionalIndicators,
  });

  factory StockIndicators.fromJson(Map<String, dynamic> json) {
    return StockIndicators(
      defaultIndicators: (json['default'] as List<dynamic>)
          .map((e) => StockIndicator.fromJson(e as Map<String, dynamic>))
          .toList(),
      additionalIndicators: (json['additional'] as List<dynamic>)
          .map((e) => StockIndicator.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// Single financial indicator
class StockIndicator {
  final String id;
  final String label;
  final double? value;
  final String formatted;

  const StockIndicator({
    required this.id,
    required this.label,
    this.value,
    required this.formatted,
  });

  factory StockIndicator.fromJson(Map<String, dynamic> json) {
    return StockIndicator(
      id: json['id'] as String,
      label: json['label'] as String,
      value: json['value'] != null ? (json['value'] as num).toDouble() : null,
      formatted: json['formatted'] as String? ?? '--',
    );
  }
}
