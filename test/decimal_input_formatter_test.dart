import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/utils/decimal_text_input_formatter.dart';

void main() {
  group('DecimalTextInputFormatter', () {
    final f = DecimalTextInputFormatter(decimalRange: 3);

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
  });
}
