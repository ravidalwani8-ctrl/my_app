import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/decimal_text_input_formatter.dart';
import '../widgets/gradient_header.dart';
import '../widgets/result_box.dart';
import '../providers/favorites_provider.dart';
import '../providers/history_provider.dart';
import '../models/favorite_item.dart';
import '../models/history_item.dart';
import '../utils/number_formatter.dart';

class CurrencyScreen extends StatefulWidget {
  const CurrencyScreen({super.key});

  @override
  State<CurrencyScreen> createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<CurrencyScreen> {
  final List<String> currencies = [
    "INR",
    "USD",
    "EUR",
    "GBP",
    "JPY",
    "AED",
    "AUD",
    "CAD",
    "CHF",
    "CNY",
    "HKD",
    "SGD",
    "NZD",
    "KRW",
  ];

  final List<(String label, String from, String to, String amount, String rate)>
  _presets = [
    ("1 USD -> INR (83)", "USD", "INR", "1", "83"),
    ("1 EUR -> USD (1.1)", "EUR", "USD", "1", "1.1"),
  ];

  String from = "USD";
  String to = "INR";

  String amount = "";
  String rateInput = "";
  double result = 0;

  late TextEditingController _amountController;
  late TextEditingController _rateController;
  late FocusNode _amountFocusNode;
  late FocusNode _rateFocusNode;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _rateController = TextEditingController();
    _amountFocusNode = FocusNode();
    _rateFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _rateController.dispose();
    _amountFocusNode.dispose();
    _rateFocusNode.dispose();
    super.dispose();
  }

  /// Swap currency direction
  void swapCurrencies() {
    setState(() {
      final t = from;
      from = to;
      to = t;
    });
    calculate();
  }

  void _applyPreset(
    (String label, String from, String to, String amount, String rate) p,
  ) {
    setState(() {
      from = p.$2;
      to = p.$3;
      amount = p.$4;
      rateInput = p.$5;
      _amountController.text = p.$4;
      _rateController.text = p.$5;
      _amountController.selection = TextSelection.collapsed(
        offset: _amountController.text.length,
      );
      _rateController.selection = TextSelection.collapsed(
        offset: _rateController.text.length,
      );
    });
    calculate();
  }

  /// SAVE FAVORITE
  void saveFavorite() {
    if (amount.isEmpty || rateInput.isEmpty) {
      _showSnack("Enter amount and rate first");
      return;
    }

    final amountValue = parseScientificInput(amount, allowNegative: false);
    final rate = parseScientificInput(rateInput, allowNegative: false) ?? 0;
    if (amountValue == null) {
      _showSnack("Enter a valid amount");
      return;
    }
    if (!result.isFinite) {
      _showSnack("Cannot save: result is out of range");
      return;
    }
    Provider.of<FavoritesProvider>(context, listen: false).addFavorite(
      FavoriteItem(
        inputValue: amountValue,
        resultValue: amountValue * rate,
        rateUsed: rate,
        category: "Currency",
        fromUnit: from,
        toUnit: to,
        timestamp: DateTime.now(),
      ),
    );
    _showSnack("Added to Favorites");
  }

