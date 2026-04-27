import 'package:money_days/core/localization/generated/app_localizations.dart';

enum AppCurrency { jpy, usd, krw }

extension AppCurrencyX on AppCurrency {
  String get code => switch (this) {
    AppCurrency.jpy => 'JPY',
    AppCurrency.usd => 'USD',
    AppCurrency.krw => 'KRW',
  };

  String get symbol => switch (this) {
    AppCurrency.jpy => '¥',
    AppCurrency.usd => r'$',
    AppCurrency.krw => '₩',
  };

  int get decimalDigits => switch (this) {
    AppCurrency.usd => 2,
    AppCurrency.jpy || AppCurrency.krw => 0,
  };

  String label(AppLocalizations l10n) => switch (this) {
    AppCurrency.jpy => l10n.currencyJpy,
    AppCurrency.usd => l10n.currencyUsd,
    AppCurrency.krw => l10n.currencyKrw,
  };
}

AppCurrency appCurrencyFromStorage(String? value) {
  return AppCurrency.values.firstWhere(
    (currency) => currency.name == value,
    orElse: () => AppCurrency.jpy,
  );
}
