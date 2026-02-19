import 'dart:math' as math;

String _trimNumber(String value) {
  final trimmed = value
      .replaceAll(RegExp(r'0+$'), '')
      .replaceAll(RegExp(r'\.$'), '');
  if (trimmed.isEmpty || trimmed == '-') return '0';
  return trimmed;
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
  int maxChars = 10,
  int decimals = 10,
}) {
  if (value.isNaN || value.isInfinite) return "Error: out of range";
  if (value == 0) return "0";

  // Try the most precise plain representation that still fits.
  for (int currentDecimals = decimals; currentDecimals >= 0; currentDecimals--) {
    final plain = _trimNumber(value.toStringAsFixed(currentDecimals));

    // toStringAsFixed can switch to exponential style for very large values.
    if (plain.contains('e') || plain.contains('E')) {
      continue;
    }

    final normalizedPlain = plain == '-0' ? '0' : plain;

    // Do not collapse non-zero values to 0; use scientific in that case.
    if (normalizedPlain == '0') {
      continue;
    }

    final withoutSign = normalizedPlain.startsWith('-')
        ? normalizedPlain.substring(1)
        : normalizedPlain;
    if (withoutSign.length <= maxChars) {
      return normalizedPlain;
    }
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
    if (mantissa == 0) return 0;
    final log10Abs = math.log(mantissa.abs()) / math.ln10 + exponent;
    if (log10Abs < -323 || log10Abs > 308) return double.nan;
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
    if (coefficient == 0) return 0;
    final log10Abs =
        math.log(coefficient.abs()) / math.ln10 + exponent * math.log(math.e) / math.ln10;
    if (log10Abs < -323 || log10Abs > 308) return double.nan;
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
    if (coefficient == 0) return 0;
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
