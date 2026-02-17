import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/utils/number_formatter.dart';

void main() {
  test('parses e-notation as base e', () {
    final value = parseScientificInput('1e3');
    expect(value, isNotNull);
    expect((value! - math.exp(3)).abs() < 1e-9, isTrue);
  });

  test('parses x10^ as base 10', () {
    final value = parseScientificInput('1×10^3');
    expect(value, 1000);
  });

  test('formats large values using 10^ style, not e style', () {
    final text = formatNumberWithScientific(1234567);
    expect(text.contains('10^'), isTrue);
    expect(text.contains('e'), isFalse);
  });
}
