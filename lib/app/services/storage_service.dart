import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

class StorageService {
  static const String _transactionsKey = 'transactions';
  static const String _categoriesKey = 'categories';
  static const String _firstLaunchKey = 'first_launch';

  Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_firstLaunchKey) ?? true;
  }

  Future<void> setFirstLaunchComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_firstLaunchKey, false);
  }

  Future<void> saveTransactions(List<Transaction> transactions) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = transactions.map((t) => t.toJson()).toList();
    await prefs.setString(_transactionsKey, jsonEncode(jsonList));
  }

  Future<List<Transaction>> loadTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_transactionsKey);

    if (jsonString == null) return [];

    final jsonList = jsonDecode(jsonString) as List;
    return jsonList
        .map((json) => Transaction.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveCategories(List<Category> categories) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = categories.map((c) => c.toJson()).toList();
    await prefs.setString(_categoriesKey, jsonEncode(jsonList));
  }

  Future<List<Category>> loadCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_categoriesKey);

    if (jsonString == null) {
      // Return default categories if none saved
      return DefaultCategories.all;
    }

    final jsonList = jsonDecode(jsonString) as List;
    return jsonList
        .map((json) => Category.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_transactionsKey);
    await prefs.remove(_categoriesKey);
  }
}
