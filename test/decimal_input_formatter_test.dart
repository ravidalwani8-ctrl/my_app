import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/utils/decimal_text_input_formatter.dart';

void main() {
  group('DecimalTextInputFormatter', () {
    final f = DecimalTextInputFormatter(decimalRange: 3, allowScientific: true);

    test('allows integers', () {
      final out = f.formatEditUpdate(
        const TextEditingValue(text: ''),
        const TextEditingValue(text: '123'),
      );
      expect(out.text, '123');
    });

    test('allows decimal up to range', () {
      final out = f.formatEditUpdate(
        const TextEditingValue(text: ''),
        const TextEditingValue(text: '12.345'),
      );
      expect(out.text, '12.345');
    });

    test('prevents extra decimals', () {
      final oldVal = const TextEditingValue(text: '12.345');
      final next = const TextEditingValue(text: '12.3456');
      final out = f.formatEditUpdate(oldVal, next);
      expect(out.text, '12.345');
    });

    test('prevents multiple dots', () {
      final oldVal = const TextEditingValue(text: '1.2');
      final next = const TextEditingValue(text: '1.2.3');
      final out = f.formatEditUpdate(oldVal, next);
      expect(out.text, '1.2');
    });

    test('rejects letters', () {
      final out = f.formatEditUpdate(
        const TextEditingValue(text: ''),
        const TextEditingValue(text: '12a'),
      );
      expect(out.text, '');
    });

    test('rejects negatives by default', () {
      final out = f.formatEditUpdate(
        const TextEditingValue(text: ''),
        const TextEditingValue(text: '-12.3'),
      );
      expect(out.text, '');
    });

    test('accepts scientific notation', () {
      final out = f.formatEditUpdate(
        const TextEditingValue(text: ''),
        const TextEditingValue(text: '1.23e-4'),
      );
      expect(out.text, '1.23e-4');
    });

    test('expands x to ×10^', () {
      final out = f.formatEditUpdate(
        const TextEditingValue(text: '1'),
        const TextEditingValue(text: '1x'),
      );
      expect(out.text, '1×10^');
    });

    test('backspace on ×10^ removes marker at once', () {
      final oldVal = TextEditingValue(
        text: '1×10^23',
        selection: TextSelection.collapsed(offset: 5),
      );
      final next = TextEditingValue(
        text: '1×1023',
        selection: TextSelection.collapsed(offset: 4),
      );
      final out = f.formatEditUpdate(oldVal, next);
      expect(out.text, '123');
    });
  });

  group('DecimalTextInputFormatter negative mode', () {
    final f = DecimalTextInputFormatter(
      decimalRange: 3,
      allowNegative: true,
      allowScientific: true,
    );

    test('allows leading minus for negatives', () {
      final out = f.formatEditUpdate(
        const TextEditingValue(text: ''),
        const TextEditingValue(text: '-12.3'),
      );
      expect(out.text, '-12.3');
    });

    test('normalizes -. to -0.', () {
      final out = f.formatEditUpdate(
        const TextEditingValue(text: '-'),
        const TextEditingValue(text: '-.'),
      );
      expect(out.text, '-0.');
    });
  });
}
