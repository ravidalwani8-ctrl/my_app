import 'package:flutter/material.dart';
import '../data/units_data.dart';
import 'conversion_screen.dart';
import 'temperature_screen.dart';
import 'currency_screen.dart';
import 'custom_conversion_screen.dart';
import 'constants_screen.dart';
import 'tips_screen.dart';
import 'favorites_screen.dart';
import 'history_screen.dart';
import 'settings_screen.dart';
import '../widgets/gradient_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const GradientHeader(title: "Smart Converter"),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                /// ===============================
                /// MAIN CATEGORIES
                /// ===============================
                ...allCategories.map(
                  (cat) => Card(
                    child: ListTile(
                      leading: const Icon(
                        Icons.swap_horiz,
                        color: Colors.purple,
                      ),
                      title: Text(
                        cat.name,
                        style: const TextStyle(fontSize: 18),
                      ),
                      trailing: const Icon(Icons.keyboard_arrow_right),
                      onTap: () {
                        if (cat.name.contains("Currency")) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CurrencyScreen(),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ConversionScreen(category: cat),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                /// ===============================
                /// TEMPERATURE
                /// ===============================
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.thermostat, color: Colors.orange),
                    title: const Text("Temperature"),
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

                /// ===============================
                /// CUSTOM CONVERTER
                /// ===============================
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.edit, color: Colors.blue),
                    title: const Text("Custom Converter"),
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

                /// ===============================
                /// SCIENTIFIC CONSTANTS
                /// ===============================
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.science, color: Colors.green),
                    title: const Text("Scientific Constants"),
                    trailing: const Icon(Icons.keyboard_arrow_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ConstantsScreen(),
                        ),
                      );
                    },
                  ),
                ),

                /// ===============================
                /// TIPS
                /// ===============================
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.lightbulb, color: Colors.amber),
                    title: const Text("Tips & Tricks"),
                    trailing: const Icon(Icons.keyboard_arrow_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const TipsScreen()),
                      );
                    },
                  ),
                ),

                /// ===============================
                /// FAVORITES
                /// ===============================
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.favorite, color: Colors.red),
                    title: const Text("Favorites"),
                    trailing: const Icon(Icons.keyboard_arrow_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const FavoritesScreen(),
                        ),
                      );
                    },
                  ),
                ),

                /// ===============================
                /// HISTORY
                /// ===============================
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.history, color: Colors.brown),
                    title: const Text("History"),
                    trailing: const Icon(Icons.keyboard_arrow_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const HistoryScreen(),
                        ),
                      );
                    },
                  ),
                ),

                /// ===============================
                /// SETTINGS
                /// ===============================
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.settings, color: Colors.grey),
                    title: const Text("Settings"),
                    trailing: const Icon(Icons.keyboard_arrow_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SettingsScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
