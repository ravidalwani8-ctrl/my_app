import 'package:flutter/material.dart';
import '../widgets/gradient_header.dart';

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

  void convert() {
    if (input.isEmpty) return;

    double value = double.tryParse(input) ?? 0;
    double celsius;

    // Convert to Celsius
    if (from == "Celsius") {
      celsius = value;
    } else if (from == "Fahrenheit") {
      celsius = (value - 32) * 5 / 9;
    } else {
      celsius = value - 273.15;
    }

    // Convert to target unit
    if (to == "Celsius") {
      result = celsius;
    } else if (to == "Fahrenheit") {
      result = (celsius * 9 / 5) + 32;
    } else {
      result = celsius + 273.15;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const GradientHeader(title: "Temperature", showBack: true),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  // FROM UNIT
                  DropdownButtonFormField(
                    initialValue: from,
                    decoration: const InputDecoration(
                      labelText: "From",
                      border: OutlineInputBorder(),
                    ),
                    items: units
                        .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                        .toList(),
                    onChanged: (v) {
                      from = v!;
                      convert();
                    },
                  ),

                  const SizedBox(height: 12),

                  // INPUT VALUE
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Enter value",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (v) {
                      input = v;
                      convert();
                    },
                  ),

                  const SizedBox(height: 12),

                  // TO UNIT
                  DropdownButtonFormField(
                    initialValue: to,
                    decoration: const InputDecoration(
                      labelText: "To",
                      border: OutlineInputBorder(),
                    ),
                    items: units
                        .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                        .toList(),
                    onChanged: (v) {
                      to = v!;
                      convert();
                    },
                  ),

                  const SizedBox(height: 20),

                  // RESULT BOX
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
          ),
        ],
      ),
    );
  }
}
