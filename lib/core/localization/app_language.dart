import 'package:flutter/material.dart';
import 'package:money_days/core/localization/generated/app_localizations.dart';

enum AppLanguage { system, english, japanese }

extension AppLanguageX on AppLanguage {
  Locale? get locale => switch (this) {
    AppLanguage.system => null,
    AppLanguage.english => const Locale('en'),
    AppLanguage.japanese => const Locale('ja'),
  };

  String label(AppLocalizations l10n) => switch (this) {
    AppLanguage.system => l10n.languageSystem,
    AppLanguage.english => l10n.languageEnglish,
    AppLanguage.japanese => l10n.languageJapanese,
  };
}

AppLanguage appLanguageFromStorage(String? value) {
  return AppLanguage.values.firstWhere(
    (language) => language.name == value,
    orElse: () => AppLanguage.system,
  );
}
