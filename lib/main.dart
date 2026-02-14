import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'providers/theme_provider.dart';
import 'providers/favorites_provider.dart';
import 'providers/history_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => HistoryProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
