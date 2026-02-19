import 'dart:io';
import 'package:unit_converter/utils/number_formatter.dart';

void main() {
  const fromFactor = 1.0;
  const toFactor = 1024.0 * 1024.0 * 1024.0 * 1024.0;
  final samples = <double>[1, 10, 100, 1024, 1000000, 1e-6, 1e-9, 1e-12];

  for (final input in samples) {
    final result = (input * fromFactor) / toFactor;
    final formatted = formatNumberWithScientific(result);
    stdout.writeln('input=$input -> [$formatted] len=${formatted.length}');
  }
}
