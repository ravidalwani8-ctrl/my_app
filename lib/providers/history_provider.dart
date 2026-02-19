import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/history_item.dart';

class HistoryProvider extends ChangeNotifier {
  static const String _storageKey = "history_list";
  final List<HistoryItem> _history = [];
  Future<void>? _loadingFuture;

  UnmodifiableListView<HistoryItem> get history =>
      UnmodifiableListView(_history);

  HistoryProvider() {
    _loadingFuture = loadHistory();
  }

  Future<void> _ensureLoaded() async {
    await (_loadingFuture ??= loadHistory());
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
    await _ensureLoaded();
    _history.insert(0, item); // newest at top
    await _saveToStorage();
    notifyListeners();
  }

  Future<void> removeHistory(HistoryItem item) async {
    await _ensureLoaded();
    _history.remove(item);
    await _saveToStorage();
    notifyListeners();
  }

  Future<void> insertHistoryAt(int index, HistoryItem item) async {
    await _ensureLoaded();
    final safeIndex = index.clamp(0, _history.length);
    _history.insert(safeIndex, item);
    await _saveToStorage();
    notifyListeners();
  }

  Future<void> clearHistory() async {
    await _ensureLoaded();
    _history.clear();
    await _saveToStorage();
    notifyListeners();
  }

  Future<void> restoreAllHistory(List<HistoryItem> items) async {
    await _ensureLoaded();
    _history
      ..clear()
      ..addAll(items);
    await _saveToStorage();
    notifyListeners();
  }

  Future<void> _saveToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, HistoryItem.encode(_history));
  }
}
