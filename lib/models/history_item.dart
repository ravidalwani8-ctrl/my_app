class HistoryItem {
  final String category;
  final String fromUnit;
  final String toUnit;
  final String inputValue;
  final String result;
  final String timestamp;

  HistoryItem({
    required this.category,
    required this.fromUnit,
    required this.toUnit,
    required this.inputValue,
    required this.result,
    required this.timestamp,
  });
}
