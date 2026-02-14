import 'package:flutter/material.dart';
import '../widgets/gradient_header.dart';
import '../data/constants_data.dart';

class ConstantsScreen extends StatelessWidget {
  const ConstantsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const GradientHeader(title: "Scientific Constants", showBack: true),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: scientificConstants.length,
              itemBuilder: (context, i) {
                final constant = scientificConstants[i];

                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.science, color: Colors.green),
                    title: Text(
                      constant.name,
                      style: const TextStyle(fontSize: 18),
                    ),
                    subtitle: Text(
                      "${constant.symbol} = ${constant.value}",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
