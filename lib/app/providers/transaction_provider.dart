import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';
import '../models/models.dart';
import '../services/storage_service.dart';

class TransactionProvider extends ChangeNotifier {
  final StorageService _storageService = StorageService();
  List<Transaction> _transactions = [];
  List<Category> _categories = [];
  bool _isLoading = false;

  List<Transaction> get transactions => _transactions;
  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;

  List<Transaction> get expenses =>
      _transactions.where((t) => t.isExpense).toList();
  List<Transaction> get income =>
      _transactions.where((t) => t.isIncome).toList();

  double get totalExpenses =>
      expenses.fold(0.0, (sum, transaction) => sum + transaction.amount);
  double get totalIncome =>
      income.fold(0.0, (sum, transaction) => sum + transaction.amount);
  double get balance => totalIncome - totalExpenses;

  TransactionProvider() {
    loadData();
  }

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _transactions = await _storageService.loadTransactions();
      _categories = await _storageService.loadCategories();

      // Sort transactions by date (newest first)
      _transactions.sort((a, b) => b.date.compareTo(a.date));
    } catch (e) {
      debugPrint('Error loading data: $e');
      _categories = DefaultCategories.all;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTransaction(Transaction transaction) async {
    _transactions.insert(0, transaction);
    await _saveTransactions();
    notifyListeners();
  }

  Future<void> updateTransaction(Transaction transaction) async {
    final index = _transactions.indexWhere((t) => t.id == transaction.id);
    if (index != -1) {
      _transactions[index] = transaction.copyWith(updatedAt: DateTime.now());
      await _saveTransactions();
      notifyListeners();
    }
  }

  Future<void> deleteTransaction(String id) async {
    _transactions.removeWhere((t) => t.id == id);
    await _saveTransactions();
    notifyListeners();
  }

  Future<void> _saveTransactions() async {
    try {
      await _storageService.saveTransactions(_transactions);
    } catch (e) {
      debugPrint('Error saving transactions: $e');
    }
  }

  List<Transaction> getTransactionsByDateRange(DateTime start, DateTime end) {
    return _transactions.where((t) {
      return t.date.isAfter(start.subtract(const Duration(days: 1))) &&
          t.date.isBefore(end.add(const Duration(days: 1)));
    }).toList();
  }

  PeriodStatistics getStatistics(DateTime start, DateTime end) {
    final periodTransactions = getTransactionsByDateRange(start, end);
    return PeriodStatistics.fromTransactions(periodTransactions, start, end);
  }

  Category? getCategoryById(String id) {
    try {
      return _categories.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  static String generateId() {
    return const Uuid().v4();
  }
}
