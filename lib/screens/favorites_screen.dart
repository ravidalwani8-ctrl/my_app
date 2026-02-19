import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';
import '../data/units_data.dart';
import '../widgets/gradient_header.dart';
import '../utils/number_formatter.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  String _selectedCategory = "All";

  @override
  Widget build(BuildContext context) {
    final favProvider = Provider.of<FavoritesProvider>(context);
    final favs = favProvider.favorites;
    final categoryColors = <String, Color>{
      "All": Colors.purple,
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
    final categoryIcons = <String, IconData>{
      "All": Icons.filter_list,
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
    final baseCategories = <String>[
      "Temperature",
      "Currency",
      ...allCategories.map((c) => c.name),
      "Custom",
    ];
    final categories = <String>["All"];
    for (final c in baseCategories) {
      if (!categories.contains(c)) categories.add(c);
    }
    for (final c in favs.map((f) => f.category)) {
      if (!categories.contains(c)) categories.add(c);
    }

    if (!categories.contains(_selectedCategory)) {
      _selectedCategory = "All";
    }

    final filtered = _selectedCategory == "All"
        ? favs
        : favs.where((f) => f.category == _selectedCategory).toList();

    return Scaffold(
      body: Column(
        children: [
          const GradientHeader(title: "Favorites", showBack: true),

          Expanded(
            child: favs.isEmpty
                ? const Center(
                    child: Text(
                      "No favorites added yet",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
                    children: [
                      DropdownButtonFormField<String>(
                        initialValue: _selectedCategory,
                        decoration: const InputDecoration(
                          labelText: "Filter by category",
                          border: OutlineInputBorder(),
                        ),
                        items: categories
                            .map(
                              (c) => DropdownMenuItem<String>(
                                value: c,
                                child: Row(
                                  children: [
                                    Icon(
                                      categoryIcons[c] ?? Icons.filter_list,
                                      color:
                                          categoryColors[c] ?? Colors.purple,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(c),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (v) {
                          if (v == null) return;
                          setState(() => _selectedCategory = v);
                        },
                      ),
                      const SizedBox(height: 14),
                      if (filtered.isEmpty)
                        const Padding(
                          padding: EdgeInsets.only(top: 24),
                          child: Center(
                            child: Text(
                              "No favorites in this category",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        )
                      else
                        ...List.generate(filtered.length, (index) {
                          final item = filtered[index];

                          return Card(
                            margin: const EdgeInsets.only(bottom: 14),
                            child: ListTile(
                              title: Text(item.category),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "${formatNumberWithScientific(item.inputValue)} ${item.fromUnit} = ${formatNumberWithScientific(item.resultValue)} ${item.toUnit}",
                                  ),
                                  if (item.category == "Currency" &&
                                      item.rateUsed != null)
                                    Text(
                                      "Rate used = ${formatNumberWithScientific(item.rateUsed!)}",
                                    ),
                                  if (item.category == "Custom" &&
                                      item.rateUsed != null)
                                    Text(
                                      "Conversion rate: 1 ${item.fromUnit} = ${formatNumberWithScientific(item.rateUsed!)} ${item.toUnit}",
                                    ),
                                ],
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  final provider = context
                                      .read<FavoritesProvider>();
                                  final removedItem = item;
                                  final removedIndex = favs.indexOf(item);

                                  await provider.removeFavorite(removedItem);
                                  if (!context.mounted) return;

                                  ScaffoldMessenger.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(
                                      SnackBar(
                                        content: const Text("Favorite removed"),
                                        duration: const Duration(seconds: 3),
                                        action: SnackBarAction(
                                          label: "UNDO",
                                          onPressed: () {
                                            provider.insertFavoriteAt(
                                              removedIndex,
                                              removedItem,
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                },
                              ),
                            ),
                          );
                        }),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
