import 'dart:io';
import 'package:my_app/utils/number_formatter.dart';

void main() {
  stdout.writeln('--- Conversion (Data: Byte -> Terabyte) ---');
  const byteToTb = 1024.0 * 1024.0 * 1024.0 * 1024.0;
  for (final input in [1.0, 10.0, 100.0, 1e-6]) {
    final result = input / byteToTb;
    stdout.writeln('input=$input -> ${formatNumberWithScientific(result)}');
  }

  stdout.writeln('\n--- Currency (amt * rate) ---');
  for (final pair in [
    (1e-6, 1e-6),
    (1e-4, 1e-3),
    (1e-2, 1e-4),
  ]) {
    final result = pair.$1 * pair.$2;
    stdout.writeln(
      'amt=${pair.$1}, rate=${pair.$2} -> ${formatNumberWithScientific(result)}',
    );
  }

  stdout.writeln('\n--- Custom (value * rate) ---');
  for (final pair in [
    (1e-6, 2e-6),
    (3e-5, 4e-4),
    (1e-2, 5e-5),
  ]) {
    final result = pair.$1 * pair.$2;
    stdout.writeln(
      'value=${pair.$1}, rate=${pair.$2} -> ${formatNumberWithScientific(result)}',
    );
  }
}
