import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/history_provider.dart';
import '../widgets/gradient_header.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final history = Provider.of<HistoryProvider>(context).history;

    return Scaffold(
      body: Column(
        children: [
          const GradientHeader(title: "History"),

          Expanded(
            child: history.isEmpty
                ? const Center(
                    child: Text(
                      "No history yet",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: history.length,
                    itemBuilder: (context, i) {
                      final h = history[i];

                      return Card(
                        child: ListTile(
                          leading: const Icon(
                            Icons.history,
                            color: Colors.blueGrey,
                          ),
                          title: Text(
                            "${h.inputValue} ${h.fromUnit} → ${h.result} ${h.toUnit}",
                          ),
                          subtitle: Text(h.timestamp),
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
