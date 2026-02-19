import 'package:flutter_test/flutter_test.dart';
import 'package:unit_converter/models/history_item.dart';

void main() {
  test('HistoryItem encode/decode round-trip', () {
    final items = [
      HistoryItem(
        category: 'Length',
        fromUnit: 'Meter',
        toUnit: 'Kilometer',
        inputValue: '1200',
        result: '1.2',
        timestamp: DateTime(2026, 2, 17, 23, 30).toIso8601String(),
      ),
    ];

    final encoded = HistoryItem.encode(items);
    final decoded = HistoryItem.decode(encoded);

    expect(decoded, hasLength(1));
    expect(decoded.first.category, 'Length');
    expect(decoded.first.fromUnit, 'Meter');
    expect(decoded.first.toUnit, 'Kilometer');
    expect(decoded.first.inputValue, '1200');
    expect(decoded.first.result, '1.2');
    expect(decoded.first.timestamp, items.first.timestamp);
  });
}
