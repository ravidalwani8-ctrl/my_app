import 'package:flutter/material.dart';
import '../data/units_data.dart';
import '../models/category.dart';

class SearchProvider extends ChangeNotifier {
  List<Category> filteredCategories = allCategories;

  void search(String query) {
    if (query.isEmpty) {
      filteredCategories = allCategories;
    } else {
      filteredCategories = allCategories
          .where((cat) => cat.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    notifyListeners();
  }
}
