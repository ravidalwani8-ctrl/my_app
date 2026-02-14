import 'package:flutter/material.dart';
import '../widgets/gradient_header.dart';
import '../widgets/result_box.dart';

class CurrencyScreen extends StatefulWidget {
  const CurrencyScreen({super.key});

  @override
  State<CurrencyScreen> createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<CurrencyScreen> {
  final List<String> currencies = ["INR", "USD", "EUR", "GBP", "JPY", "AED"];

  String from = "INR";
  String to = "USD";

  String amount = "";
  String rateInput = "";
  double result = 0;

  void calculate() {
    if (amount.isEmpty || rateInput.isEmpty) {
      setState(() => result = 0);
      return;
    }

    try {
      double amt = double.parse(amount);
      double rate = double.parse(rateInput); // numeric only now

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
          const GradientHeader(title: "Currency Converter", showBack: true),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: ListView(
                children: [
                  // FROM CURRENCY
                  DropdownButtonFormField(
                    initialValue: from,
                    decoration: const InputDecoration(
                      labelText: "From Currency",
                      border: OutlineInputBorder(),
                    ),
                    items: currencies
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (v) => setState(() => from = v!),
                  ),

                  const SizedBox(height: 12),

                  // TO CURRENCY
                  DropdownButtonFormField(
                    initialValue: to,
                    decoration: const InputDecoration(
                      labelText: "To Currency",
                      border: OutlineInputBorder(),
                    ),
                    items: currencies
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (v) => setState(() => to = v!),
                  ),

                  const SizedBox(height: 12),

                  // AMOUNT
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Enter Amount",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (v) {
                      amount = v;
                      calculate();
                    },
                  ),

                  const SizedBox(height: 12),

                  // RATE INPUT — numeric only
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Conversion Rate (Enter rate only)",
                      hintText: "Example: If 1 USD= 83 INR, enter 83",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (v) {
                      rateInput = v;
                      calculate();
                    },
                  ),

                  const SizedBox(height: 25),

                  // RESULT BOX (colored output)
                  ResultBox(label: "Converted Amount", value: "$result $to"),

                  const SizedBox(height: 15),

                  const Text(
                    "💡 Tip: If 1 USD = 83 INR → Enter 83 only.",
                    style: TextStyle(fontSize: 15, color: Colors.grey),
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
