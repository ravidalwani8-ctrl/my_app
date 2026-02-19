import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/decimal_text_input_formatter.dart';
import 'package:provider/provider.dart';
import '../widgets/gradient_header.dart';
import '../widgets/result_box.dart';
import '../providers/favorites_provider.dart';
import '../providers/history_provider.dart';
import '../models/favorite_item.dart';
import '../models/history_item.dart';
import '../utils/number_formatter.dart';

class CustomConversionScreen extends StatefulWidget {
  const CustomConversionScreen({super.key});

  @override
  State<CustomConversionScreen> createState() => _CustomConversionScreenState();
}

class _CustomConversionScreenState extends State<CustomConversionScreen> {
  String unitA = "";
  String unitB = "";
  String value = "";
  String rate = "";
  double result = 0;

  void calculate() {
    if (value.isEmpty || rate.isEmpty) {
      setState(() => result = 0);
      return;
    }

    try {
      final v = parseScientificInput(value, allowNegative: false) ?? 0;
      final r =
          parseScientificInput(rate, allowNegative: false) ?? 0; // 1 A = r B
      setState(() => result = v * r);
    } catch (_) {
      setState(() => result = 0);
    }
  }

  /// SAVE FAVORITE
  void saveFavorite() {
    final normalizedUnitA = unitA.trim();
    final normalizedUnitB = unitB.trim();
    if (normalizedUnitA.isEmpty ||
        normalizedUnitB.isEmpty ||
        rate.isEmpty ||
        value.isEmpty) {
      _showSnack("Enter units, rate and value first");
      return;
    }

    final inputValue = parseScientificInput(value, allowNegative: false);
    final rateValue = parseScientificInput(rate, allowNegative: false) ?? 0;
    if (inputValue == null) {
      _showSnack("Enter a valid value");
      return;
    }
    if (!result.isFinite) {
      _showSnack("Cannot save: result is out of range");
      return;
    }
    Provider.of<FavoritesProvider>(context, listen: false).addFavorite(
      FavoriteItem(
        inputValue: inputValue,
        resultValue: inputValue * rateValue,
        rateUsed: rateValue,
        category: "Custom",
        fromUnit: normalizedUnitA,
        toUnit: normalizedUnitB,
        timestamp: DateTime.now(),
      ),
    );

    _showSnack("Added to Favorites");
  }

  /// SAVE HISTORY
  void saveHistory() {
    final normalizedUnitA = unitA.trim();
    final normalizedUnitB = unitB.trim();
    if (normalizedUnitA.isEmpty || normalizedUnitB.isEmpty || value.isEmpty) {
      _showSnack("Enter all details first");
      return;
    }
    final inputValue = parseScientificInput(value, allowNegative: false);
    final rateValue = parseScientificInput(rate, allowNegative: false);
    if (inputValue == null) {
      _showSnack("Enter a valid value");
      return;
    }
    if (rateValue == null) {
      _showSnack("Enter a valid rate");
      return;
    }
    if (!result.isFinite) {
      _showSnack("Cannot save: result is out of range");
      return;
    }

    Provider.of<HistoryProvider>(context, listen: false).addHistory(
      HistoryItem(
        category: "Custom",
        fromUnit: normalizedUnitA,
        toUnit: normalizedUnitB,
        inputValue: formatNumberWithScientific(inputValue),
        result: formatNumberWithScientific(result),
        timestamp: formatTimestampToMinute(DateTime.now()),
        rateUsed: formatNumberWithScientific(rateValue),
      ),
    );

    _showSnack("Saved to History");
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(milliseconds: 900),
      ),
    );
  }

  String? get _validationError {
    if (value.isEmpty && rate.isEmpty) return null;
    if (value.isNotEmpty &&
        parseScientificInput(value, allowNegative: false) == null) {
      return "Please enter a valid non-negative value.";
    }
    if (rate.isNotEmpty &&
        parseScientificInput(rate, allowNegative: false) == null) {
      return "Please enter a valid non-negative conversion rate.";
    }
    if (value.isNotEmpty && rate.isNotEmpty && !result.isFinite) {
      return "Result is out of range. Try smaller values.";
    }
    return null;
  }


  bool get _canSave {
    if (unitA.trim().isEmpty || unitB.trim().isEmpty) return false;
    if (value.isEmpty || rate.isEmpty) return false;
    if (parseScientificInput(value, allowNegative: false) == null) return false;
    if (parseScientificInput(rate, allowNegative: false) == null) return false;
    if (!result.isFinite) return false;
    return true;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const GradientHeader(title: "Custom Converter", showBack: true),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
              children: [
                Text(
                  "Define unit name",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),

                // UNIT A
                TextField(
                  decoration: const InputDecoration(
                    labelText: "Unit A",
                    hintText: "Example: kilometer",
                    border: OutlineInputBorder(),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z ]")),
                    LengthLimitingTextInputFormatter(12),
                  ],
                  onChanged: (v) => setState(() => unitA = v),
                ),

                const SizedBox(height: 16),

                // UNIT B
                TextField(
                  decoration: const InputDecoration(
                    labelText: "Unit B",
                    hintText: "Example: meter",
                    border: OutlineInputBorder(),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z ]")),
                    LengthLimitingTextInputFormatter(12),
                  ],
                  onChanged: (v) => setState(() => unitB = v),
                ),

                const SizedBox(height: 16),

                const Text(
                  "💡 Example: If 1 kilometer = 1000 meters → Enter 1000 below.",
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),

                const SizedBox(height: 16),

                // RATE
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Conversion Rate (1 $unitA = ? $unitB)",
                    hintText: "If 1 A = 2 B → Enter 2",
                    border: const OutlineInputBorder(),
                  ),
                  inputFormatters: [
                    DecimalTextInputFormatter(
                      decimalRange: 6,
                      allowScientific: true,
                    ),
                  ],
                  onChanged: (v) {
                    rate = v;
                    calculate();
                  },
                ),

                const SizedBox(height: 16),

                Text(
                  "Enter value to convert",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),

                // VALUE
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "How many $unitA?",
                    border: const OutlineInputBorder(),
                  ),
                  inputFormatters: [
                    DecimalTextInputFormatter(
                      decimalRange: 6,
                      allowScientific: true,
                    ),
                  ],
                  onChanged: (v) {
                    value = v;
                    calculate();
                  },
                ),

                if (_validationError != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    _validationError!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ],

                const SizedBox(height: 16),

                // RESULT BOX
                ResultBox(
                  label: "Converted Value",
                  value: "${formatNumberWithScientific(result)} $unitB",
                  canCopy:
                      value.isNotEmpty &&
                      rate.isNotEmpty &&
                      parseScientificInput(value, allowNegative: false) !=
                          null &&
                      parseScientificInput(rate, allowNegative: false) !=
                          null &&
                      result.isFinite,
                ),

                const SizedBox(height: 16),

                // ACTION BUTTONS
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.favorite_border),
                      label: const Text("Favorite"),
                      onPressed: _canSave ? saveFavorite : null,
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.save_alt),
                      label: const Text("Save History"),
                      onPressed: _canSave ? saveHistory : null,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