  /// SAVE HISTORY
  void saveHistory() {
    if (amount.isEmpty || rateInput.isEmpty) {
      _showSnack("Enter amount and rate first");
      return;
    }
    final amountValue = parseScientificInput(amount, allowNegative: false);
    if (amountValue == null) {
      _showSnack("Enter a valid amount");
      return;
    }
    if (!result.isFinite) {
      _showSnack("Cannot save: result is out of range");
      return;
    }

    Provider.of<HistoryProvider>(context, listen: false).addHistory(
      HistoryItem(
        category: "Currency",
        fromUnit: from,
        toUnit: to,
        inputValue: formatNumberWithScientific(amountValue),
        result: formatNumberWithScientific(result),
        timestamp: formatTimestampToMinute(DateTime.now()),
        rateUsed: formatNumberWithScientific(
          parseScientificInput(rateInput, allowNegative: false) ?? 0,
        ),
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

  String? get _amountValidationError {
    if (amount.isEmpty) return null;
    if (parseScientificInput(amount, allowNegative: false) == null) {
      return "Please enter a valid non-negative amount.";
    }
    return null;
  }

  String? get _rateValidationError {
    if (rateInput.isEmpty) return null;
    if (parseScientificInput(rateInput, allowNegative: false) == null) {
      return "Please enter a valid non-negative rate.";
    }
    return null;
  }

  String? get _rangeValidationError {
    if (amount.isEmpty || rateInput.isEmpty) return null;
    if (parseScientificInput(amount, allowNegative: false) == null) return null;
    if (parseScientificInput(rateInput, allowNegative: false) == null) return null;
    if (!result.isFinite) {
      return "Result is out of range. Try smaller values.";
    }
    return null;
  }


  bool get _canSave {
    if (amount.isEmpty || rateInput.isEmpty) return false;
    if (parseScientificInput(amount, allowNegative: false) == null) return false;
    if (parseScientificInput(rateInput, allowNegative: false) == null) {
      return false;
    }
    if (!result.isFinite) return false;
    return true;
  }
  /// Numeric-only calculation
  void calculate() {
    if (amount.isEmpty || rateInput.isEmpty) {
      setState(() => result = 0);
      return;
    }

    try {
      final amt = parseScientificInput(amount, allowNegative: false) ?? 0;
      final rate = parseScientificInput(rateInput, allowNegative: false) ?? 0;
      setState(() => result = amt * rate);
    } catch (_) {
      setState(() => result = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const GradientHeader(title: "Currency", showBack: true),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: ListView(
                  children: [
                  if (_presets.isNotEmpty) ...[
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
                  ],
                  Text(
                    "Enter Amount to convert",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),

                  const SizedBox(height: 16),

                  // AMOUNT INPUT
                  TextField(
                    keyboardType: TextInputType.number,
                    focusNode: _amountFocusNode,
                    decoration: const InputDecoration(
                      labelText: "Enter Amount",
                      border: OutlineInputBorder(),
                    ),
                    controller: _amountController,
                    inputFormatters: [
                      DecimalTextInputFormatter(
                        decimalRange: 6,
                        allowScientific: true,
                      ),
                    ],
                    onChanged: (v) {
                      amount = v;
                      calculate();
                    },
                  ),

                  if (_amountValidationError != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      _amountValidationError!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ],

                  const SizedBox(height: 16),

                  // FROM CURRENCY
                  DropdownButtonFormField<String>(
                    initialValue: from,
                    decoration: const InputDecoration(
                      labelText: "From Currency",
                      border: OutlineInputBorder(),
                    ),
                    items: currencies
                        .map(
                          (c) => DropdownMenuItem<String>(
                            value: c,
                            child: Text(c),
                          ),
                        )
                        .toList(),
                    onChanged: (v) {
                      from = v!;
                      calculate();
                    },
                  ),

                  const SizedBox(height: 16),

                  // SWAP BUTTON
                  Center(
                    child: IconButton(
                      icon: const Icon(
                        Icons.swap_vert,
                        size: 40,
                        color: Colors.purple,
                      ),
                      onPressed: swapCurrencies,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // TO CURRENCY
                  DropdownButtonFormField<String>(
                    initialValue: to,
                    decoration: const InputDecoration(
                      labelText: "To Currency",
                      border: OutlineInputBorder(),
                    ),
                    items: currencies
                        .map(
                          (c) => DropdownMenuItem<String>(
                            value: c,
                            child: Text(c),
                          ),
                        )
                        .toList(),
                    onChanged: (v) {
                      to = v!;
                      calculate();
                    },
                  ),

                  const SizedBox(height: 16),
                  const Text(
                    "💡 Example: If 1 USD = 83 INR → Enter 83 only.",
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  // RATE INPUT
                  TextField(
                    keyboardType: TextInputType.number,
                    focusNode: _rateFocusNode,
                    decoration: const InputDecoration(
                      labelText: "Conversion Rate (Enter numeric only)",
                      hintText: "Example: 83",
                      border: OutlineInputBorder(),
                    ),
                    controller: _rateController,
                    inputFormatters: [
                      DecimalTextInputFormatter(
                        decimalRange: 6,
                        allowScientific: true,
                      ),
                    ],
                    onChanged: (v) {
                      rateInput = v;
                      calculate();
                    },
                  ),

                  if (_rateValidationError != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      _rateValidationError!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ],
                  if (_rangeValidationError != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      _rangeValidationError!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ],

                  const SizedBox(height: 16),

                  // RESULT BOX
                  ResultBox(
                    label: "Converted Amount",
                    value: "${formatNumberWithScientific(result)} $to",
                    canCopy:
                        amount.isNotEmpty &&
                        rateInput.isNotEmpty &&
                        parseScientificInput(amount, allowNegative: false) !=
                            null &&
                        parseScientificInput(
                              rateInput,
                              allowNegative: false,
                            ) !=
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
