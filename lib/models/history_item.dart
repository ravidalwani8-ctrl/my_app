import 'dart:convert';

class HistoryItem {
  final String category;
  final String fromUnit;
  final String toUnit;
  final String inputValue;
  final String result;
  final String timestamp;
  final String? rateUsed;

  HistoryItem({
    required this.category,
    required this.fromUnit,
    required this.toUnit,
    required this.inputValue,
    required this.result,
    required this.timestamp,
    this.rateUsed,
  });

  Map<String, dynamic> toJson() => {
    'category': category,
    'fromUnit': fromUnit,
    'toUnit': toUnit,
    'inputValue': inputValue,
    'result': result,
    'timestamp': timestamp,
    'rateUsed': rateUsed,
  };

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      category: json['category'] as String,
      fromUnit: json['fromUnit'] as String,
      toUnit: json['toUnit'] as String,
      inputValue: json['inputValue'] as String,
      result: json['result'] as String,
      timestamp: json['timestamp'] as String,
      rateUsed: json['rateUsed'] as String?,
    );
  }

  static String encode(List<HistoryItem> items) =>
      json.encode(items.map((e) => e.toJson()).toList());

  static List<HistoryItem> decode(String items) =>
      (json.decode(items) as List<dynamic>)
          .map((item) => HistoryItem.fromJson(item as Map<String, dynamic>))
          .toList();
}
