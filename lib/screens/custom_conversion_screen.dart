import 'package:flutter/material.dart';
import '../widgets/gradient_header.dart';

class CustomConversionScreen extends StatefulWidget {
  const CustomConversionScreen({super.key});

  @override
  State<CustomConversionScreen> createState() => _CustomConversionScreenState();
}

class _CustomConversionScreenState extends State<CustomConversionScreen> {
  String unitA = "";
  String unitB = "";
  String value = "";
  String rate = "";
  double result = 0;

  void calculate() {
    if (value.isEmpty || rate.isEmpty) return;
    try {
      double v = double.parse(value);
      double r = double.parse(rate); // 1A = rB
      setState(() => result = v * r);
    } catch (_) {
      setState(() => result = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const GradientHeader(title: "Custom Converter"),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: "Unit A",
                    hintText: "Example: Mango",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) => unitA = v,
                ),

                const SizedBox(height: 16),

                TextField(
                  decoration: const InputDecoration(
                    labelText: "Unit B",
                    hintText: "Example: Apple",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) => unitB = v,
                ),

                const SizedBox(height: 16),

                TextField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "How many A?",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) {
                    value = v;
                    calculate();
                  },
                ),

                const SizedBox(height: 16),

                TextField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Conversion Rate (1 A = ? B)",
                    hintText: "Example: Enter 2 only",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) {
                    rate = v;
                    calculate();
                  },
                ),

                const SizedBox(height: 20),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      "Result: $result $unitB",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                const Text(
                  "💡 Tip: 1 Mango = 2 Apples → Enter 2 only.",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
