import 'package:flutter/material.dart';
import '../models/history_item.dart';

class HistoryProvider extends ChangeNotifier {
  final List<HistoryItem> _history = [];

  List<HistoryItem> get history => _history;

  void addHistory(HistoryItem item) {
    _history.insert(0, item); // newest at top
    notifyListeners();
  }

  void clearHistory() {
    _history.clear();
    notifyListeners();
  }
}
