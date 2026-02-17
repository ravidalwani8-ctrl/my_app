import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/history_item.dart';

class HistoryProvider extends ChangeNotifier {
  static const String _storageKey = "history_list";
  final List<HistoryItem> _history = [];

  UnmodifiableListView<HistoryItem> get history =>
      UnmodifiableListView(_history);

  HistoryProvider() {
    loadHistory();
  }

  Future<void> loadHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString(_storageKey);
      if (data == null || data.isEmpty) return;
      _history
        ..clear()
        ..addAll(HistoryItem.decode(data));
      notifyListeners();
    } catch (_) {
      _history.clear();
      notifyListeners();
    }
  }

  Future<void> addHistory(HistoryItem item) async {
    _history.insert(0, item); // newest at top
    await _saveToStorage();
    notifyListeners();
  }

  Future<void> removeHistory(HistoryItem item) async {
    _history.remove(item);
    await _saveToStorage();
    notifyListeners();
  }

  Future<void> clearHistory() async {
    _history.clear();
    await _saveToStorage();
    notifyListeners();
  }

  Future<void> _saveToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, HistoryItem.encode(_history));
  }
}
