import '../../../core/utils/app_date_utils.dart';
import '../../expenses/models/app_currency.dart';

class MonthlyBudget {
  const MonthlyBudget({
    required this.monthKey,
    required this.amountInBaseCurrency,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MonthlyBudget.fromMap(Map<String, dynamic> map) {
    return MonthlyBudget(
      monthKey: map['monthKey'] as String? ?? '',
      amountInBaseCurrency:
          (map['amountInBaseCurrency'] as num?)?.toDouble() ?? 0,
      createdAt:
          DateTime.tryParse(map['createdAt'] as String? ?? '') ??
          DateTime.now(),
      updatedAt:
          DateTime.tryParse(map['updatedAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  final String monthKey;
  final double amountInBaseCurrency;
  final DateTime createdAt;
  final DateTime updatedAt;

  DateTime get month => AppDateUtils.monthFromKey(monthKey);

  double amountForCurrency(AppCurrency currency) {
    return currency.fromBaseAmount(amountInBaseCurrency);
  }

  MonthlyBudget copyWith({
    String? monthKey,
    double? amountInBaseCurrency,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MonthlyBudget(
      monthKey: monthKey ?? this.monthKey,
      amountInBaseCurrency: amountInBaseCurrency ?? this.amountInBaseCurrency,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'monthKey': monthKey,
      'amountInBaseCurrency': amountInBaseCurrency,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
