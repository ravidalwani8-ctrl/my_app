import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/gradient_header.dart';
import '../widgets/result_box.dart';
import '../utils/decimal_text_input_formatter.dart';
import '../providers/favorites_provider.dart';
import '../providers/history_provider.dart';
import '../models/favorite_item.dart';
import '../models/history_item.dart';
import '../utils/number_formatter.dart';

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

    final value = parseScientificInput(input, allowNegative: true) ?? 0;
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
    if (input.isEmpty) {
      _showSnack("Enter value first");
      return;
    }
    final inputValue = parseScientificInput(input, allowNegative: true);
    if (inputValue == null) {
      _showSnack("Enter a valid number");
      return;
    }

    // Calculate proper conversion for 1 unit
    Provider.of<FavoritesProvider>(context, listen: false).addFavorite(
      FavoriteItem(
        inputValue: inputValue,
        resultValue: result,
        category: "Temperature",
        fromUnit: from,
        toUnit: to,
        timestamp: DateTime.now(),
      ),
    );
    _showSnack("Added to Favorites");
  }

  /// SAVE HISTORY
  void saveHistory() {
    if (input.isEmpty) {
      _showSnack("Enter value first");
      return;
    }
    final inputValue = parseScientificInput(input, allowNegative: true);
    if (inputValue == null) {
      _showSnack("Enter a valid number");
      return;
    }

    Provider.of<HistoryProvider>(context, listen: false).addHistory(
      HistoryItem(
        category: "Temperature",
        fromUnit: from,
        toUnit: to,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const GradientHeader(title: "Temperature", showBack: true),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
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
                      DecimalTextInputFormatter(
                        decimalRange: 6,
                        allowNegative: true,
                        allowScientific: true,
                      ),
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

                  const SizedBox(height: 12),

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

                  const SizedBox(height: 12),

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

                  const SizedBox(height: 12),

                  // RESULT BOX (same style as other screens)
                  ResultBox(
                    label: "Converted Temperature",
                    value: "${formatNumberWithScientific(result)} $to",
                  ),

                  const SizedBox(height: 12),
                  const Text(
                    "💡 Tip: formula Fahrenheit = (celsius * 9/5) + 32",
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
          ),
        ],
      ),
    );
  }
}
