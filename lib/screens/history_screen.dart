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
          const GradientHeader(title: "History", showBack: true),

          Expanded(
            child: history.isEmpty
                ? const Center(
                    child: Text(
                      "No history yet",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                    itemCount: history.length,
                    itemBuilder: (context, i) {
                      final h = history[i];

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: const Icon(
                            Icons.history,
                            color: Colors.blueGrey,
                          ),
                          title: Text(
                            "${h.inputValue} ${h.fromUnit} → ${h.result} ${h.toUnit}",
                            style: const TextStyle(fontSize: 17),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(h.timestamp),
                              if (h.category == "Currency" &&
                                  h.rateUsed != null)
                                Text("Rate used = ${h.rateUsed!}"),
                              if (h.category == "Custom" && h.rateUsed != null)
                                Text(
                                  "Conversion rate: 1 ${h.fromUnit} = ${h.rateUsed!} ${h.toUnit}",
                                ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              Provider.of<HistoryProvider>(
                                context,
                                listen: false,
                              ).removeHistory(h);
                            },
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
