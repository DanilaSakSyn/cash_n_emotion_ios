import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/transaction_provider.dart';
import '../providers/theme_provider.dart';
import '../constants/app_colors.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  TransactionType _selectedType = TransactionType.expense;
  Category? _selectedCategory;
  EmotionLevel _selectedEmotion = EmotionLevel.neutral;
  DateTime _selectedDate = DateTime.now();
  String? _emotionNote;

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveTransaction() {
    if (_amountController.text.isEmpty || _selectedCategory == null) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Error'),
          content: const Text('Please fill in amount and select category'),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
      return;
    }

    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Error'),
          content: const Text('Please enter a valid amount'),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
      return;
    }

    final transaction = Transaction(
      id: TransactionProvider.generateId(),
      amount: amount,
      category: _selectedCategory!,
      emotion: Emotion(level: _selectedEmotion, note: _emotionNote),
      description: _descriptionController.text.isEmpty
          ? null
          : _descriptionController.text,
      date: _selectedDate,
      createdAt: DateTime.now(),
    );

    Provider.of<TransactionProvider>(
      context,
      listen: false,
    ).addTransaction(transaction);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final transactionProvider = Provider.of<TransactionProvider>(context);

    final availableCategories = transactionProvider.categories
        .where((c) => c.type == _selectedType)
        .toList();

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          'Add Transaction',
          style: TextStyle(
            color: isDark ? AppColors.lightCard : AppColors.lightText1,
          ),
        ),
        backgroundColor: AppColors.getNavBarColor(isDark),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(
            CupertinoIcons.back,
            color: isDark ? AppColors.lightCard : AppColors.lightText1,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Text(
            'Save',
            style: TextStyle(
              color: isDark ? AppColors.lightCard : AppColors.lightText1,
            ),
          ),
          onPressed: _saveTransaction,
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
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Transaction Type Selector
              Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2A1A4A) : AppColors.lightCard,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CupertinoSegmentedControl<TransactionType>(
                  padding: const EdgeInsets.all(8),
                  groupValue: _selectedType,
                  selectedColor: isDark
                      ? const Color(0xFF9C27B0)
                      : AppColors.lightPrimary,
                  unselectedColor: isDark
                      ? const Color(0xFF2A1A4A)
                      : AppColors.lightCard,
                  children: {
                    TransactionType.expense: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Text(
                        'Expense',
                        style: TextStyle(
                          color: isDark
                              ? const Color(0xFFE1BEE7)
                              : AppColors.lightText1,
                        ),
                      ),
                    ),
                    TransactionType.income: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Text(
                        'Income',
                        style: TextStyle(
                          color: isDark
                              ? const Color(0xFFE1BEE7)
                              : AppColors.lightText1,
                        ),
                      ),
                    ),
                  },
                  onValueChanged: (value) {
                    setState(() {
                      _selectedType = value;
                      _selectedCategory = null;
                    });
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Amount Input
              _buildSection(
                isDark,
                'Amount',
                CupertinoTextField(
                  controller: _amountController,
                  placeholder: '0.00',
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  prefix: Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(
                      '\$',
                      style: TextStyle(
                        fontSize: 20,
                        color: isDark
                            ? const Color(0xFFE1BEE7)
                            : AppColors.lightText1,
                      ),
                    ),
                  ),
                  style: TextStyle(
                    fontSize: 20,
                    color: isDark
                        ? const Color(0xFFE1BEE7)
                        : AppColors.lightText1,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF2A1A4A)
                        : AppColors.lightCard,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(16),
                ),
              ),
              const SizedBox(height: 24),

              // Category Selection
              _buildSection(
                isDark,
                'Category',
                Column(
                  children: [
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: availableCategories.map((category) {
                        final isSelected = _selectedCategory?.id == category.id;
                        return GestureDetector(
                          onTap: () =>
                              setState(() => _selectedCategory = category),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              gradient: isSelected
                                  ? LinearGradient(
                                      colors: isDark
                                          ? [
                                              const Color(0xFF9C27B0),
                                              const Color(0xFF7B2CBF),
                                            ]
                                          : [
                                              AppColors.lightGradient1,
                                              AppColors.lightPrimary,
                                            ],
                                    )
                                  : null,
                              color: isSelected
                                  ? null
                                  : (isDark
                                        ? const Color(0xFF2A1A4A)
                                        : AppColors.lightCard),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? CupertinoColors.transparent
                                    : (isDark
                                          ? const Color(0xFF3A2A5A)
                                          : AppColors.lightBackground1),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  category.icon,
                                  size: 20,
                                  color: isSelected
                                      ? AppColors.lightCard
                                      : (isDark
                                            ? const Color(0xFFE1BEE7)
                                            : AppColors.lightText1),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  category.name,
                                  style: TextStyle(
                                    color: isSelected
                                        ? AppColors.lightCard
                                        : (isDark
                                              ? const Color(0xFFE1BEE7)
                                              : AppColors.lightText1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Emotion Selection
              _buildSection(
                isDark,
                'How do you feel about this?',
                Column(
                  children: EmotionLevel.values.map((emotion) {
                    final isSelected = _selectedEmotion == emotion;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedEmotion = emotion),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: isSelected
                              ? LinearGradient(
                                  colors: isDark
                                      ? [
                                          const Color(0xFF9C27B0),
                                          const Color(0xFF7B2CBF),
                                        ]
                                      : [
                                          AppColors.lightGradient1,
                                          AppColors.lightPrimary,
                                        ],
                                )
                              : null,
                          color: isSelected
                              ? null
                              : (isDark
                                    ? const Color(0xFF2A1A4A)
                                    : AppColors.lightCard),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Text(
                              emotion.emoji,
                              style: const TextStyle(fontSize: 24),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              emotion.label,
                              style: TextStyle(
                                fontSize: 16,
                                color: isSelected
                                    ? AppColors.lightCard
                                    : (isDark
                                          ? const Color(0xFFE1BEE7)
                                          : AppColors.lightText1),
                              ),
                            ),
                            const Spacer(),
                            if (isSelected)
                              const Icon(
                                CupertinoIcons.check_mark_circled_solid,
                                color: AppColors.lightCard,
                              ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 24),

              // Description
              _buildSection(
                isDark,
                'Description (Optional)',
                CupertinoTextField(
                  controller: _descriptionController,
                  placeholder: 'Add a note...',
                  maxLines: 3,
                  style: TextStyle(
                    color: isDark
                        ? const Color(0xFFE1BEE7)
                        : AppColors.lightText1,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF2A1A4A)
                        : AppColors.lightCard,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(16),
                ),
              ),
              const SizedBox(height: 24),

              // Date Selector
              _buildSection(
                isDark,
                'Date',
                GestureDetector(
                  onTap: () {
                    showCupertinoModalPopup(
                      context: context,
                      builder: (context) => Container(
                        height: 250,
                        color: isDark
                            ? const Color(0xFF2A1A4A)
                            : CupertinoColors.white,
                        child: CupertinoDatePicker(
                          mode: CupertinoDatePickerMode.date,
                          initialDateTime: _selectedDate,
                          onDateTimeChanged: (date) {
                            setState(() => _selectedDate = date);
                          },
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF2A1A4A)
                          : AppColors.lightCard,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          CupertinoIcons.calendar,
                          color: isDark
                              ? const Color(0xFFE1BEE7)
                              : AppColors.lightText1,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                          style: TextStyle(
                            fontSize: 16,
                            color: isDark
                                ? const Color(0xFFE1BEE7)
                                : AppColors.lightText1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(bool isDark, String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? const Color(0xFFE1BEE7) : AppColors.lightText1,
            ),
          ),
        ),
        child,
      ],
    );
  }
}
