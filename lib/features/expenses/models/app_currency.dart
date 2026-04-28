import 'dart:ui';

import 'package:money_days/core/localization/generated/app_localizations.dart';

enum AppCurrency { jpy, usd, krw, sgd }

extension AppCurrencyX on AppCurrency {
  String get code => switch (this) {
    AppCurrency.jpy => 'JPY',
    AppCurrency.usd => 'USD',
    AppCurrency.krw => 'KRW',
    AppCurrency.sgd => 'SGD',
  };

  String get symbol => switch (this) {
    AppCurrency.jpy => '¥',
    AppCurrency.usd => r'$',
    AppCurrency.krw => '₩',
    AppCurrency.sgd => 'S\$',
  };

  int get decimalDigits => switch (this) {
    AppCurrency.usd || AppCurrency.sgd => 2,
    AppCurrency.jpy || AppCurrency.krw => 0,
  };

  double get unitsPerUsd => switch (this) {
    AppCurrency.usd => 1.0,
    AppCurrency.jpy => 150.0,
    AppCurrency.krw => 1500.0,
    AppCurrency.sgd => 1.35,
  };

  String label(AppLocalizations l10n) => switch (this) {
    AppCurrency.jpy => l10n.currencyJpy,
    AppCurrency.usd => l10n.currencyUsd,
    AppCurrency.krw => l10n.currencyKrw,
    AppCurrency.sgd => l10n.currencySgd,
  };

  double toBaseAmount(double amount) => amount / unitsPerUsd;

  double fromBaseAmount(double amount) => amount * unitsPerUsd;

  double convertAmount(double amount, AppCurrency targetCurrency) {
    final amountInUsd = toBaseAmount(amount);
    return targetCurrency.fromBaseAmount(amountInUsd);
  }
}

AppCurrency appCurrencyFromStorage(String? value) {
  return AppCurrency.values.firstWhere(
    (currency) => currency.name == value,
    orElse: () => AppCurrency.jpy,
  );
}

AppCurrency appCurrencyFromLocale(Locale locale) {
  if (locale.countryCode?.toUpperCase() == 'SG') {
    return AppCurrency.sgd;
  }

  return switch (locale.languageCode) {
    'en' => AppCurrency.usd,
    'ko' => AppCurrency.krw,
    'ja' => AppCurrency.jpy,
    _ => AppCurrency.jpy,
  };
}
