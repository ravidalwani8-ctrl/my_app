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

  test('flags extremely small scientific inputs as out of range', () {
    final value1 = parseScientificInput('1×10^-333');
    final value2 = parseScientificInput('1e-1000');
    expect(value1, isNotNull);
    expect(value1!.isNaN, isTrue);
    expect(value2, isNotNull);
    expect(value2!.isNaN, isTrue);
  });

  test('uses plain formatting when value fits in 10 characters', () {
    expect(formatNumberWithScientific(1234567890), '1234567890');
    expect(formatNumberWithScientific(12345.6789), '12345.6789');
  });

  test('uses scientific formatting only when plain value cannot fit in 10', () {
    final text = formatNumberWithScientific(12345678901);
    expect(text.contains('10^'), isTrue);
    expect(text.contains('e'), isFalse);
  });

  test('shows error when value is out of range', () {
    expect(formatNumberWithScientific(double.infinity), 'Error: out of range');
    expect(formatNumberWithScientific(double.nan), 'Error: out of range');
  });

  test('formats tiny non-zero values as scientific, not empty', () {
    final text = formatNumberWithScientific(9.094947017729282e-13);
    expect(text.isNotEmpty, isTrue);
    expect(text.contains('10^'), isTrue);
  });
}
