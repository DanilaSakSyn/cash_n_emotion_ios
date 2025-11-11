import 'package:drop_cost_ios/app/models/category.dart';
import 'package:drop_cost_ios/app/models/emotion.dart';

class Transaction {
  final String id;
  final double amount;
  final Category category;
  final Emotion emotion;
  final String? description;
  final DateTime date;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Transaction({
    required this.id,
    required this.amount,
    required this.category,
    required this.emotion,
    this.description,
    required this.date,
    required this.createdAt,
    this.updatedAt,
  });

  bool get isExpense => category.type == TransactionType.expense;
  bool get isIncome => category.type == TransactionType.income;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'category': category.toJson(),
      'emotion': emotion.toJson(),
      'description': description,
      'date': date.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as String,
      amount: (json['amount'] as num).toDouble(),
      category: Category.fromJson(json['category'] as Map<String, dynamic>),
      emotion: Emotion.fromJson(json['emotion'] as Map<String, dynamic>),
      description: json['description'] as String?,
      date: DateTime.parse(json['date'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Transaction copyWith({
    String? id,
    double? amount,
    Category? category,
    Emotion? emotion,
    String? description,
    DateTime? date,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Transaction(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      emotion: emotion ?? this.emotion,
      description: description ?? this.description,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Transaction && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Transaction(id: $id, amount: $amount, category: ${category.name}, emotion: ${emotion.level.label}, date: $date)';
  }
}
