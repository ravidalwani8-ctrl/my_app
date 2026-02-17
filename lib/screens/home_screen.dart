import 'package:flutter/material.dart';
import '../data/units_data.dart';
import 'conversion_screen.dart';
import 'temperature_screen.dart';
import 'currency_screen.dart';
import 'custom_conversion_screen.dart';
import 'tips_constants_screen.dart';
import 'favorites_screen.dart';
import 'history_screen.dart';
import 'settings_screen.dart';
import '../widgets/gradient_header.dart';

final Map<String, IconData> categoryIcons = {
  "Length": Icons.straighten,
  "Weight": Icons.monitor_weight,
  //"Area": Icons.crop_square,
  //"Volume": Icons.local_drink,
  "Speed": Icons.speed,
  "Time": Icons.access_time,
  "Pressure": Icons.compress,
  "Energy": Icons.bolt,
  //"Power": Icons.power,
  "Data": Icons.storage,
};

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Helper function to get category color
  Color _getCategoryColor(String categoryName) {
    switch (categoryName) {
      case "Length":
        return Colors.orange;
      case "Weight":
        return Colors.blue;
      case "Time":
        return Colors.amber;
      case "Energy":
        return Colors.red;
      case "Speed":
        return Colors.green;
      case "Pressure":
        return Colors.orange;
      case "Data":
        return Colors.blue;
      default:
        return Colors.purple;
    }
  }

  // Helper widget for 2x2 Grid
  Widget _gridCard(
    IconData icon,
    String title,
    VoidCallback onTap,
    BuildContext context, {
    Color? iconColor,
  }) {
    final color =
        iconColor ??
        (Theme.of(context).brightness == Brightness.dark
            ? Colors.purpleAccent
            : Colors.purple);
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const GradientHeader(title: "Smart Converter"),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              children: [
                /// ----------------------------------------------------
                /// 1) TEMPERATURE (FIRST)
                /// ----------------------------------------------------
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.thermostat, color: Colors.red),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Temperature",
                          style: TextStyle(fontSize: 18),
                        ),
                        Icon(
                          Icons.swap_horiz,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.purpleAccent
                              : Colors.purple,
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.keyboard_arrow_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const TemperatureScreen(),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 12),

                /// ----------------------------------------------------
                /// 2) CURRENCY (SECOND)
                /// ----------------------------------------------------
                Card(
                  child: ListTile(
                    leading: Icon(
                      Icons.currency_exchange,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.lightGreen
                          : Colors.green,
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Currency Converter",
                          style: TextStyle(fontSize: 18),
                        ),
                        Icon(
                          Icons.swap_horiz,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.purpleAccent
                              : Colors.purple,
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.keyboard_arrow_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CurrencyScreen(),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 12),

                /// ----------------------------------------------------
                /// 3) MAIN CATEGORIES (Length, Weight, Area, etc.)
                /// ----------------------------------------------------
                ...allCategories.map(
                  (cat) => Card(
                    child: ListTile(
                      leading: Icon(
                        categoryIcons[cat.name] ?? Icons.ac_unit,
                        color: _getCategoryColor(cat.name),
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(cat.name, style: const TextStyle(fontSize: 18)),
                          Icon(
                            Icons.swap_horiz,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? Colors.purpleAccent
                                : Colors.purple,
                          ),
                        ],
                      ),
                      trailing: const Icon(Icons.keyboard_arrow_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ConversionScreen(category: cat),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                /// ----------------------------------------------------
                /// 4) CUSTOM CONVERTER
                /// ----------------------------------------------------
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.edit, color: Colors.amber),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Custom Converter",
                          style: TextStyle(fontSize: 18),
                        ),
                        Icon(
                          Icons.swap_horiz,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.purpleAccent
                              : Colors.purple,
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.keyboard_arrow_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CustomConversionScreen(),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 12),

                /// ----------------------------------------------------
                /// 6) 2×2 GRID: Tips, Favorites, History, Settings
                /// ----------------------------------------------------
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 1.5,
                  padding: const EdgeInsets.all(8),
                  children: [
                    _gridCard(
                      Icons.lightbulb,
                      "Tips & Tricks",
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const TipsConstantsScreen(),
                          ),
                        );
                      },
                      context,
                      iconColor: Colors.green,
                    ),

                    _gridCard(
                      Icons.favorite,
                      "Favorites",
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const FavoritesScreen(),
                          ),
                        );
                      },
                      context,
                      iconColor: Colors.amber,
                    ),

                    _gridCard(
                      Icons.history,
                      "History",
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const HistoryScreen(),
                          ),
                        );
                      },
                      context,
                      iconColor: Colors.orange,
                    ),

                    _gridCard(
                      Icons.settings,
                      "Settings",
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SettingsScreen(),
                          ),
                        );
                      },
                      context,
                      iconColor: Colors.blue,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
