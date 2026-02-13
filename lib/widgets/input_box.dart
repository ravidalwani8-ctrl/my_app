import 'package:flutter/material.dart';

class InputBox extends StatelessWidget {
  final String label;
  final Function(String) onChanged;

  const InputBox({super.key, required this.label, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: TextField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
