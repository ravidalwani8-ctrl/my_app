import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/favorite_item.dart';

class FavoritesProvider with ChangeNotifier {
  static const String _storageKey = "favorites_list";

  final List<FavoriteItem> _favorites = [];

  UnmodifiableListView<FavoriteItem> get favorites =>
      UnmodifiableListView(_favorites);

  FavoritesProvider() {
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString(_storageKey);
      if (data == null || data.isEmpty) return;
      _favorites
        ..clear()
        ..addAll(FavoriteItem.decode(data));
      notifyListeners();
    } catch (_) {
      _favorites.clear();
      notifyListeners();
    }
  }

  Future<void> addFavorite(FavoriteItem item) async {
    final exists = _favorites.any(
      (f) =>
          f.category == item.category &&
          f.fromUnit == item.fromUnit &&
          f.toUnit == item.toUnit &&
          f.inputValue == item.inputValue &&
          f.resultValue == item.resultValue &&
          f.rateUsed == item.rateUsed,
    );
    if (exists) return;

    _favorites.insert(0, item);
    await _saveToStorage();
    notifyListeners();
  }

  Future<void> removeFavorite(FavoriteItem item) async {
    _favorites.remove(item);
    await _saveToStorage();
    notifyListeners();
  }

  Future<void> clearFavorites() async {
    _favorites.clear();
    await _saveToStorage();
    notifyListeners();
  }

  Future<void> _saveToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, FavoriteItem.encode(_favorites));
  }
}
