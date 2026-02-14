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
    double baseValue = value * fromUnit.factor;
    double finalValue = baseValue / toUnit.factor;

    setState(() {
      result = finalValue;
    });
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
          GradientHeader(title: widget.category.name, showBack: true),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // LABEL
                Text(
                  "Enter value to convert",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),

                // VALUE INPUT
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Value",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) {
                    input = v;
                    convert();
                  },
                ),

                const SizedBox(height: 20),

                // FROM UNIT
                DropdownButtonFormField<Unit>(
                  initialValue: fromUnit,
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

                // SWITCH BUTTON
                Center(
                  child: IconButton(
                    icon: const Icon(
                      Icons.swap_vert,
                      size: 40,
                      color: Colors.purple,
                    ),
                    onPressed: swapUnits,
                  ),
                ),

                const SizedBox(height: 10),

                // TO UNIT
                DropdownButtonFormField<Unit>(
                  initialValue: toUnit,
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

                const SizedBox(height: 25),

                // RESULT BOX
                ResultBox(label: "Result", value: "$result ${toUnit.name}"),

                const SizedBox(height: 20),

                // TIPS
                const Text(
                  "💡 Tip: Learn patterns — e.g., 1 km = 1000 m, 1 kg = 1000 g, 1 inch = 2.54 cm.",
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),

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
