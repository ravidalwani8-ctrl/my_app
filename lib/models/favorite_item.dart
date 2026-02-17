import 'dart:convert';

class FavoriteItem {
  final double inputValue;
  final double resultValue;
  final double? rateUsed;
  final String fromUnit;
  final String toUnit;
  final String category;
  final DateTime timestamp;

  FavoriteItem({
    required this.inputValue,
    required this.resultValue,
    this.rateUsed,
    required this.fromUnit,
    required this.toUnit,
    required this.category,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'inputValue': inputValue,
    'resultValue': resultValue,
    'rateUsed': rateUsed,
    'fromUnit': fromUnit,
    'toUnit': toUnit,
    'category': category,
    'timestamp': timestamp.toIso8601String(),
  };

  factory FavoriteItem.fromJson(Map<String, dynamic> json) {
    final legacyInput = (json['inputValue'] as num).toDouble();
    final hasResult = json['resultValue'] != null;
    return FavoriteItem(
      inputValue: hasResult ? legacyInput : 1,
      resultValue: hasResult
          ? (json['resultValue'] as num).toDouble()
          : legacyInput,
      rateUsed: (json['rateUsed'] as num?)?.toDouble(),
      fromUnit: json['fromUnit'],
      toUnit: json['toUnit'],
      category: json['category'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  static String encode(List<FavoriteItem> items) =>
      json.encode(items.map((e) => e.toJson()).toList());

  static List<FavoriteItem> decode(String items) =>
      (json.decode(items) as List<dynamic>)
          .map((item) => FavoriteItem.fromJson(item))
          .toList();
}
