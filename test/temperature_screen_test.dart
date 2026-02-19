import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:my_app/screens/temperature_screen.dart';
import 'package:my_app/providers/favorites_provider.dart';
import 'package:my_app/providers/history_provider.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Preset applies values and converts', (tester) async {
    final favoritesProvider = FavoritesProvider();
    final historyProvider = HistoryProvider();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: favoritesProvider),
          ChangeNotifierProvider.value(value: historyProvider),
        ],
        child: const MaterialApp(home: TemperatureScreen()),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.text('Boiling Point'));
    await tester.pumpAndSettle();

    final textField = tester.widget<TextField>(find.byType(TextField));
    expect(textField.controller?.text, '100');
    expect(find.text('212 Fahrenheit'), findsOneWidget);
  });

  testWidgets('Save to favorites and history', (tester) async {
    final favoritesProvider = FavoritesProvider();
    final historyProvider = HistoryProvider();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: favoritesProvider),
          ChangeNotifierProvider.value(value: historyProvider),
        ],
        child: const MaterialApp(home: TemperatureScreen()),
      ),
    );

    await tester.pumpAndSettle();

    final state = tester.state(find.byType(TemperatureScreen)) as dynamic;
    state.input = '25';
    state.convert();
    await tester.pumpAndSettle();

    state.saveFavorite();
    await tester.pumpAndSettle();

    state.saveHistory();
    await tester.pumpAndSettle();

    expect(favoritesProvider.favorites.length, 1);
    expect(favoritesProvider.favorites.first.category, 'Temperature');
    expect(historyProvider.history.length, 1);
    expect(historyProvider.history.first.category, 'Temperature');
  });

}
