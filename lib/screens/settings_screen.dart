import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/theme_provider.dart';
import '../providers/history_provider.dart';
import '../providers/favorites_provider.dart';
import '../widgets/gradient_header.dart';
import 'help_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("About Smart Converter"),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Smart Converter",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Version 1.0.0",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              const Text(
                "Convert between units, currencies, and temperatures quickly and easily with Smart Converter.",
                style: TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 20),
              const Text(
                "Developer",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const Text(
                "Smart Converter Team",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              const Text(
                "Contact & Support",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _launchURL('mailto:support@smartconverter.com'),
                child: const Text(
                  "📧 support@smartconverter.com",
                  style: TextStyle(fontSize: 12, color: Colors.blue),
                ),
              ),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: () => _launchURL(
                  'https://github.com/smartconverter/smart-converter',
                ),
                child: const Text(
                  "🔗 GitHub Repository",
                  style: TextStyle(fontSize: 12, color: Colors.blue),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "© 2026 Smart Converter. All rights reserved.",
                style: TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final historyProvider = Provider.of<HistoryProvider>(context);
    final favoritesProvider = Provider.of<FavoritesProvider>(context);

    return Scaffold(
      body: Column(
        children: [
          const GradientHeader(title: "Settings", showBack: true),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(0, 14, 0, 16),
              children: [
                /// APPEARANCE SECTION
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Text(
                    "Appearance",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
                SwitchListTile(
                  title: const Text("Dark Mode"),
                  secondary: const Icon(Icons.dark_mode),
                  value: themeProvider.isDark,
                  onChanged: (v) => themeProvider.toggle(),
                ),
                const Divider(),

                /// DATA MANAGEMENT SECTION
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    "Data Management",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text("Clear History"),
                  subtitle: Text(
                    "${historyProvider.history.length} items",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Clear History?"),
                        content: const Text(
                          "This will delete all your conversion history. This action cannot be undone.",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () {
                              historyProvider.clearHistory();
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("History cleared"),
                                ),
                              );
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                            child: const Text("Clear"),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete_sweep),
                  title: const Text("Clear Favorites"),
                  subtitle: Text(
                    "${favoritesProvider.favorites.length} items",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Clear Favorites?"),
                        content: const Text(
                          "This will delete all your saved favorites. This action cannot be undone.",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () {
                              favoritesProvider.clearFavorites();
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Favorites cleared"),
                                ),
                              );
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                            child: const Text("Clear"),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const Divider(),

                /// ABOUT & SUPPORT SECTION
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    "About & Support",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.help_outline),
                  title: const Text("Help & Usage"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const HelpScreen()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text("About App"),
                  onTap: () => _showAboutDialog(context),
                ),
                ListTile(
                  leading: const Icon(Icons.privacy_tip),
                  title: const Text("Privacy Policy"),
                  onTap: () => _launchURL('https://smartconverter.com/privacy'),
                ),
                ListTile(
                  leading: const Icon(Icons.description),
                  title: const Text("Terms of Service"),
                  onTap: () => _launchURL('https://smartconverter.com/terms'),
                ),
                ListTile(
                  leading: const Icon(Icons.code),
                  title: const Text("GitHub Repository"),
                  onTap: () => _launchURL(
                    'https://github.com/smartconverter/smart-converter',
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.star),
                  title: const Text("Rate App"),
                  onTap: () => _launchURL(
                    'https://play.google.com/store/apps/details?id=com.smartconverter',
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.email),
                  title: const Text("Send Feedback"),
                  onTap: () => _launchURL(
                    'mailto:support@smartconverter.com?subject=Smart%20Converter%20Feedback',
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
