import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/category.dart';
import '../models/unit.dart';
import '../providers/history_provider.dart';
import '../providers/favorites_provider.dart';
import '../models/history_item.dart';
import '../models/favorite_item.dart';
import '../widgets/gradient_header.dart';
import '../widgets/result_box.dart';

class ConversionScreen extends StatefulWidget {
  final Category category;

  const ConversionScreen({super.key, required this.category});

  @override
  State<ConversionScreen> createState() => _ConversionScreenState();
}

class _ConversionScreenState extends State<ConversionScreen> {
  late Unit fromUnit;
  late Unit toUnit;
  String input = "";
  double result = 0;

  String _formatDouble(double v) {
    if (v == v.roundToDouble()) return v.toInt().toString();
    return v.toStringAsPrecision(6);
  }

  String getDynamicHint() {
    // Prefer explicit per-unit hints when present
    if (fromUnit.hint.isNotEmpty) return fromUnit.hint;
    if (toUnit.hint.isNotEmpty) return toUnit.hint;

    final cat = widget.category.name.toLowerCase();
    // Category-specific hints
    if (cat.contains('temperature')) {
      return 'Celsius ↔ Fahrenheit:\nF = C × 9/5 + 32\nC = (F − 32) × 5/9';
    }

    if (cat.contains('currency')) {
      return 'Currency rates change frequently — enable auto-updates for live rates.';
    }

    // Generic conversion formula using unit factors
    final ratio = fromUnit.factor / toUnit.factor;
    final example =
        '1 ${fromUnit.name} = ${_formatDouble(ratio)} ${toUnit.name}';
    final formula =
        'To convert: value_in_${toUnit.name} = value_in_${fromUnit.name} × ${_formatDouble(ratio)}';
    return '$example\n$formula';
  }

  @override
  void initState() {
    super.initState();
    fromUnit = widget.category.units.first;
    toUnit = widget.category.units.last;
  }

  void convert() {
    if (input.isEmpty) {
      setState(() => result = 0);
      return;
    }

    double value = double.tryParse(input) ?? 0;
    double base = value * fromUnit.factor;
    setState(() => result = base / toUnit.factor);
  }

  void swapUnits() {
    setState(() {
      Unit temp = fromUnit;
      fromUnit = toUnit;
      toUnit = temp;
    });
    convert();
  }

  void saveFavorite() {
    Provider.of<FavoritesProvider>(context, listen: false).addFavorite(
      FavoriteItem(
        category: widget.category.name,
        fromUnit: fromUnit.name,
        toUnit: toUnit.name,
        sampleConversion:
            "1 ${fromUnit.name} = ${fromUnit.factor / toUnit.factor} ${toUnit.name}",
      ),
    );
  }

  void saveHistory() {
    Provider.of<HistoryProvider>(context, listen: false).addHistory(
      HistoryItem(
        category: widget.category.name,
        fromUnit: fromUnit.name,
        toUnit: toUnit.name,
        inputValue: input,
        result: result.toString(),
        timestamp: DateTime.now().toString(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          GradientHeader(title: widget.category.name),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Input
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Enter value",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) {
                    input = v;
                    convert();
                  },
                ),
                const SizedBox(height: 16),

                // From Unit
                DropdownButtonFormField<Unit>(
                  value: fromUnit,
                  decoration: const InputDecoration(
                    labelText: "From Unit",
                    border: OutlineInputBorder(),
                  ),
                  items: widget.category.units.map((u) {
                    return DropdownMenuItem(value: u, child: Text(u.name));
                  }).toList(),
                  onChanged: (v) {
                    fromUnit = v!;
                    convert();
                  },
                ),

                const SizedBox(height: 10),

                // Switch Button
                Center(
                  child: IconButton(
                    icon: const Icon(
                      Icons.swap_vert,
                      size: 36,
                      color: Colors.purple,
                    ),
                    onPressed: swapUnits,
                  ),
                ),

                const SizedBox(height: 10),

                // To Unit
                DropdownButtonFormField<Unit>(
                  value: toUnit,
                  decoration: const InputDecoration(
                    labelText: "To Unit",
                    border: OutlineInputBorder(),
                  ),
                  items: widget.category.units.map((u) {
                    return DropdownMenuItem(value: u, child: Text(u.name));
                  }).toList(),
                  onChanged: (v) {
                    toUnit = v!;
                    convert();
                  },
                ),

                // Result
                ResultBox(label: "Result", value: "$result ${toUnit.name}"),

                const SizedBox(height: 20),

                // Hint / Formula Card
                Card(
                  color: Colors.purple.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Hint',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          getDynamicHint(),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.favorite),
                      label: const Text("Favorite"),
                      onPressed: saveFavorite,
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.history),
                      label: const Text("Save"),
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
