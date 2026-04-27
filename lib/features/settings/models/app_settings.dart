import 'package:flutter/material.dart';

import '../../../core/localization/app_language.dart';
import '../../expenses/models/app_currency.dart';

class AppSettings {
  const AppSettings({
    this.language = AppLanguage.system,
    this.currency = AppCurrency.jpy,
  });

  factory AppSettings.fromMap(Map<String, dynamic> map) {
    return AppSettings(
      language: appLanguageFromStorage(map['language'] as String?),
      currency: appCurrencyFromStorage(map['currency'] as String?),
    );
  }

  final AppLanguage language;
  final AppCurrency currency;

  Locale? get locale => language.locale;

  AppSettings copyWith({AppLanguage? language, AppCurrency? currency}) {
    return AppSettings(
      language: language ?? this.language,
      currency: currency ?? this.currency,
    );
  }

  Map<String, dynamic> toMap() {
    return {'language': language.name, 'currency': currency.name};
  }
}
