import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';
import '../widgets/gradient_header.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favProvider = Provider.of<FavoritesProvider>(context);
    final favs = favProvider.favorites;

    return Scaffold(
      body: Column(
        children: [
          const GradientHeader(title: "Favorites"),

          Expanded(
            child: favs.isEmpty
                ? const Center(
                    child: Text(
                      "No favorites added yet",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: favs.length,
                    itemBuilder: (context, i) {
                      final f = favs[i];

                      return Card(
                        child: ListTile(
                          leading: const Icon(
                            Icons.favorite,
                            color: Colors.red,
                          ),
                          title: Text(
                            "${f.fromUnit} → ${f.toUnit}",
                            style: const TextStyle(fontSize: 18),
                          ),
                          subtitle: Text(f.sampleConversion),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              favProvider.removeFavorite(f);
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
