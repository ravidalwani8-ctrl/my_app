import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/history_provider.dart';
import '../providers/favorites_provider.dart';
import '../widgets/gradient_header.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final historyProvider = Provider.of<HistoryProvider>(context);
    final favoritesProvider = Provider.of<FavoritesProvider>(context);

    return Scaffold(
      body: Column(
        children: [
          const GradientHeader(title: "Settings", showBack: true),

          // DARK MODE TOGGLE
          SwitchListTile(
            title: const Text("Dark Mode"),
            secondary: const Icon(Icons.dark_mode),
            value: themeProvider.isDark,
            onChanged: (v) => themeProvider.toggle(),
          ),

          const SizedBox(height: 10),

          // CLEAR HISTORY
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text("Clear History"),
            onTap: () {
              historyProvider.clearHistory();
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("History cleared")));
            },
          ),

          // CLEAR FAVORITES
          ListTile(
            leading: const Icon(Icons.delete_sweep),
            title: const Text("Clear Favorites"),
            onTap: () {
              favoritesProvider.clearFavorites();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Favorites cleared")),
              );
            },
          ),
        ],
      ),
    );
  }
}
