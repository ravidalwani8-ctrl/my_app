import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/favorite_item.dart';

class FavoritesProvider with ChangeNotifier {
  static const String _storageKey = "favorites_list";
  static const int _maxFavorites = 5;

  final List<FavoriteItem> _favorites = [];
  Future<void>? _loadingFuture;

  UnmodifiableListView<FavoriteItem> get favorites =>
      UnmodifiableListView(_favorites);

  FavoritesProvider() {
    _loadingFuture = loadFavorites();
  }

  Future<void> _ensureLoaded() async {
    await (_loadingFuture ??= loadFavorites());
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
    await _ensureLoaded();

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
    if (_favorites.length > _maxFavorites) {
      _favorites.removeRange(_maxFavorites, _favorites.length);
    }
    await _saveToStorage();
    notifyListeners();
  }

  Future<void> removeFavorite(FavoriteItem item) async {
    await _ensureLoaded();
    _favorites.remove(item);
    await _saveToStorage();
    notifyListeners();
  }

  Future<void> insertFavoriteAt(int index, FavoriteItem item) async {
    await _ensureLoaded();
    final safeIndex = index.clamp(0, _favorites.length);
    _favorites.insert(safeIndex, item);
    await _saveToStorage();
    notifyListeners();
  }

  Future<void> clearFavorites() async {
    await _ensureLoaded();
    _favorites.clear();
    await _saveToStorage();
    notifyListeners();
  }

  Future<void> restoreAllFavorites(List<FavoriteItem> items) async {
    await _ensureLoaded();
    _favorites
      ..clear()
      ..addAll(items);
    await _saveToStorage();
    notifyListeners();
  }

  Future<void> _saveToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, FavoriteItem.encode(_favorites));
  }
}
