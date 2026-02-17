import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';
import '../widgets/gradient_header.dart';
import '../utils/number_formatter.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favProvider = Provider.of<FavoritesProvider>(context);
    final favs = favProvider.favorites;

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
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                    itemCount: favs.length,
                    itemBuilder: (context, index) {
                      final item = favs[index];

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
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
                            onPressed: () {
                              context.read<FavoritesProvider>().removeFavorite(
                                item,
                              );
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
