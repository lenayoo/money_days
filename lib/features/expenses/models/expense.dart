import 'app_currency.dart';
import 'expense_category.dart';

class Expense {
  const Expense({
    required this.id,
    required this.amount,
    required this.category,
    required this.memo,
    required this.date,
    required this.currency,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Expense.create({
    required double amount,
    required ExpenseCategory category,
    required DateTime date,
    required AppCurrency currency,
    String? memo,
  }) {
    final now = DateTime.now();

    return Expense(
      id: 'expense_${now.microsecondsSinceEpoch}',
      amount: amount,
      category: category,
      memo: _normalizeMemo(memo),
      date: date,
      currency: currency,
      createdAt: now,
      updatedAt: now,
    );
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'] as String? ?? '',
      amount: (map['amount'] as num?)?.toDouble() ?? 0,
      category: expenseCategoryFromStorage(map['category'] as String?),
      memo: _normalizeMemo(map['memo'] as String?),
      date: DateTime.tryParse(map['date'] as String? ?? '') ?? DateTime.now(),
      currency: appCurrencyFromStorage(map['currency'] as String?),
      createdAt:
          DateTime.tryParse(map['createdAt'] as String? ?? '') ??
          DateTime.now(),
      updatedAt:
          DateTime.tryParse(map['updatedAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  final String id;
  final double amount;
  final ExpenseCategory category;
  final String? memo;
  final DateTime date;
  final AppCurrency currency;
  final DateTime createdAt;
  final DateTime updatedAt;

  Expense copyWith({
    String? id,
    double? amount,
    ExpenseCategory? category,
    String? memo,
    DateTime? date,
    AppCurrency? currency,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Expense(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      memo: memo ?? this.memo,
      date: date ?? this.date,
      currency: currency ?? this.currency,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'category': category.name,
      'memo': memo,
      'date': date.toIso8601String(),
      'currency': currency.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  static String? _normalizeMemo(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }
}
