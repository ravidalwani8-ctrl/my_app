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
import '../utils/converters.dart';

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
  late TextEditingController _inputController;

  final List<String> units = ["Celsius", "Fahrenheit", "Kelvin"];

  final List<(String label, String from, String to, String value)>
  _presets = [
    ("Room Temp", "Celsius", "Fahrenheit", "25"),
    ("Absolute Zero", "Celsius", "Kelvin", "-273.15"),
  ];

  @override
  void initState() {
    super.initState();
    _inputController = TextEditingController();
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void convert() {
    if (input.isEmpty) {
      setState(() => result = 0);
      return;
    }

    final value = parseScientificInput(input, allowNegative: true) ?? 0;
    final celsius = Converters.toCelsius(from, value);
    result = Converters.fromCelsius(to, celsius);
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

  void _applyPreset((String label, String from, String to, String value) p) {
    setState(() {
      from = p.$2;
      to = p.$3;
      input = p.$4;
      _inputController.text = p.$4;
      _inputController.selection = TextSelection.collapsed(
        offset: _inputController.text.length,
      );
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
    if (!result.isFinite) {
      _showSnack("Cannot save: result is out of range");
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
    if (!result.isFinite) {
      _showSnack("Cannot save: result is out of range");
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

  String? get _validationError {
    if (input.isEmpty) return null;
    final parsed = parseScientificInput(input, allowNegative: true);
    if (parsed == null) {
      return "Please enter a valid temperature value.";
    }
    if (!result.isFinite) {
      return "Result is out of range. Try a smaller value.";
    }
    return null;
  }


  bool get _canSave {
    if (input.isEmpty) return false;
    if (parseScientificInput(input, allowNegative: true) == null) return false;
    if (!result.isFinite) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const GradientHeader(title: "Temperature", showBack: true),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: ListView(
                  children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _presets
                          .map(
                            (p) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ActionChip(
                                label: Text(p.$1),
                                onPressed: () => _applyPreset(p),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // LABEL
                  Text(
                    "Enter Temp. to convert",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),

                  // INPUT VALUE
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Enter value",
                      border: OutlineInputBorder(),
                    ),
                    controller: _inputController,
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

                if (_validationError != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    _validationError!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ],

                  const SizedBox(height: 16),

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

                  const SizedBox(height: 16),

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

                  const SizedBox(height: 16),

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

                  const SizedBox(height: 16),

                  // RESULT BOX (same style as other screens)
                  ResultBox(
                    label: "Converted Temperature",
                    value: "${formatNumberWithScientific(result)} $to",
                    canCopy:
                        input.isNotEmpty &&
                        parseScientificInput(input, allowNegative: true) !=
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
                        label: const Text("Save to History"),
                        onPressed: _canSave ? saveHistory : null,
                      ),
                    ],
                  ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
