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
      final v = double.parse(value);
      final r = double.parse(rate); // 1 A = r B
      setState(() => result = v * r);
    } catch (_) {
      setState(() => result = 0);
    }
  }

  /// SAVE FAVORITE
  void saveFavorite() {
    if (unitA.isEmpty || unitB.isEmpty || rate.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Enter units & rate first")));
      return;
    }

    Provider.of<FavoritesProvider>(context, listen: false).addFavorite(
      FavoriteItem(
        category: "Custom",
        fromUnit: unitA,
        toUnit: unitB,
        sampleConversion: "1 $unitA = $rate $unitB",
      ),
    );

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Added to Favorites")));
  }

  /// SAVE HISTORY
  void saveHistory() {
    if (unitA.isEmpty || unitB.isEmpty || value.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Enter all details first")));
      return;
    }

    Provider.of<HistoryProvider>(context, listen: false).addHistory(
      HistoryItem(
        category: "Custom",
        fromUnit: unitA,
        toUnit: unitB,
        inputValue: value,
        result: result.toString(),
        timestamp: DateTime.now().toString(),
      ),
    );

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Saved to History")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const GradientHeader(title: "Custom Converter", showBack: true),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
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

                const SizedBox(height: 16),

                // UNIT B
                TextField(
                  decoration: const InputDecoration(
                    labelText: "Unit B",
                    hintText: "Example: Apple",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) => setState(() => unitB = v),
                ),

                const SizedBox(height: 24),

                const Text(
                  "💡 Example: If 1 Mango = 2 Apples → Enter 2 below.",
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),

                const SizedBox(height: 24),

                // RATE
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Conversion Rate (1 $unitA = ? $unitB)",
                    hintText: "If 1 A = 2 B → Enter 2",
                    border: const OutlineInputBorder(),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9\.]')),
                    DecimalTextInputFormatter(decimalRange: 6),
                  ],
                  onChanged: (v) {
                    rate = v;
                    calculate();
                  },
                ),

                const SizedBox(height: 24),

                // VALUE
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "How many $unitA?",
                    border: const OutlineInputBorder(),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9\.]')),
                    DecimalTextInputFormatter(decimalRange: 6),
                  ],
                  onChanged: (v) {
                    value = v;
                    calculate();
                  },
                ),

                const SizedBox(height: 24),

                // RESULT BOX
                ResultBox(label: "Converted Value", value: "$result $unitB"),

                const SizedBox(height: 20),

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
