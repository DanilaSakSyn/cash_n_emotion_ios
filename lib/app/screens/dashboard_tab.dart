import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/theme_provider.dart';
import '../providers/transaction_provider.dart';
import '../models/models.dart';
import '../constants/app_colors.dart';
import 'add_transaction_screen.dart';

class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final transactionProvider = Provider.of<TransactionProvider>(context);

    // Calculate today's statistics
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
    final todayStats = transactionProvider.getStatistics(startOfDay, endOfDay);

    // Get last 5 transactions
    final recentTransactions = transactionProvider.transactions
        .take(5)
        .toList();

    // Calculate overall average emotion
    final allTransactions = transactionProvider.transactions;
    final avgEmotion = allTransactions.isEmpty
        ? 0.0
        : allTransactions.fold<double>(
                0.0,
                (sum, t) => sum + t.emotion.level.value,
              ) /
              allTransactions.length;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          'Dashboard',
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
          child: allTransactions.isEmpty
              ? _buildEmptyState(context, isDark)
              : _buildDashboard(
                  context,
                  isDark,
                  todayStats,
                  recentTransactions,
                  avgEmotion,
                  transactionProvider,
                ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isDark) {
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
              CupertinoIcons.square_grid_2x2,
              size: 80,
              color: AppColors.lightCard,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Start Tracking',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: isDark ? const Color(0xFFE1BEE7) : AppColors.lightText1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first transaction',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? AppColors.darkText2 : AppColors.lightPrimary,
            ),
          ),
          const SizedBox(height: 24),
          _buildQuickAddButton(context, isDark),
        ],
      ),
    );
  }

  Widget _buildDashboard(
    BuildContext context,
    bool isDark,
    PeriodStatistics todayStats,
    List<Transaction> recentTransactions,
    double avgEmotion,
    TransactionProvider provider,
  ) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Quick Add Button at top
        _buildQuickAddButton(context, isDark),
        const SizedBox(height: 16),

        // Average Emotion Card
        _buildAverageEmotionCard(
          isDark,
          avgEmotion,
          provider.transactions.length,
        ),
        const SizedBox(height: 16),

        // Today's Summary
        _buildTodaysSummary(isDark, todayStats),
        const SizedBox(height: 16),

        // Recent Transactions
        if (recentTransactions.isNotEmpty) ...[
          _buildSectionTitle(isDark, 'Recent Transactions'),
          const SizedBox(height: 12),
          ...recentTransactions.map((transaction) {
            return _buildTransactionItem(isDark, transaction);
          }),
        ],
      ],
    );
  }

  Widget _buildQuickAddButton(BuildContext context, bool isDark) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (context) => const AddTransactionScreen(),
            fullscreenDialog: true,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              CupertinoIcons.add_circled_solid,
              color: AppColors.lightCard,
              size: 28,
            ),
            SizedBox(width: 12),
            Text(
              'Quick Add Transaction',
              style: TextStyle(
                color: AppColors.lightCard,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAverageEmotionCard(
    bool isDark,
    double avgEmotion,
    int transactionCount,
  ) {
    final emotionLevel = avgEmotion > 0
        ? EmotionLevel.fromValue(avgEmotion.round().clamp(1, 5))
        : EmotionLevel.neutral;

    return Container(
      padding: const EdgeInsets.all(24),
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
        children: [
          Text(
            'Your Financial Mood',
            style: TextStyle(
              fontSize: 16,
              color: isDark ? AppColors.darkText2 : AppColors.lightPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Text(emotionLevel.emoji, style: const TextStyle(fontSize: 80)),
          const SizedBox(height: 12),
          Text(
            emotionLevel.label,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDark ? const Color(0xFFE1BEE7) : AppColors.lightText1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Average: ${avgEmotion.toStringAsFixed(1)} / 5.0',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? AppColors.darkText2 : AppColors.lightPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Based on $transactionCount transactions',
            style: TextStyle(
              fontSize: 12,
              color: isDark ? AppColors.darkText2 : AppColors.lightPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodaysSummary(bool isDark, PeriodStatistics todayStats) {
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
            'Today\'s Summary',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark ? const Color(0xFFE1BEE7) : AppColors.lightText1,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  isDark,
                  'Income',
                  todayStats.totalIncome,
                  CupertinoIcons.arrow_down_circle_fill,
                  CupertinoColors.systemGreen,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryItem(
                  isDark,
                  'Expenses',
                  todayStats.totalExpenses,
                  CupertinoIcons.arrow_up_circle_fill,
                  CupertinoColors.systemRed,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF3A2A5A)
                  : AppColors.lightBackground1,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Balance',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? const Color(0xFFE1BEE7)
                        : AppColors.lightText1,
                  ),
                ),
                Text(
                  '\$${todayStats.balance.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: todayStats.balance >= 0
                        ? CupertinoColors.systemGreen
                        : CupertinoColors.systemRed,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(
    bool isDark,
    String label,
    double amount,
    IconData icon,
    Color iconColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF3A2A5A) : AppColors.lightBackground1,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 16),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? AppColors.darkText2
                        : AppColors.lightPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? const Color(0xFFE1BEE7) : AppColors.lightText1,
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

  Widget _buildTransactionItem(bool isDark, Transaction transaction) {
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
          // Category Icon
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: transaction.category.color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              transaction.category.icon,
              color: transaction.category.color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          // Transaction Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        transaction.category.name,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? const Color(0xFFE1BEE7)
                              : AppColors.lightText1,
                        ),
                      ),
                    ),
                    Text(
                      transaction.emotion.level.emoji,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                if (transaction.description != null &&
                    transaction.description!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    transaction.description!,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? AppColors.darkText2
                          : AppColors.lightPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 4),
                Text(
                  DateFormat('MMM dd, HH:mm').format(transaction.date),
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark
                        ? AppColors.darkText2
                        : AppColors.lightPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Amount
          Text(
            '${transaction.isExpense ? '-' : '+'}\$${transaction.amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: transaction.isExpense
                  ? CupertinoColors.systemRed
                  : CupertinoColors.systemGreen,
            ),
          ),
        ],
      ),
    );
  }
}
