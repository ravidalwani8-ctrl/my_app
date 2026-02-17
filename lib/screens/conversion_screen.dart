import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/decimal_text_input_formatter.dart';
import '../models/category.dart';
import '../models/unit.dart';
import '../providers/history_provider.dart';
import '../providers/favorites_provider.dart';
import '../models/history_item.dart';
import '../models/favorite_item.dart';
import '../widgets/gradient_header.dart';
import '../widgets/result_box.dart';
import '../utils/number_formatter.dart';

class ConversionScreen extends StatefulWidget {
  final Category category;

  const ConversionScreen({super.key, required this.category});

  @override
  State<ConversionScreen> createState() => _ConversionScreenState();
}

class _ConversionScreenState extends State<ConversionScreen> {
  late Unit fromUnit;
  late Unit toUnit;
  late Map<String, double> unitMap;

  String input = "";
  double result = 0;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    fromUnit = widget.category.units.first;
    toUnit = widget.category.units.last;
    unitMap = {for (final u in widget.category.units) u.name: u.factor};
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void convert() {
    if (input.isEmpty) {
      setState(() => result = 0);
      return;
    }

    final value = parseScientificInput(input, allowNegative: false) ?? 0;
    // Map-based conversion using unit name -> factor map
    final fromFactor = unitMap[fromUnit.name] ?? fromUnit.factor;
    final toFactor = unitMap[toUnit.name] ?? toUnit.factor;
    double baseValue = value * fromFactor;
    double finalValue = baseValue / toFactor;

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
    if (input.isEmpty) {
      _showSnack("Enter value first");
      return;
    }
    final inputValue = parseScientificInput(input, allowNegative: false);
    if (inputValue == null) {
      _showSnack("Enter a valid number");
      return;
    }

    Provider.of<FavoritesProvider>(context, listen: false).addFavorite(
      FavoriteItem(
        inputValue: inputValue,
        resultValue: result,
        category: widget.category.name,
        fromUnit: fromUnit.name,
        toUnit: toUnit.name,
        timestamp: DateTime.now(),
      ),
    );
    _showSnack("Added to Favorites");
  }

  void saveHistory() {
    if (input.isEmpty) {
      _showSnack("Enter value first");
      return;
    }
    final inputValue = parseScientificInput(input, allowNegative: false);
    if (inputValue == null) {
      _showSnack("Enter a valid number");
      return;
    }

    Provider.of<HistoryProvider>(context, listen: false).addHistory(
      HistoryItem(
        category: widget.category.name,
        fromUnit: fromUnit.name,
        toUnit: toUnit.name,
        inputValue: formatNumberWithScientific(inputValue),
        result: formatNumberWithScientific(result),
        timestamp: formatTimestampToMinute(DateTime.now()),
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

  String _categoryTip(String categoryName) {
    switch (categoryName) {
      case "Length":
        return "💡 Tip: 1 inch = 2.54 cm";
      case "Weight":
        return "💡 Tip: 1 kg = 2.20462 lb";
      case "Time":
        return "💡 Tip: 1 hour = 60 minutes";
      case "Energy":
        return "💡 Tip: 1 kWh = 3.6 × 10^6 J";
      case "Speed":
        return "💡 Tip: 1 m/s = 3.6 km/h";
      case "Pressure":
        return "💡 Tip: 1 bar = 14.5038 psi";
      case "Data":
        return "💡 Tip: 1 KB = 1024 Bytes";
      default:
        return "💡 Tip: Select units first, then enter value.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          GradientHeader(title: widget.category.name, showBack: true),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
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
                  controller: _controller,
                  inputFormatters: [
                    DecimalTextInputFormatter(
                      decimalRange: 6,
                      allowScientific: true,
                    ),
                  ],
                  autofocus: true,
                  onChanged: (v) {
                    input = v;
                    convert();
                  },
                ),

                const SizedBox(height: 12),

                // FROM UNIT
                DropdownButtonFormField<Unit>(
                  initialValue: fromUnit,
                  decoration: const InputDecoration(
                    labelText: "From Unit",
                    border: OutlineInputBorder(),
                  ),
                  items: widget.category.units.map((u) {
                    return DropdownMenuItem<Unit>(
                      value: u,
                      child: Text(u.name),
                    );
                  }).toList(),
                  onChanged: (v) {
                    fromUnit = v!;
                    convert();
                  },
                ),

                const SizedBox(height: 12),

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

                const SizedBox(height: 12),

                // TO UNIT
                DropdownButtonFormField<Unit>(
                  initialValue: toUnit,
                  decoration: const InputDecoration(
                    labelText: "To Unit",
                    border: OutlineInputBorder(),
                  ),
                  items: widget.category.units.map((u) {
                    return DropdownMenuItem<Unit>(
                      value: u,
                      child: Text(u.name),
                    );
                  }).toList(),
                  onChanged: (v) {
                    toUnit = v!;
                    convert();
                  },
                ),

                const SizedBox(height: 12),

                // RESULT BOX
                ResultBox(
                  label: "Result",
                  value: "${formatNumberWithScientific(result)} ${toUnit.name}",
                ),

                const SizedBox(height: 12),

                // TIPS
                Text(
                  _categoryTip(widget.category.name),
                  style: TextStyle(fontSize: 15, color: Colors.grey),
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
                      label: const Text("Save to History"),
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
