import 'dart:ui';

import 'package:money_days/core/localization/generated/app_localizations.dart';

enum AppLanguage { system, english, japanese, korean }

extension AppLanguageX on AppLanguage {
  Locale? get locale => switch (this) {
    AppLanguage.system => null,
    AppLanguage.english => const Locale('en'),
    AppLanguage.japanese => const Locale('ja'),
    AppLanguage.korean => const Locale('ko'),
  };

  String label(AppLocalizations l10n, Locale systemLocale) => switch (this) {
    AppLanguage.system => l10n.languageSystemCurrent(
      appLanguageFromLocale(systemLocale).localizedLabel(l10n),
    ),
    AppLanguage.english => localizedLabel(l10n),
    AppLanguage.japanese => localizedLabel(l10n),
    AppLanguage.korean => localizedLabel(l10n),
  };

  String localizedLabel(AppLocalizations l10n) => switch (this) {
    AppLanguage.system => l10n.languageSystem,
    AppLanguage.english => l10n.languageEnglish,
    AppLanguage.japanese => l10n.languageJapanese,
    AppLanguage.korean => l10n.languageKorean,
  };
}

AppLanguage appLanguageFromStorage(String? value) {
  return AppLanguage.values.firstWhere(
    (language) => language.name == value,
    orElse: () => AppLanguage.system,
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
