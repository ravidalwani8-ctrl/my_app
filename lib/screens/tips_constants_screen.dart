import 'package:flutter/material.dart';
import '../widgets/gradient_header.dart';
import '../data/constants_data.dart';

class TipsConstantsScreen extends StatelessWidget {
  const TipsConstantsScreen({super.key});

  static const tips = [
    "1 km = 1000 m",
    "1 inch = 2.54 cm",
    "1 kg = 2.204 pounds",
    "Speed of light = 3 × 10⁸ m/s",
    "1 litre = 1000 ml",
    "Earth gravity = 9.8 m/s²",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const GradientHeader(title: "Tips & Tricks", showBack: true),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // TIPS FIRST
                ...tips.map(
                  (t) => Card(
                    child: ListTile(
                      leading: const Icon(Icons.lightbulb, color: Colors.amber),
                      title: Text(t, style: const TextStyle(fontSize: 18)),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // LABEL
                const Text(
                  "Scientific Constants",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                // CONSTANTS BELOW
                ...scientificConstants.map(
                  (c) => Card(
                    child: ListTile(
                      leading: const Icon(Icons.science, color: Colors.green),
                      title: Text(c.name),
                      subtitle: Text("${c.symbol} = ${c.value}"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
