import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../expenses/models/app_currency.dart';
import '../models/app_language.dart';
import '../models/app_settings.dart';
import '../repositories/settings_repository.dart';

final settingsControllerProvider =
    NotifierProvider<SettingsController, AppSettings>(SettingsController.new);

class SettingsController extends Notifier<AppSettings> {
  SettingsRepository get _repository => ref.read(settingsRepositoryProvider);

  @override
  AppSettings build() {
    return _repository.loadSettings();
  }

  Future<void> updateCurrency(AppCurrency currency) async {
    final updatedSettings = state.copyWith(currency: currency);
    state = updatedSettings;
    await _repository.saveSettings(updatedSettings);
  }

  Future<void> updateLanguage(AppLanguage language) async {
    final updatedSettings = state.copyWith(language: language);
    state = updatedSettings;
    await _repository.saveSettings(updatedSettings);
  }

  Future<void> updatePremiumStatus(bool isPremium) async {
    final updatedSettings = state.copyWith(isPremium: isPremium);
    state = updatedSettings;
    await _repository.saveSettings(updatedSettings);
  }
}
