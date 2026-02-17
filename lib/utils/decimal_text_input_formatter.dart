import 'package:flutter/services.dart';

class DecimalTextInputFormatter extends TextInputFormatter {
  final int decimalRange;
  final bool allowNegative;
  final bool allowScientific;

  DecimalTextInputFormatter({
    this.decimalRange = 6,
    this.allowNegative = false,
    this.allowScientific = false,
  }) : assert(decimalRange >= 0);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text;
    final isDeleting = text.length < oldValue.text.length;

    // Allow empty
    if (text.isEmpty) return newValue;

    // Allow typing a leading minus before number
    if (allowNegative && text == '-') return newValue;

    // If user types leading dot, convert to 0.
    if (text == '.') {
      return TextEditingValue(
        text: '0.',
        selection: TextSelection.collapsed(offset: 2),
      );
    }

    // Normalize "-." to "-0." for easier further typing.
    if (allowNegative && text == '-.') {
      return TextEditingValue(
        text: '-0.',
        selection: TextSelection.collapsed(offset: 3),
      );
    }

    // While deleting, allow intermediate states so users can backspace
    // through the scientific marker naturally.
    if (allowScientific && isDeleting) {
      final markerStart = oldValue.text.indexOf('×10^');
      if (markerStart != -1 && oldValue.selection.isCollapsed) {
        final deletedIndex = oldValue.selection.baseOffset - 1;
        final markerEnd = markerStart + 3; // last char index of "×10^"
        if (deletedIndex >= markerStart && deletedIndex <= markerEnd) {
          final collapsed = oldValue.text.replaceFirst('×10^', '');
          return TextEditingValue(
            text: collapsed,
            selection: TextSelection.collapsed(offset: markerStart),
          );
        }
      }

      // If backspace produced any partial marker state, collapse the whole
      // marker instead of leaving fragments like ×10, ×1, or ×.
      if (markerStart != -1 &&
          !text.contains('×10^') &&
          (text.contains('×10') ||
              text.contains('×1') ||
              text.contains('×') ||
              text.contains('10^'))) {
        final collapsed = oldValue.text.replaceFirst('×10^', '');
        return TextEditingValue(
          text: collapsed,
          selection: TextSelection.collapsed(offset: markerStart),
        );
      }

      final partialScientific = RegExp(
        r'^-?[0-9]*\.?[0-9]*(×10\^?)?[+-]?[0-9]*$',
      );
      if (partialScientific.hasMatch(text)) {
        return newValue;
      }
    }

    // Expand * / x / X into display-style scientific marker ×10^.
    final markerMatch = RegExp(r'[xX*]').firstMatch(text);
    if (allowScientific && markerMatch != null) {
      // Allow only one scientific marker.
      if (oldValue.text.contains('×10^') || text.contains('×10^')) {
        return oldValue;
      }
      final idx = markerMatch.start;
      final nextText =
          '${text.substring(0, idx)}×10^${text.substring(idx + 1)}';
      return TextEditingValue(
        text: nextText,
        selection: TextSelection.collapsed(offset: idx + 4),
      );
    }

    // Scientific notation support, e.g. 1e3, 2.5E-4
    if (allowScientific && text.contains(RegExp(r'[eE]'))) {
      final parts = text.split(RegExp(r'[eE]'));
      if (parts.length > 2) return oldValue;

      final mantissa = parts[0];
      final exponent = parts.length == 2 ? parts[1] : '';
      final mantissaRegex = allowNegative
          ? RegExp(r'^-?[0-9]*\.?[0-9]*$')
          : RegExp(r'^[0-9]*\.?[0-9]*$');
      if (!mantissaRegex.hasMatch(mantissa)) return oldValue;

      // Mantissa must contain at least one digit before exponent marker.
      if (!RegExp(r'[0-9]').hasMatch(mantissa)) return oldValue;

      // Exponent can be empty while typing, otherwise only signed digits.
      if (!RegExp(r'^[+-]?[0-9]*$').hasMatch(exponent)) return oldValue;

      if (mantissa.contains('.')) {
        final decimalPart = mantissa.split('.')[1];
        if (decimalPart.length > decimalRange) return oldValue;
      }
      return newValue;
    }

    // Display-style notation: mantissa×10^exponent
    if (allowScientific && text.contains('×10^')) {
      final parts = text.split('×10^');
      if (parts.length != 2) return oldValue;
      final mantissa = parts[0];
      final exponent = parts[1];
      final mantissaRegex = allowNegative
          ? RegExp(r'^-?[0-9]*\.?[0-9]*$')
          : RegExp(r'^[0-9]*\.?[0-9]*$');
      if (!mantissaRegex.hasMatch(mantissa)) return oldValue;
      if (!RegExp(r'[0-9]').hasMatch(mantissa)) return oldValue;
      if (!RegExp(r'^[+-]?[0-9]*$').hasMatch(exponent)) return oldValue;
      if (mantissa.contains('.')) {
        final decimalPart = mantissa.split('.')[1];
        if (decimalPart.length > decimalRange) return oldValue;
      }
      return newValue;
    }

    // Only allow digits and at most one decimal point in non-scientific mode.
    final normalRegex = allowNegative
        ? RegExp(r'^-?[0-9]*\.?[0-9]*$')
        : RegExp(r'^[0-9]*\.?[0-9]*$');
    if (!normalRegex.hasMatch(text)) {
      return oldValue;
    }

    // Prevent multiple decimal points
    if (text.indexOf('.') != text.lastIndexOf('.')) return oldValue;

    // Enforce decimal range
    if (text.contains('.')) {
      final parts = text.split('.');
      if (parts.length > 1 && parts[1].length > decimalRange) {
        return oldValue;
      }
    }

    return newValue;
  }
}
