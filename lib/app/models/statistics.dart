import 'package:drop_cost_ios/app/models/category.dart';
import 'package:drop_cost_ios/app/models/emotion.dart';
import 'package:drop_cost_ios/app/models/transaction.dart';

class CategoryStatistics {
  final Category category;
  final double totalAmount;
  final int transactionCount;
  final double averageEmotion;
  final List<Transaction> transactions;

  const CategoryStatistics({
    required this.category,
    required this.totalAmount,
    required this.transactionCount,
    required this.averageEmotion,
    required this.transactions,
  });

  double get percentage => 0.0; // Will be calculated in context
}

class EmotionStatistics {
  final EmotionLevel level;
  final int count;
  final double totalAmount;
  final List<Transaction> transactions;

  const EmotionStatistics({
    required this.level,
    required this.count,
    required this.totalAmount,
    required this.transactions,
  });

  double get averageAmount => count > 0 ? totalAmount / count : 0.0;
}

class PeriodStatistics {
  final DateTime startDate;
  final DateTime endDate;
  final double totalIncome;
  final double totalExpenses;
  final int incomeCount;
  final int expenseCount;
  final double averageEmotionExpense;
  final double averageEmotionIncome;
  final List<CategoryStatistics> categoryStats;
  final List<EmotionStatistics> emotionStats;

  const PeriodStatistics({
    required this.startDate,
    required this.endDate,
    required this.totalIncome,
    required this.totalExpenses,
    required this.incomeCount,
    required this.expenseCount,
    required this.averageEmotionExpense,
    required this.averageEmotionIncome,
    required this.categoryStats,
    required this.emotionStats,
  });

  double get balance => totalIncome - totalExpenses;
  double get savingsRate =>
      totalIncome > 0 ? ((totalIncome - totalExpenses) / totalIncome) * 100 : 0;
  int get totalTransactions => incomeCount + expenseCount;

  static PeriodStatistics fromTransactions(
    List<Transaction> transactions,
    DateTime startDate,
    DateTime endDate,
  ) {
    final expenses = transactions.where((t) => t.isExpense).toList();
    final income = transactions.where((t) => t.isIncome).toList();

    // Calculate totals
    final totalExpenses = expenses.fold<double>(
      0.0,
      (sum, t) => sum + t.amount,
    );
    final totalIncome = income.fold<double>(0.0, (sum, t) => sum + t.amount);

    // Calculate average emotions
    final avgEmotionExpense = expenses.isEmpty
        ? 0.0
        : expenses.fold<double>(0.0, (sum, t) => sum + t.emotion.level.value) /
            expenses.length;
    final avgEmotionIncome = income.isEmpty
        ? 0.0
        : income.fold<double>(0.0, (sum, t) => sum + t.emotion.level.value) /
            income.length;

    // Category statistics
    final categoryMap = <String, List<Transaction>>{};
    for (final transaction in transactions) {
      final categoryId = transaction.category.id;
      categoryMap.putIfAbsent(categoryId, () => []).add(transaction);
    }

    final categoryStats = categoryMap.entries.map((entry) {
      final categoryTransactions = entry.value;
      final totalAmount = categoryTransactions.fold<double>(
        0.0,
        (sum, t) => sum + t.amount,
      );
      final avgEmotion = categoryTransactions.fold<double>(
            0.0,
            (sum, t) => sum + t.emotion.level.value,
          ) /
          categoryTransactions.length;

      return CategoryStatistics(
        category: categoryTransactions.first.category,
        totalAmount: totalAmount,
        transactionCount: categoryTransactions.length,
        averageEmotion: avgEmotion,
        transactions: categoryTransactions,
      );
    }).toList();

    // Emotion statistics
    final emotionMap = <EmotionLevel, List<Transaction>>{};
    for (final transaction in transactions) {
      final level = transaction.emotion.level;
      emotionMap.putIfAbsent(level, () => []).add(transaction);
    }

    final emotionStats = emotionMap.entries.map((entry) {
      final emotionTransactions = entry.value;
      final totalAmount = emotionTransactions.fold<double>(
        0.0,
        (sum, t) => sum + t.amount,
      );

      return EmotionStatistics(
        level: entry.key,
        count: emotionTransactions.length,
        totalAmount: totalAmount,
        transactions: emotionTransactions,
      );
    }).toList();

    // Sort by emotion level
    emotionStats.sort((a, b) => a.level.value.compareTo(b.level.value));

    return PeriodStatistics(
      startDate: startDate,
      endDate: endDate,
      totalIncome: totalIncome,
      totalExpenses: totalExpenses,
      incomeCount: income.length,
      expenseCount: expenses.length,
      averageEmotionExpense: avgEmotionExpense,
      averageEmotionIncome: avgEmotionIncome,
      categoryStats: categoryStats,
      emotionStats: emotionStats,
    );
  }
}
