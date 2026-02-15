import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../widgets/gradient_header.dart';
import '../widgets/result_box.dart';
import '../utils/decimal_text_input_formatter.dart';
import '../providers/favorites_provider.dart';
import '../providers/history_provider.dart';
import '../models/favorite_item.dart';
import '../models/history_item.dart';

class TemperatureScreen extends StatefulWidget {
  const TemperatureScreen({super.key});

  @override
  State<TemperatureScreen> createState() => _TemperatureScreenState();
}

class _TemperatureScreenState extends State<TemperatureScreen> {
  String from = "Celsius";
  String to = "Fahrenheit";
  String input = "";
  double result = 0;

  final List<String> units = ["Celsius", "Fahrenheit", "Kelvin"];

  final Map<String, double Function(double)> _toCelsius = {
    'Celsius': (v) => v,
    'Fahrenheit': (v) => (v - 32) * 5 / 9,
    'Kelvin': (v) => v - 273.15,
  };

  final Map<String, double Function(double)> _fromCelsius = {
    'Celsius': (v) => v,
    'Fahrenheit': (v) => (v * 9 / 5) + 32,
    'Kelvin': (v) => v + 273.15,
  };

  void convert() {
    if (input.isEmpty) {
      setState(() => result = 0);
      return;
    }

    double value = double.tryParse(input) ?? 0;
    final toC = _toCelsius[from] ?? (v) => v;
    final fromC = _fromCelsius[to] ?? (v) => v;
    final celsius = toC(value);
    result = fromC(celsius);
    setState(() {});
  }

  /// Swap temperature units (like currency & normal converter screens)
  void swapUnits() {
    setState(() {
      final temp = from;
      from = to;
      to = temp;
    });
    convert();
  }

  /// SAVE FAVORITE
  void saveFavorite() {
    Provider.of<FavoritesProvider>(context, listen: false).addFavorite(
      FavoriteItem(
        category: "Temperature",
        fromUnit: from,
        toUnit: to,
        sampleConversion: "1 $from = ${result.toStringAsFixed(2)} $to",
      ),
    );

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Added to Favorites")));
  }

  /// SAVE HISTORY
  void saveHistory() {
    if (input.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Enter value first")));
      return;
    }

    Provider.of<HistoryProvider>(context, listen: false).addHistory(
      HistoryItem(
        category: "Temperature",
        fromUnit: from,
        toUnit: to,
        inputValue: input,
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
          const GradientHeader(title: "Temperature", showBack: true),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: ListView(
                children: [
                  // LABEL
                  Text(
                    "Enter Temp. to convert",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),

                  // INPUT VALUE
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Enter value",
                      border: OutlineInputBorder(),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9\.]')),
                      DecimalTextInputFormatter(decimalRange: 6),
                    ],
                    onChanged: (v) {
                      input = v;
                      convert();
                    },
                  ),

                  const SizedBox(height: 12),

                  // FROM UNIT
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: "From",
                      border: OutlineInputBorder(),
                    ),
                    initialValue: from,
                    items: units
                        .map(
                          (u) => DropdownMenuItem<String>(
                            value: u,
                            child: Text(u),
                          ),
                        )
                        .toList(),
                    onChanged: (v) {
                      from = v!;
                      convert();
                    },
                  ),

                  const SizedBox(height: 10),

                  // SWAP BUTTON (added)
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
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: "To",
                      border: OutlineInputBorder(),
                    ),
                    initialValue: to,
                    items: units
                        .map(
                          (u) => DropdownMenuItem<String>(
                            value: u,
                            child: Text(u),
                          ),
                        )
                        .toList(),
                    onChanged: (v) {
                      to = v!;
                      convert();
                    },
                  ),

                  const SizedBox(height: 20),

                  // RESULT BOX (same style as other screens)
                  ResultBox(
                    label: "Converted Temperature",
                    value: "$result $to",
                  ),

                  const SizedBox(height: 25),
                  const Text(
                    "💡 Tip: formula Fahrenheit = (celsius * 9/5) + 32",
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                  const SizedBox(height: 15),
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
          ),
        ],
      ),
    );
  }
}
