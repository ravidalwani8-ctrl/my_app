import 'package:flutter/material.dart';
import '../widgets/gradient_header.dart';
import '../widgets/result_box.dart';

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
    if (value.isEmpty || rate.isEmpty) {
      setState(() => result = 0);
      return;
    }

    try {
      double v = double.parse(value);
      double r = double.parse(rate); // 1 A = r B
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
          const GradientHeader(title: "Custom Converter", showBack: true),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // UNIT A
                TextField(
                  decoration: const InputDecoration(
                    labelText: "Unit A",
                    hintText: "Example: Mango",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) => setState(() => unitA = v),
                ),
                const SizedBox(height: 16),

                // UNIT B
                TextField(
                  decoration: const InputDecoration(
                    labelText: "Unit B",
                    hintText: "Example: Apple",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) => setState(() => unitB = v),
                ),
                const SizedBox(height: 24),

                // VALUE
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "How many $unitA?",
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (v) {
                    value = v;
                    calculate();
                  },
                ),
                const SizedBox(height: 24),

                // RATE
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Conversion Rate (1 $unitA = ? $unitB)",
                    hintText: "Example: If A=2B Enter 2 only",
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (v) {
                    rate = v;
                    calculate();
                  },
                ),

                const SizedBox(height: 30),

                // RESULT BOX
                ResultBox(label: "Converted Value", value: "$result $unitB"),

                const SizedBox(height: 20),

                const Text(
                  "💡 Tip: For 1 Mango = 2 Apples → Enter 2 only.",
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
