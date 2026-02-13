import 'package:flutter/material.dart';
import '../data/constants_data.dart';

class ConstantsScreen extends StatelessWidget {
  const ConstantsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scientific Constants")),

      body: ListView(
        padding: const EdgeInsets.all(12),
        children: constants.map((c) {
          return Card(
            elevation: 2,
            child: ListTile(
              title: Text(
                c["name"]!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              subtitle: Text(c["value"]!, style: const TextStyle(fontSize: 16)),
            ),
          );
        }).toList(),
      ),
    );
  }
}
