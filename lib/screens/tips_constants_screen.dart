import 'package:flutter/material.dart';
import '../widgets/gradient_header.dart';
import '../data/constants_data.dart';

class TipsConstantsScreen extends StatelessWidget {
  const TipsConstantsScreen({super.key});

  static const Map<String, List<String>> categorizedTips = {
    "Temperature": [
      "°C = K - 273.15, °F = (°C × 9/5) + 32",
      "0 K = -273.15 °C = -459.67 °F (absolute zero)",
    ],
    "Length": ["1 inch = 2.54 cm", "1 mile = 1.60934 km"],
    "Weight": ["1 kg = 2.20462 lb", "1 oz = 28.3495 g"],
    "Time": ["1 hour = 3600 seconds", "1 week = 7 days = 168 hours"],
    "Speed": ["1 m/s = 3.6 km/h", "1 mph = 1.60934 km/h"],
    "Pressure": ["1 atm = 101.325 kPa", "1 bar = 100 kPa"],
    "Energy": ["1 cal = 4.184 J", "1 kWh = 3.6 × 10^6 J"],
    "Data": ["1 KB = 1024 bytes", "1 MB = 1024 KB, 1 GB = 1024 MB"],
    "Area": ["1 m² = 10,000 cm²", "1 acre = 4046.86 m²"],
    "Power": ["1 kW = 1000 W", "1 hp ≈ 745.7 W"],
    "Frequency": ["1 Hz = 1 cycle/second", "60 RPM = 1 Hz"],
  };

  static const Map<String, IconData> categoryIcons = {
    "Temperature": Icons.thermostat,
    "Currency": Icons.currency_exchange,
    "Length": Icons.straighten,
    "Weight": Icons.monitor_weight,
    "Time": Icons.access_time,
    "Speed": Icons.speed,
    "Pressure": Icons.compress,
    "Energy": Icons.bolt,
    "Data": Icons.storage,
    "Area": Icons.square_foot,
    "Power": Icons.power,
    "Frequency": Icons.graphic_eq,
    "Custom": Icons.edit,
  };

  static const Map<String, Color> categoryColors = {
    "Temperature": Colors.red,
    "Currency": Colors.green,
    "Length": Colors.orange,
    "Weight": Colors.blue,
    "Time": Colors.amber,
    "Speed": Colors.teal,
    "Pressure": Colors.deepOrange,
    "Energy": Colors.redAccent,
    "Data": Colors.indigo,
    "Area": Colors.teal,
    "Power": Colors.deepPurple,
    "Frequency": Colors.indigo,
    "Custom": Colors.amber,
  };

  @override
  Widget build(BuildContext context) {
    final groupedConstants = <String, List<ScientificConstant>>{};
    for (final constant in scientificConstants) {
      groupedConstants.putIfAbsent(constant.category, () => []).add(constant);
    }

    return Scaffold(
      body: Column(
        children: [
          const GradientHeader(title: "Tips & Tricks", showBack: true),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
              children: [
                const Text(
                  "Tips by Category",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 14),

                ...categorizedTips.entries.map(
                  (entry) => Card(
                    margin: const EdgeInsets.only(bottom: 14),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                categoryIcons[entry.key] ?? Icons.lightbulb,
                                color:
                                    categoryColors[entry.key] ?? Colors.amber,
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
                          const SizedBox(height: 12),
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

                const SizedBox(height: 14),

                // LABEL
                const Text(
                  "Scientific Constants",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 14),

                ...groupedConstants.entries.map(
                  (entry) => Card(
                    margin: const EdgeInsets.only(bottom: 14),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.key,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...entry.value.map(
                            (c) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.science,
                                    size: 18,
                                    color: Colors.green,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      "${c.name} (${c.symbol}) = ${c.value}",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
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
