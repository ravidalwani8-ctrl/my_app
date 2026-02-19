import 'package:flutter_test/flutter_test.dart';
import 'package:unit_converter/models/history_item.dart';
import 'package:unit_converter/providers/history_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('HistoryProvider saves and reloads history', () async {
    SharedPreferences.setMockInitialValues({});

    final provider = HistoryProvider();
    await provider.loadHistory();
    expect(provider.history, isEmpty);

    final item = HistoryItem(
      category: 'Temperature',
      fromUnit: 'Celsius',
      toUnit: 'Fahrenheit',
      inputValue: '10',
      result: '50',
      timestamp: DateTime(2026, 2, 17, 23, 45).toIso8601String(),
    );

    await provider.addHistory(item);
    expect(provider.history.length, 1);

    final reloaded = HistoryProvider();
    await reloaded.loadHistory();
    expect(reloaded.history.length, 1);
    expect(reloaded.history.first.category, 'Temperature');
    expect(reloaded.history.first.result, '50');
  });
}
