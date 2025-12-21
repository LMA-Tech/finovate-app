/// User favorite stock model (for detailed favorite info)
class UserFavorite {
  final String id;
  final String ticker;
  final String? name;
  final DateTime createdAt;

  const UserFavorite({
    required this.id,
    required this.ticker,
    this.name,
    required this.createdAt,
  });

  factory UserFavorite.fromJson(Map<String, dynamic> json) {
    return UserFavorite(
      id: json['id'] as String,
      ticker: json['ticker'] as String,
      name: json['name'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ticker': ticker,
      'name': name,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

/// Response wrapper for user favorites list
/// API returns: { "data": { "favorites": ["PETR4", "VALE3"], "count": 2 } }
class UserFavoritesResponse {
  final List<String> favorites;
  final int count;

  const UserFavoritesResponse({
    required this.favorites,
    required this.count,
  });

  factory UserFavoritesResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return UserFavoritesResponse(
      favorites: (data['favorites'] as List).cast<String>(),
      count: data['count'] as int? ?? 0,
    );
  }
}
