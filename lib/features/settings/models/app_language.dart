import 'dart:ui';

import 'package:money_days/core/localization/generated/app_localizations.dart';

enum AppLanguage { english, japanese, korean }

extension AppLanguageX on AppLanguage {
  Locale get locale => switch (this) {
    AppLanguage.english => const Locale('en'),
    AppLanguage.japanese => const Locale('ja'),
    AppLanguage.korean => const Locale('ko'),
  };

  String label(AppLocalizations l10n) => switch (this) {
    AppLanguage.english => l10n.languageEnglish,
    AppLanguage.japanese => l10n.languageJapanese,
    AppLanguage.korean => l10n.languageKorean,
  };
}

AppLanguage appLanguageFromStorage(String? value) {
  return AppLanguage.values.firstWhere(
    (language) => language.name == value,
    orElse: () => AppLanguage.english,
  );
}

AppLanguage appLanguageFromLocale(Locale locale) {
  return switch (locale.languageCode) {
    'ja' => AppLanguage.japanese,
    'ko' => AppLanguage.korean,
    'en' => AppLanguage.english,
    _ => AppLanguage.english,
  };
}
