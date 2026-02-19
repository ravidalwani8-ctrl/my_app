import 'package:flutter/material.dart';
import '../widgets/gradient_header.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  static const List<String> _basicUsage = [
    "Select source and target units first.",
    "Enter value in the input box to see live conversion.",
    "Use Save to Favorites to keep reusable conversions.",
    "Use Save to History to track recent conversions.",
  ];

  static const List<String> _numberInputRules = [
    "Digits 0-9 and decimal point (.) are allowed.",
    "You can type e (base e input) or x/X/* (auto-converts to ×10^).",
  ];

  static const List<String> _scientificExamples = [
    "1×10^3 = 1000",
    "2.5×10^-4 = 0.00025",
    "1x3 becomes 1×10^3 automatically",
    "3*2 becomes 3×10^2 automatically",
  ];

  static const List<String> _baseEExamples = [
    "e means Euler's constant (about 2.71828).",
    "1e3 means 1 × e^3 (base e input).",
    "2e-1 means 2 × e^-1.",
    "Results are displayed using 10^ style, not e style.",
  ];

  Widget _section(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<String> points,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...points.map(
              (line) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text("• $line"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const GradientHeader(title: "Help & Usage", showBack: true),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
              children: [
                _section(
                  context,
                  title: "Basic Usage",
                  icon: Icons.menu_book,
                  points: _basicUsage,
                ),
                _section(
                  context,
                  title: "Input Rules",
                  icon: Icons.keyboard,
                  points: _numberInputRules,
                ),
                _section(
                  context,
                  title: "Base 10 Scientific",
                  icon: Icons.calculate,
                  points: _scientificExamples,
                ),
                _section(
                  context,
                  title: "Base e Input",
                  icon: Icons.functions,
                  points: _baseEExamples,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
