import 'package:flutter/material.dart';

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
    if (amount.isEmpty || rateInput.isEmpty) return;
    try {
      double amt = double.parse(amount);

      List<String> parts = rateInput.split('=');
      double leftVal = double.parse(parts[0].trim().split(' ')[0]);
      double rightVal = double.parse(parts[1].trim().split(' ')[0]);

      double rate = rightVal / leftVal;
      result = amt * rate;

      setState(() {});
    } catch (e) {
      setState(() => result = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Currency Converter")),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            DropdownButtonFormField(
              value: from,
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

            DropdownButtonFormField(
              value: to,
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

            TextField(
              decoration: const InputDecoration(
                labelText: "Enter Rate (e.g., 1 USD = 83 INR)",
                border: OutlineInputBorder(),
              ),
              onChanged: (v) {
                rateInput = v;
                calculate();
              },
            ),

            const SizedBox(height: 20),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Text(
                  "Result: $result $to",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
