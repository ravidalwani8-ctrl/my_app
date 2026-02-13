import 'package:flutter/material.dart';
import '../models/unit.dart';

class DropdownBox extends StatelessWidget {
  final List<Unit> units;
  final Unit selected;
  final Function(Unit) onChanged;

  const DropdownBox({
    super.key,
    required this.units,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: DropdownButton<Unit>(
          value: selected,
          isExpanded: true,
          underline: const SizedBox(),
          onChanged: (u) => onChanged(u!),
          items: units.map((u) {
            return DropdownMenuItem(value: u, child: Text(u.name));
          }).toList(),
        ),
      ),
    );
  }
}
