import 'package:flutter/material.dart';
import '../widgets/gradient_header.dart';

class TipsScreen extends StatelessWidget {
  const TipsScreen({super.key});

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
              children: tips.map((t) {
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.lightbulb, color: Colors.amber),
                    title: Text(t, style: const TextStyle(fontSize: 18)),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
