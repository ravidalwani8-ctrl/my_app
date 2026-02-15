import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/decimal_text_input_formatter.dart';
import 'package:flutter/services.dart';
import '../widgets/gradient_header.dart';
import '../widgets/result_box.dart';
import '../providers/favorites_provider.dart';
import '../providers/history_provider.dart';
import '../models/favorite_item.dart';
import '../models/history_item.dart';

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
    if (rateInput.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter conversion rate first")),
      );
      return;
    }

    Provider.of<FavoritesProvider>(context, listen: false).addFavorite(
      FavoriteItem(
        category: "Currency",
        fromUnit: from,
        toUnit: to,
        sampleConversion: "1 $from = $rateInput $to",
      ),
    );

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Added to Favorites")));
  }

  /// SAVE HISTORY
  void saveHistory() {
    if (amount.isEmpty || rateInput.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter amount and rate first")),
      );
      return;
    }

    Provider.of<HistoryProvider>(context, listen: false).addHistory(
      HistoryItem(
        category: "Currency",
        fromUnit: from,
        toUnit: to,
        inputValue: amount,
        result: result.toString(),
        timestamp: DateTime.now().toString(),
      ),
    );

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Saved to History")));
  }

  /// Numeric-only calculation
  void calculate() {
    if (amount.isEmpty || rateInput.isEmpty) {
      setState(() => result = 0);
      return;
    }

    try {
      final amt = double.parse(amount);
      final rate = double.parse(rateInput);
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
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
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
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9\.]')),
                      DecimalTextInputFormatter(decimalRange: 6),
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

                  const SizedBox(height: 10),

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

                  const SizedBox(height: 10),

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
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9\.]')),
                      DecimalTextInputFormatter(decimalRange: 6),
                    ],
                    onChanged: (v) {
                      rateInput = v;
                      calculate();
                    },
                  ),

                  const SizedBox(height: 25),

                  // RESULT BOX
                  ResultBox(label: "Converted Amount", value: "$result $to"),

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
