import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/transaction_provider.dart';
import '../models/models.dart';
import '../constants/app_colors.dart';

class StatisticsTab extends StatelessWidget {
  const StatisticsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final transactionProvider = Provider.of<TransactionProvider>(context);

    // Calculate current month statistics
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

    final stats = transactionProvider.getStatistics(startOfMonth, endOfMonth);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          'Statistics',
          style: TextStyle(
            color: isDark ? AppColors.lightCard : AppColors.lightText1,
          ),
        ),
        backgroundColor: AppColors.getNavBarColor(isDark),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.getBackgroundGradient(isDark),
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: transactionProvider.transactions.isEmpty
              ? _buildEmptyState(isDark)
              : _buildStatistics(isDark, stats, transactionProvider),
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF9C27B0), const Color(0xFF7B2CBF)]
                    : [AppColors.lightGradient1, AppColors.lightPrimary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? const Color(0xFF9C27B0).withOpacity(0.4)
                      : AppColors.lightShadow,
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Icon(
              CupertinoIcons.chart_bar,
              size: 80,
              color: AppColors.lightCard,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No data yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: isDark ? const Color(0xFFE1BEE7) : AppColors.lightText1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add transactions to see statistics',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? AppColors.darkText2 : AppColors.lightPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatistics(
    bool isDark,
    PeriodStatistics stats,
    TransactionProvider provider,
  ) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Period Title
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            'This Month',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDark ? const Color(0xFFE1BEE7) : AppColors.lightText1,
            ),
          ),
        ),

        // Balance Overview
        _buildBalanceCard(isDark, stats),
        const SizedBox(height: 16),

        // Average Emotion Card
        _buildAverageEmotionCard(isDark, stats),
        const SizedBox(height: 16),

        // Emotion Distribution
        _buildEmotionDistribution(isDark, stats),
        const SizedBox(height: 16),

        // Category Breakdown
        if (stats.categoryStats.isNotEmpty) ...[
          _buildSectionTitle(isDark, 'Top Categories'),
          const SizedBox(height: 12),
          ...stats.categoryStats.take(5).map((catStat) {
            final percentage = stats.totalExpenses > 0
                ? (catStat.totalAmount / stats.totalExpenses) * 100
                : 0.0;
            return _buildCategoryItem(isDark, catStat, percentage);
          }),
        ],
      ],
    );
  }

  Widget _buildBalanceCard(bool isDark, PeriodStatistics stats) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF9C27B0), const Color(0xFF7B2CBF)]
              : [AppColors.lightGradient1, AppColors.lightPrimary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? const Color(0xFF9C27B0).withOpacity(0.4)
                : AppColors.lightShadow,
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBalanceItem(
                'Income',
                stats.totalIncome,
                CupertinoIcons.arrow_down_circle_fill,
              ),
              _buildBalanceItem(
                'Expenses',
                stats.totalExpenses,
                CupertinoIcons.arrow_up_circle_fill,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.lightCard.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Text(
                  'Balance',
                  style: TextStyle(color: AppColors.lightCard, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${stats.balance.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: AppColors.lightCard,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (stats.savingsRate > 0) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Savings Rate: ${stats.savingsRate.toStringAsFixed(1)}%',
                    style: const TextStyle(
                      color: AppColors.lightCard,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceItem(String label, double amount, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.lightCard, size: 16),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(color: AppColors.lightCard, fontSize: 14),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: const TextStyle(
            color: AppColors.lightCard,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildAverageEmotionCard(bool isDark, PeriodStatistics stats) {
    final avgEmotionExpense = stats.averageEmotionExpense;
    final avgEmotionIncome = stats.averageEmotionIncome;

    EmotionLevel getEmotionLevel(double avgValue) {
      return EmotionLevel.fromValue(avgValue.round().clamp(1, 5));
    }

    final expenseEmotion = stats.expenseCount > 0
        ? getEmotionLevel(avgEmotionExpense)
        : null;
    final incomeEmotion = stats.incomeCount > 0
        ? getEmotionLevel(avgEmotionIncome)
        : null;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A1A4A) : AppColors.lightCard,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? const Color(0xFF000000).withOpacity(0.2)
                : AppColors.lightShadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                CupertinoIcons.smiley,
                color: isDark
                    ? const Color(0xFFE1BEE7)
                    : AppColors.lightPrimary,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Average Emotion',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? const Color(0xFFE1BEE7)
                      : AppColors.lightText1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (expenseEmotion != null) ...[
            Row(
              children: [
                Text(
                  expenseEmotion.emoji,
                  style: const TextStyle(fontSize: 32),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Expenses',
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark
                              ? const Color(0xFFCE93D8)
                              : AppColors.lightPrimary,
                        ),
                      ),
                      Text(
                        expenseEmotion.label,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? const Color(0xFFE1BEE7)
                              : AppColors.lightText1,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  avgEmotionExpense.toStringAsFixed(1),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? const Color(0xFFE1BEE7)
                        : AppColors.lightPrimary,
                  ),
                ),
              ],
            ),
          ],
          if (expenseEmotion != null && incomeEmotion != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Container(
                height: 1,
                color: isDark
                    ? const Color(0xFF3A2A5A)
                    : const Color(0xFFD4C5E0),
              ),
            ),
          if (incomeEmotion != null) ...[
            Row(
              children: [
                Text(incomeEmotion.emoji, style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Income',
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark
                              ? const Color(0xFFCE93D8)
                              : AppColors.lightPrimary,
                        ),
                      ),
                      Text(
                        incomeEmotion.label,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? const Color(0xFFE1BEE7)
                              : AppColors.lightText1,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  avgEmotionIncome.toStringAsFixed(1),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? const Color(0xFFE1BEE7)
                        : AppColors.lightPrimary,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmotionDistribution(bool isDark, PeriodStatistics stats) {
    if (stats.emotionStats.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A1A4A) : AppColors.lightCard,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? const Color(0xFF000000).withOpacity(0.2)
                : AppColors.lightShadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Emotion Distribution',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark ? const Color(0xFFE1BEE7) : AppColors.lightText1,
            ),
          ),
          const SizedBox(height: 16),
          ...stats.emotionStats.map((emotionStat) {
            final percentage = stats.totalTransactions > 0
                ? (emotionStat.count / stats.totalTransactions) * 100
                : 0.0;
            return _buildEmotionBar(isDark, emotionStat, percentage);
          }),
        ],
      ),
    );
  }

  Widget _buildEmotionBar(
    bool isDark,
    EmotionStatistics emotionStat,
    double percentage,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                emotionStat.level.emoji,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  emotionStat.level.label,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark
                        ? const Color(0xFFE1BEE7)
                        : AppColors.lightText1,
                  ),
                ),
              ),
              Text(
                '${emotionStat.count} (${percentage.toStringAsFixed(0)}%)',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? const Color(0xFFE1BEE7)
                      : AppColors.lightText1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Stack(
              children: [
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF3A2A5A)
                        : AppColors.lightBackground1,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: percentage / 100,
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF9C27B0)
                          : AppColors.lightPrimary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(bool isDark, String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: isDark ? const Color(0xFFE1BEE7) : AppColors.lightText1,
      ),
    );
  }

  Widget _buildCategoryItem(
    bool isDark,
    CategoryStatistics catStat,
    double percentage,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A1A4A) : AppColors.lightCard,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? const Color(0xFF000000).withOpacity(0.2)
                : AppColors.lightShadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: catStat.category.color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              catStat.category.icon,
              color: catStat.category.color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  catStat.category.name,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? const Color(0xFFE1BEE7)
                        : AppColors.lightText1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${catStat.transactionCount} transactions',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? const Color(0xFFCE93D8)
                        : AppColors.lightPrimary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${catStat.totalAmount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? const Color(0xFFE1BEE7)
                      : AppColors.lightText1,
                ),
              ),
              Text(
                '${percentage.toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark
                      ? const Color(0xFFCE93D8)
                      : AppColors.lightPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
