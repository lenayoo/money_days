import '../../expenses/models/app_currency.dart';
import 'app_language.dart';

class AppSettings {
  const AppSettings({
    this.currency = AppCurrency.jpy,
    this.language = AppLanguage.system,
  });

  factory AppSettings.fromMap(
    Map<String, dynamic> map, {
    AppCurrency defaultCurrency = AppCurrency.jpy,
    AppLanguage defaultLanguage = AppLanguage.system,
  }) {
    final rawCurrency = map['currency'] as String?;
    final rawLanguage = map['language'] as String?;

    return AppSettings(
      currency:
          rawCurrency == null
              ? defaultCurrency
              : appCurrencyFromStorage(rawCurrency),
      language:
          rawLanguage == null
              ? defaultLanguage
              : appLanguageFromStorage(rawLanguage),
    );
  }

  final AppCurrency currency;
  final AppLanguage language;

  AppSettings copyWith({AppCurrency? currency, AppLanguage? language}) {
    return AppSettings(
      currency: currency ?? this.currency,
      language: language ?? this.language,
    );
  }

  Map<String, dynamic> toMap() {
    return {'currency': currency.name, 'language': language.name};
  }
}
