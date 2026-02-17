import 'package:flutter/material.dart';
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
    if (unitA.isEmpty || unitB.isEmpty || rate.isEmpty || value.isEmpty) {
      _showSnack("Enter units, rate and value first");
      return;
    }

    final inputValue = parseScientificInput(value, allowNegative: false);
    final rateValue = parseScientificInput(rate, allowNegative: false) ?? 0;
    if (inputValue == null) {
      _showSnack("Enter a valid value");
      return;
    }
    Provider.of<FavoritesProvider>(context, listen: false).addFavorite(
      FavoriteItem(
        inputValue: inputValue,
        resultValue: inputValue * rateValue,
        rateUsed: rateValue,
        category: "Custom",
        fromUnit: unitA,
        toUnit: unitB,
        timestamp: DateTime.now(),
      ),
    );

    _showSnack("Added to Favorites");
  }

  /// SAVE HISTORY
  void saveHistory() {
    if (unitA.isEmpty || unitB.isEmpty || value.isEmpty) {
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

    Provider.of<HistoryProvider>(context, listen: false).addHistory(
      HistoryItem(
        category: "Custom",
        fromUnit: unitA,
        toUnit: unitB,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const GradientHeader(title: "Custom Converter", showBack: true),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              children: [
                // UNIT A
                TextField(
                  decoration: const InputDecoration(
                    labelText: "Unit A",
                    hintText: "Example: Mango",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) => setState(() => unitA = v),
                ),

                const SizedBox(height: 12),

                // UNIT B
                TextField(
                  decoration: const InputDecoration(
                    labelText: "Unit B",
                    hintText: "Example: Apple",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) => setState(() => unitB = v),
                ),

                const SizedBox(height: 12),

                const Text(
                  "💡 Example: If 1 Mango = 2 Apples → Enter 2 below.",
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),

                const SizedBox(height: 12),

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

                const SizedBox(height: 12),

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

                const SizedBox(height: 12),

                // RESULT BOX
                ResultBox(
                  label: "Converted Value",
                  value: "${formatNumberWithScientific(result)} $unitB",
                ),

                const SizedBox(height: 12),

                // ACTION BUTTONS
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.favorite_border),
                      label: const Text("Favorite"),
                      onPressed: saveFavorite,
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.save_alt),
                      label: const Text("Save History"),
                      onPressed: saveHistory,
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
