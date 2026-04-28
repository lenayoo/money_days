import '../../../core/utils/app_date_utils.dart';
import '../../expenses/models/app_currency.dart';

class MonthlyBudget {
  static const String _baseCurrencyKey = 'baseCurrency';
  static const String _usdBaseCurrencyStorageValue = 'usd';
  static const String _enteredAmountKey = 'enteredAmount';
  static const String _enteredCurrencyKey = 'enteredCurrency';

  const MonthlyBudget({
    required this.monthKey,
    required this.amountInBaseCurrency,
    required this.createdAt,
    required this.updatedAt,
    this.enteredAmount,
    this.enteredCurrency,
  });

  factory MonthlyBudget.fromMap(Map<String, dynamic> map) {
    final rawAmountInBaseCurrency =
        (map['amountInBaseCurrency'] as num?)?.toDouble() ?? 0;
    final storageBaseCurrency =
        (map[_baseCurrencyKey] as String?)?.toLowerCase();
    final enteredAmount = (map[_enteredAmountKey] as num?)?.toDouble();
    final enteredCurrency = appCurrencyFromStorage(
      map[_enteredCurrencyKey] as String?,
    );

    return MonthlyBudget(
      monthKey: map['monthKey'] as String? ?? '',
      amountInBaseCurrency:
          enteredAmount != null && map[_enteredCurrencyKey] != null
              ? enteredCurrency.toBaseAmount(enteredAmount)
              : storageBaseCurrency == _usdBaseCurrencyStorageValue
              ? rawAmountInBaseCurrency
              : AppCurrency.jpy.toBaseAmount(rawAmountInBaseCurrency),
      createdAt:
          DateTime.tryParse(map['createdAt'] as String? ?? '') ??
          DateTime.now(),
      updatedAt:
          DateTime.tryParse(map['updatedAt'] as String? ?? '') ??
          DateTime.now(),
      enteredAmount: enteredAmount,
      enteredCurrency:
          enteredAmount != null && map[_enteredCurrencyKey] != null
              ? enteredCurrency
              : null,
    );
  }

  final String monthKey;
  final double amountInBaseCurrency;
  final DateTime createdAt;
  final DateTime updatedAt;
  final double? enteredAmount;
  final AppCurrency? enteredCurrency;

  DateTime get month => AppDateUtils.monthFromKey(monthKey);

  double amountForCurrency(AppCurrency currency) {
    return currency.fromBaseAmount(amountInBaseCurrency);
  }

  MonthlyBudget copyWith({
    String? monthKey,
    double? amountInBaseCurrency,
    DateTime? createdAt,
    DateTime? updatedAt,
    double? enteredAmount,
    AppCurrency? enteredCurrency,
  }) {
    return MonthlyBudget(
      monthKey: monthKey ?? this.monthKey,
      amountInBaseCurrency: amountInBaseCurrency ?? this.amountInBaseCurrency,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      enteredAmount: enteredAmount ?? this.enteredAmount,
      enteredCurrency: enteredCurrency ?? this.enteredCurrency,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'monthKey': monthKey,
      'amountInBaseCurrency': amountInBaseCurrency,
      _baseCurrencyKey: _usdBaseCurrencyStorageValue,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };

    if (enteredAmount != null && enteredCurrency != null) {
      map[_enteredAmountKey] = enteredAmount;
      map[_enteredCurrencyKey] = enteredCurrency!.name;
    }

    return map;
  }
}
