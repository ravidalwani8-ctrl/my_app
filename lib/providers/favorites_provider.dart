import 'package:flutter/material.dart';
import '../models/favorite_item.dart';

class FavoritesProvider extends ChangeNotifier {
  final List<FavoriteItem> _favorites = [];

  List<FavoriteItem> get favorites => _favorites;

  void addFavorite(FavoriteItem item) {
    _favorites.add(item);
    notifyListeners();
  }

  void removeFavorite(FavoriteItem item) {
    _favorites.remove(item);
    notifyListeners();
  }

  void clearFavorites() {
    _favorites.clear();
    notifyListeners();
  }
}
