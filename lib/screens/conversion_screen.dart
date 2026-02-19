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
import '../utils/converters.dart';

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
    final finalValue = Converters.convertByFactors(
      value,
      fromFactor,
      toFactor,
    );

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
    if (!result.isFinite) {
      _showSnack("Cannot save: result is out of range");
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
    if (!result.isFinite) {
      _showSnack("Cannot save: result is out of range");
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

  String? get _validationError {
    if (input.isEmpty) return null;
    final parsed = parseScientificInput(input, allowNegative: false);
    if (parsed == null) {
      return "Please enter a valid non-negative value.";
    }
    if (!result.isFinite) {
      return "Result is out of range. Try a smaller value.";
    }
    return null;
  }


  bool get _canSave {
    if (input.isEmpty) return false;
    if (parseScientificInput(input, allowNegative: false) == null) return false;
    if (!result.isFinite) return false;
    return true;
  }


  List<(String label, String from, String to, String value)> _presetsForCategory(
    String category,
  ) {
    switch (category) {
      case "Length":
        return [
          ("1 m -> cm", "Meter", "Centimeter", "1"),
          ("1 mile -> km", "Mile", "Kilometer", "1"),
          ("12 in -> ft", "Inch", "Foot", "12"),
        ];
      case "Weight":
        return [
          ("1 kg -> lb", "Kilogram", "Pound", "1"),
          ("1000 g -> kg", "Gram", "Kilogram", "1000"),
          ("16 oz -> lb", "Ounce", "Pound", "16"),
        ];
      case "Time":
        return [
          ("1 hr -> min", "Hour", "Minute", "1"),
          ("1 day -> hr", "Day", "Hour", "1"),
          ("1 week -> day", "Week", "Day", "1"),
        ];
      case "Energy":
        return [
          ("1 kWh -> J", "Kilowatt-hour", "Joule", "1"),
          ("1 kcal -> J", "Kilocalorie", "Joule", "1"),
          ("1000 J -> kJ", "Joule", "Kilojoule", "1000"),
        ];
      case "Speed":
        return [
          ("1 m/s -> km/h", "m/s", "km/h", "1"),
          ("60 mph -> km/h", "mph", "km/h", "60"),
          ("10 knot -> m/s", "knot", "m/s", "10"),
        ];
      case "Pressure":
        return [
          ("1 atm -> kPa", "atm", "kPa", "1"),
          ("1 bar -> psi", "bar", "psi", "1"),
          ("101325 Pa -> atm", "Pascal", "atm", "101325"),
        ];
      case "Data":
        return [
          ("1024 B -> KB", "Byte", "Kilobyte", "1024"),
          ("1 GB -> MB", "Gigabyte", "Megabyte", "1"),
          ("1 TB -> GB", "Terabyte", "Gigabyte", "1"),
        ];
      case "Area":
        return [
          ("1 m² -> cm²", "Square meter", "Square centimeter", "1"),
          ("1 acre -> m²", "Acre", "Square meter", "1"),
          ("1 km² -> m²", "Square kilometer", "Square meter", "1"),
        ];
      case "Power":
        return [
          ("1 kW -> W", "Kilowatt", "Watt", "1"),
          ("1 hp -> W", "Horsepower", "Watt", "1"),
          ("1 MW -> kW", "Megawatt", "Kilowatt", "1"),
        ];
      case "Frequency":
        return [
          ("1 GHz -> MHz", "Gigahertz", "Megahertz", "1"),
          ("60 RPM -> Hz", "RPM", "Hertz", "60"),
          ("1000 Hz -> kHz", "Hertz", "Kilohertz", "1000"),
        ];
      default:
        return [];
    }
  }

  void _applyPreset((String label, String from, String to, String value) p) {
    Unit findUnit(String name, Unit fallback) {
      for (final u in widget.category.units) {
        if (u.name == name) return u;
      }
      return fallback;
    }

    setState(() {
      fromUnit = findUnit(p.$2, fromUnit);
      toUnit = findUnit(p.$3, toUnit);
      input = p.$4;
      _controller.text = p.$4;
      _controller.selection = TextSelection.collapsed(
        offset: _controller.text.length,
      );
    });
    convert();
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
      case "Area":
        return "💡 Tip: 1 m² = 10,000 cm²";
      case "Power":
        return "💡 Tip: 1 kW = 1000 W";
      case "Frequency":
        return "💡 Tip: 1 Hz = 1 cycle/second";
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
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
              children: [
                if (_presetsForCategory(widget.category.name).isNotEmpty) ...[
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _presetsForCategory(widget.category.name)
                        .map(
                          (p) => ActionChip(
                            label: Text(p.$1),
                            onPressed: () => _applyPreset(p),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                ],

                // LABEL
                Text(
                  "Enter value to convert",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),

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

                if (_validationError != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    _validationError!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ],

                const SizedBox(height: 16),

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

                const SizedBox(height: 16),

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

                const SizedBox(height: 16),

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

                const SizedBox(height: 16),

                // RESULT BOX
                ResultBox(
                  label: "Result",
                  value: "${formatNumberWithScientific(result)} ${toUnit.name}",
                  canCopy:
                      input.isNotEmpty &&
                      parseScientificInput(input, allowNegative: false) !=
                          null &&
                      result.isFinite,
                ),

                const SizedBox(height: 16),

                // TIPS
                Text(
                  _categoryTip(widget.category.name),
                  style: TextStyle(fontSize: 15, color: Colors.grey),
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
        ],
      ),
    );
  }
}
