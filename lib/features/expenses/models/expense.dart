import '../../../core/utils/app_clock.dart';
import 'payment_method.dart';
import 'app_currency.dart';
import 'expense_category.dart';
import 'transaction_type.dart';

class Expense {
  const Expense({
    required this.id,
    required this.type,
    required this.amount,
    required this.category,
    required this.memo,
    required this.date,
    required this.currency,
    required this.createdAt,
    required this.updatedAt,
    this.paymentMethod,
  });

  factory Expense.create({
    required TransactionType type,
    required double amount,
    required ExpenseCategory category,
    required DateTime date,
    required AppCurrency currency,
    PaymentMethod? paymentMethod,
    String? memo,
  }) {
    final now = AppClock.now();

    return Expense(
      id: 'record_${now.microsecondsSinceEpoch}',
      type: type,
      amount: amount,
      category: category,
      memo: _normalizeMemo(memo),
      date: date,
      currency: currency,
      createdAt: now,
      updatedAt: now,
      paymentMethod: paymentMethod,
    );
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'] as String? ?? '',
      type: transactionTypeFromStorage(map['type'] as String?),
      amount: (map['amount'] as num?)?.toDouble() ?? 0,
      category: expenseCategoryFromStorage(map['category'] as String?),
      memo: _normalizeMemo(map['memo'] as String?),
      date: DateTime.tryParse(map['date'] as String? ?? '') ?? AppClock.now(),
      currency: appCurrencyFromStorage(map['currency'] as String?),
      createdAt:
          DateTime.tryParse(map['createdAt'] as String? ?? '') ??
          AppClock.now(),
      updatedAt:
          DateTime.tryParse(map['updatedAt'] as String? ?? '') ??
          AppClock.now(),
      paymentMethod: paymentMethodFromStorage(map['paymentMethod'] as String?),
    );
  }

  final String id;
  final TransactionType type;
  final double amount;
  final ExpenseCategory category;
  final String? memo;
  final DateTime date;
  final AppCurrency currency;
  final DateTime createdAt;
  final DateTime updatedAt;
  final PaymentMethod? paymentMethod;

  bool get isExpense => type.isExpense;
  bool get isIncome => type.isIncome;

  double get amountInBaseCurrency => currency.toBaseAmount(amount);

  double amountForCurrency(AppCurrency displayCurrency) {
    return displayCurrency.fromBaseAmount(amountInBaseCurrency);
  }

  Expense copyWith({
    String? id,
    TransactionType? type,
    double? amount,
    ExpenseCategory? category,
    String? memo,
    DateTime? date,
    AppCurrency? currency,
    DateTime? createdAt,
    DateTime? updatedAt,
    PaymentMethod? paymentMethod,
  }) {
    return Expense(
      id: id ?? this.id,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      memo: memo ?? this.memo,
      date: date ?? this.date,
      currency: currency ?? this.currency,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.name,
      'amount': amount,
      'category': category.name,
      'memo': memo,
      'date': date.toIso8601String(),
      'currency': currency.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'paymentMethod': paymentMethod?.name,
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
