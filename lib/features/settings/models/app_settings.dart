import '../../expenses/models/app_currency.dart';
import 'app_language.dart';

class AppSettings {
  const AppSettings({
    this.currency = AppCurrency.jpy,
    this.language = AppLanguage.system,
    this.isPremium = false,
  });

  factory AppSettings.fromMap(
    Map<String, dynamic> map, {
    AppCurrency defaultCurrency = AppCurrency.jpy,
    AppLanguage defaultLanguage = AppLanguage.system,
  }) {
    final rawCurrency = map['currency'] as String?;
    final rawLanguage = map['language'] as String?;
    final rawIsPremium = map['isPremium'] as bool?;

    return AppSettings(
      currency:
          rawCurrency == null
              ? defaultCurrency
              : appCurrencyFromStorage(rawCurrency),
      language:
          rawLanguage == null
              ? defaultLanguage
              : appLanguageFromStorage(rawLanguage),
      isPremium: rawIsPremium ?? false,
    );
  }

  final AppCurrency currency;
  final AppLanguage language;
  final bool isPremium;

  AppSettings copyWith({
    AppCurrency? currency,
    AppLanguage? language,
    bool? isPremium,
  }) {
    return AppSettings(
      currency: currency ?? this.currency,
      language: language ?? this.language,
      isPremium: isPremium ?? this.isPremium,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'currency': currency.name,
      'language': language.name,
      'isPremium': isPremium,
    };
  }
}
