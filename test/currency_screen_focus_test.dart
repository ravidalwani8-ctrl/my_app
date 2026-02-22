import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unit_converter/screens/currency_screen.dart';

void main() {
  Finder rateEditable() => find.byType(EditableText).at(1);

  testWidgets('currency rate field keeps focus while typing x and / operations', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: CurrencyScreen()));

    final rateField = find.byWidgetPredicate(
      (w) =>
          w is TextField &&
          w.decoration?.labelText == "Conversion Rate (Enter numeric only)",
    );

    await tester.tap(rateField);
    await tester.pump();
    await tester.showKeyboard(rateField);
    await tester.pump();

    expect(tester.widget<EditableText>(rateEditable()).focusNode.hasFocus, isTrue);

    tester.testTextInput.updateEditingValue(
      const TextEditingValue(
        text: '1x',
        selection: TextSelection.collapsed(offset: 2),
      ),
    );
    await tester.pump();
    expect(find.text('1×10^'), findsOneWidget);
    expect(tester.widget<EditableText>(rateEditable()).focusNode.hasFocus, isTrue);

    tester.testTextInput.updateEditingValue(
      const TextEditingValue(
        text: '1/',
        selection: TextSelection.collapsed(offset: 2),
      ),
    );
    await tester.pump();
    expect(find.text('1×10^'), findsOneWidget);
    expect(tester.widget<EditableText>(rateEditable()).focusNode.hasFocus, isTrue);
  });

  testWidgets('currency rate field keeps focus while backspacing scientific text', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: CurrencyScreen()));

    final rateField = find.byWidgetPredicate(
      (w) =>
          w is TextField &&
          w.decoration?.labelText == "Conversion Rate (Enter numeric only)",
    );

    await tester.tap(rateField);
    await tester.pump();
    await tester.showKeyboard(rateField);
    await tester.pump();

    tester.testTextInput.updateEditingValue(
      const TextEditingValue(
        text: '1x23',
        selection: TextSelection.collapsed(offset: 4),
      ),
    );
    await tester.pump();

    expect(find.text('1×10^23'), findsOneWidget);
    expect(tester.widget<EditableText>(rateEditable()).focusNode.hasFocus, isTrue);

    await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
    await tester.pump();
    expect(tester.widget<EditableText>(rateEditable()).focusNode.hasFocus, isTrue);
  });

}
