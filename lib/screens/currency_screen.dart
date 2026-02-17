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
  final List<String> currencies = ["INR", "USD", "EUR", "GBP", "JPY", "AED"];

  String from = "USD";
  String to = "INR";

  String amount = "";
  String rateInput = "";
  double result = 0;

  /// Swap currency direction
  void swapCurrencies() {
    setState(() {
      final t = from;
      from = to;
      to = t;
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
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: ListView(
                children: [
                  Text(
                    "Enter Amount to convert",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),

                  const SizedBox(height: 12),

                  // AMOUNT INPUT
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Enter Amount",
                      border: OutlineInputBorder(),
                    ),
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

                  const SizedBox(height: 12),

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

                  const SizedBox(height: 12),

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

                  const SizedBox(height: 12),

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

                  const SizedBox(height: 12),
                  const Text(
                    "💡 Example: If 1 USD = 83 INR → Enter 83 only.",
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  // RATE INPUT
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Conversion Rate (Enter numeric only)",
                      hintText: "Example: 83",
                      border: OutlineInputBorder(),
                    ),
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

                  const SizedBox(height: 12),

                  // RESULT BOX
                  ResultBox(
                    label: "Converted Amount",
                    value: "${formatNumberWithScientific(result)} $to",
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
