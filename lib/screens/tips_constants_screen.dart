import 'package:flutter/material.dart';
import '../widgets/gradient_header.dart';
import '../data/constants_data.dart';

class TipsConstantsScreen extends StatelessWidget {
  const TipsConstantsScreen({super.key});

  static const Map<String, List<String>> categorizedTips = {
    "Length": ["1 inch = 2.54 cm", "1 mile = 1.609 km"],
    "Weight": ["1 kg = 2.204 pounds"],
    "Time": ["1 hour = 3600 seconds"],
    "Speed": ["1 m/s = 3.6 km/h"],
    "Pressure": ["1 atm = 101.325 kPa", "1 bar = 100 kPa"],
    "Energy": ["1 calorie = 4.184 joules"],
    "Volume": ["1 litre = 1000 ml"],
  };

  static const Map<String, IconData> categoryIcons = {
    "Length": Icons.straighten,
    "Weight": Icons.monitor_weight,
    "Time": Icons.access_time,
    "Speed": Icons.speed,
    "Pressure": Icons.compress,
    "Energy": Icons.bolt,
    "Volume": Icons.local_drink,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const GradientHeader(title: "Tips & Tricks", showBack: true),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              children: [
                const Text(
                  "Tips by Category",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                ...categorizedTips.entries.map(
                  (entry) => Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                categoryIcons[entry.key] ?? Icons.lightbulb,
                                color: Colors.amber,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                entry.key,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ...entry.value.map(
                            (tip) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              child: Text("• $tip"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // LABEL
                const Text(
                  "Scientific Constants",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

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
