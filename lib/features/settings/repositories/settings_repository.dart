import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../core/constants/storage_keys.dart';
import '../../expenses/models/app_currency.dart';
import '../models/app_language.dart';
import '../models/app_settings.dart';

abstract class SettingsRepository {
  AppSettings loadSettings();

  Future<void> saveSettings(AppSettings settings);
}

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => InMemorySettingsRepository(),
);

class InMemorySettingsRepository implements SettingsRepository {
  AppSettings _settings = AppSettings(
    currency: appCurrencyFromLocale(PlatformDispatcher.instance.locale),
    language: appLanguageFromLocale(PlatformDispatcher.instance.locale),
  );

  @override
  AppSettings loadSettings() => _settings;

  @override
  Future<void> saveSettings(AppSettings settings) async {
    _settings = settings;
  }
}

class LocalSettingsRepository implements SettingsRepository {
  LocalSettingsRepository(this._box);

  final Box<dynamic> _box;

  @override
  AppSettings loadSettings() {
    final rawSettings = _box.get(StorageKeys.settings);
    final systemLocale = PlatformDispatcher.instance.locale;
    final systemCurrency = appCurrencyFromLocale(systemLocale);
    final systemLanguage = appLanguageFromLocale(systemLocale);

    if (rawSettings is! Map) {
      return AppSettings(currency: systemCurrency, language: systemLanguage);
    }

    final settingsMap = rawSettings.map(
      (key, value) => MapEntry(key.toString(), value),
    );

    return AppSettings.fromMap(
      settingsMap,
      defaultCurrency: systemCurrency,
      defaultLanguage: systemLanguage,
    );
  }

  @override
  Future<void> saveSettings(AppSettings settings) {
    return _box.put(StorageKeys.settings, settings.toMap());
  }
}
