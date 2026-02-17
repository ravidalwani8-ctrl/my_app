import 'dart:math' as math;

String _trimNumber(String value) {
  return value.replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
}

String _toBase10Scientific(double value, {int mantissaDecimals = 3}) {
  final expText = value.toStringAsExponential(mantissaDecimals);
  final parts = expText.split('e');
  final mantissa = _trimNumber(parts[0]);
  final exponent = int.parse(parts[1]);
  return '$mantissa × 10^$exponent';
}

/// Uses plain notation when it fits within [maxChars] (excluding sign),
/// otherwise falls back to base-10 scientific notation.
String formatNumberWithScientific(
  double value, {
  int maxChars = 6,
  int decimals = 6,
}) {
  if (value.isNaN || value.isInfinite) return "0";
  if (value == 0) return "0";

  final plain = _trimNumber(value.toStringAsFixed(decimals));
  final withoutSign = plain.startsWith('-') ? plain.substring(1) : plain;
  if (withoutSign.length <= maxChars) {
    return plain;
  }
  return _toBase10Scientific(value);
}

String formatTimestampToMinute(DateTime dt) {
  final local = dt.toLocal();
  final month = local.month.toString().padLeft(2, '0');
  final day = local.day.toString().padLeft(2, '0');
  final hour = local.hour.toString().padLeft(2, '0');
  final minute = local.minute.toString().padLeft(2, '0');
  return "${local.year}-$month-$day $hour:$minute";
}

double? parseScientificInput(String raw, {bool allowNegative = true}) {
  final text = raw.trim();
  if (text.isEmpty) return null;

  // Accept display-style scientific input like 1×10^3, 1x10^3, 1*10^3.
  var normalized = text
      .replaceAll('×', 'x')
      .replaceAll('*', 'x')
      .replaceAll('X', 'x');

  if (normalized.contains('x10^')) {
    final parts = normalized.split('x10^');
    if (parts.length != 2) return null;
    final mantissa = double.tryParse(parts[0]);
    final exponent = double.tryParse(parts[1]);
    if (mantissa == null || exponent == null) return null;
    final value = mantissa * math.pow(10, exponent).toDouble();
    if (!allowNegative && value < 0) return null;
    return value;
  }

  // Base-e input support:
  // 1e3   => 1 * e^3
  // 1e-2  => 1 * e^-2
  // e3    => e^3
  // e     => e
  final lower = normalized.toLowerCase();

  final coefficientExpPattern = RegExp(
    r'^([+-]?[0-9]*\.?[0-9]+)?e([+-]?[0-9]*\.?[0-9]+)$',
  );
  final coefficientOnlyPattern = RegExp(r'^([+-]?[0-9]*\.?[0-9]+)?e$');

  final expMatch = coefficientExpPattern.firstMatch(lower);
  if (expMatch != null) {
    final coefficientText = expMatch.group(1);
    final exponentText = expMatch.group(2)!;
    final coefficient = coefficientText == null || coefficientText.isEmpty
        ? 1.0
        : double.tryParse(coefficientText);
    final exponent = double.tryParse(exponentText);
    if (coefficient == null || exponent == null) return null;
    final value = coefficient * math.pow(math.e, exponent).toDouble();
    if (!allowNegative && value < 0) return null;
    return value;
  }

  final coeffOnlyMatch = coefficientOnlyPattern.firstMatch(lower);
  if (coeffOnlyMatch != null) {
    final coefficientText = coeffOnlyMatch.group(1);
    final coefficient = coefficientText == null || coefficientText.isEmpty
        ? 1.0
        : double.tryParse(coefficientText);
    if (coefficient == null) return null;
    final value = coefficient * math.e;
    if (!allowNegative && value < 0) return null;
    return value;
  }

  if (!allowNegative && normalized.startsWith('-')) return null;
  final plain = double.tryParse(normalized);
  if (plain == null) return null;
  if (!allowNegative && plain < 0) return null;
  return plain;
}
