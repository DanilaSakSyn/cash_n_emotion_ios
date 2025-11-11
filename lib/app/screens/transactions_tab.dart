import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/transaction_provider.dart';
import '../models/models.dart';
import '../constants/app_colors.dart';
import 'add_transaction_screen.dart';
import 'package:intl/intl.dart';

class TransactionsTab extends StatelessWidget {
  const TransactionsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final transactionProvider = Provider.of<TransactionProvider>(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          'Transactions',
          style: TextStyle(
            color: isDark ? AppColors.lightCard : AppColors.lightText1,
          ),
        ),
        backgroundColor: AppColors.getNavBarColor(isDark),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(
            CupertinoIcons.add,
            color: isDark ? AppColors.lightCard : AppColors.lightText1,
          ),
          onPressed: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => const AddTransactionScreen(),
              ),
            );
          },
        ),
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
          child: transactionProvider.isLoading
              ? const Center(child: CupertinoActivityIndicator())
              : transactionProvider.transactions.isEmpty
              ? _buildEmptyState(isDark)
              : _buildTransactionsList(isDark, transactionProvider),
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
              CupertinoIcons.list_bullet,
              size: 80,
              color: AppColors.lightCard,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No transactions yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: isDark ? const Color(0xFFE1BEE7) : AppColors.lightText1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap + to add your first transaction',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? AppColors.darkText2 : AppColors.lightPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsList(bool isDark, TransactionProvider provider) {
    // Group transactions by date
    final groupedTransactions = <String, List<Transaction>>{};
    final dateFormat = DateFormat('MMMM d, yyyy');

    for (final transaction in provider.transactions) {
      final dateKey = dateFormat.format(transaction.date);
      groupedTransactions.putIfAbsent(dateKey, () => []).add(transaction);
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Summary Card
        Container(
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
                  _buildSummaryItem('Income', provider.totalIncome, true),
                  _buildSummaryItem('Expenses', provider.totalExpenses, false),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.lightCard.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Balance: ',
                      style: TextStyle(
                        color: AppColors.lightCard,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '\$${provider.balance.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: AppColors.lightCard,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Transactions List
        ...groupedTransactions.entries.map((entry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 8, top: 8),
                child: Text(
                  entry.key,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? const Color(0xFFE1BEE7)
                        : AppColors.lightText1,
                  ),
                ),
              ),
              ...entry.value.map((transaction) {
                return _buildTransactionItem(isDark, transaction, provider);
              }),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildSummaryItem(String label, double amount, bool isIncome) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.lightCard, fontSize: 14),
        ),
        const SizedBox(height: 4),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: const TextStyle(
            color: AppColors.lightCard,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionItem(
    bool isDark,
    Transaction transaction,
    TransactionProvider provider,
  ) {
    return Builder(
      builder: (context) => Container(
        margin: const EdgeInsets.only(bottom: 8),
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
        child: CupertinoContextMenu(
          actions: [
            CupertinoContextMenuAction(
              isDestructiveAction: true,
              trailingIcon: CupertinoIcons.delete,
              child: const Text('Delete'),
              onPressed: () {
                Navigator.pop(context);
                provider.deleteTransaction(transaction.id);
              },
            ),
          ],
          child: Padding(
            padding: const EdgeInsets.all(16),
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
                // Transaction Details
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
          ),
        ),
      ),
    );
  }
}
