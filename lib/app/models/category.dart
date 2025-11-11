import 'package:flutter/cupertino.dart';

enum TransactionType {
  expense('Expense'),
  income('Income');

  final String label;
  const TransactionType(this.label);
}

class Category {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final TransactionType type;

  const Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'iconCode': icon.codePoint,
      'colorValue': color.value,
      'type': type.name,
    };
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: IconData(json['iconCode'] as int, fontFamily: 'CupertinoIcons'),
      color: Color(json['colorValue'] as int),
      type: TransactionType.values.firstWhere(
        (type) => type.name == json['type'],
      ),
    );
  }

  Category copyWith({
    String? id,
    String? name,
    IconData? icon,
    Color? color,
    TransactionType? type,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      type: type ?? this.type,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Category && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

// Predefined categories
class DefaultCategories {
  static final List<Category> expenses = [
    const Category(
      id: 'food',
      name: 'Food & Dining',
      icon: CupertinoIcons.cart_fill,
      color: Color(0xFFFF6B6B),
      type: TransactionType.expense,
    ),
    const Category(
      id: 'transport',
      name: 'Transport',
      icon: CupertinoIcons.car_fill,
      color: Color(0xFF4ECDC4),
      type: TransactionType.expense,
    ),
    const Category(
      id: 'shopping',
      name: 'Shopping',
      icon: CupertinoIcons.bag_fill,
      color: Color(0xFFFFBE0B),
      type: TransactionType.expense,
    ),
    const Category(
      id: 'entertainment',
      name: 'Entertainment',
      icon: CupertinoIcons.game_controller_solid,
      color: Color(0xFFFF006E),
      type: TransactionType.expense,
    ),
    const Category(
      id: 'health',
      name: 'Health',
      icon: CupertinoIcons.heart_fill,
      color: Color(0xFF06FFA5),
      type: TransactionType.expense,
    ),
    const Category(
      id: 'bills',
      name: 'Bills & Utilities',
      icon: CupertinoIcons.doc_text_fill,
      color: Color(0xFF8338EC),
      type: TransactionType.expense,
    ),
  ];

  static final List<Category> income = [
    const Category(
      id: 'salary',
      name: 'Salary',
      icon: CupertinoIcons.money_dollar_circle_fill,
      color: Color(0xFF06D6A0),
      type: TransactionType.income,
    ),
    const Category(
      id: 'freelance',
      name: 'Freelance',
      icon: CupertinoIcons.briefcase_fill,
      color: Color(0xFF118AB2),
      type: TransactionType.income,
    ),
    const Category(
      id: 'investment',
      name: 'Investment',
      icon: CupertinoIcons.graph_circle_fill,
      color: Color(0xFFFFD166),
      type: TransactionType.income,
    ),
  ];

  static List<Category> get all => [...expenses, ...income];
}
