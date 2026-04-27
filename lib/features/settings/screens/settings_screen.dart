import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_days/core/localization/generated/app_localizations.dart';

import '../../../core/localization/app_language.dart';
import '../../../core/widgets/soft_section_card.dart';
import '../../expenses/controllers/expenses_controller.dart';
import '../../expenses/models/app_currency.dart';
import '../controllers/settings_controller.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final settings = ref.watch(settingsControllerProvider);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        children: [
          Text(l10n.settingsTitle, style: theme.textTheme.headlineLarge),
          const SizedBox(height: 8),
          Text(l10n.settingsSubtitle, style: theme.textTheme.bodyLarge),
          const SizedBox(height: 24),
          SoftSectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.languageSetting, style: theme.textTheme.titleLarge),
                const SizedBox(height: 16),
                DropdownButtonFormField<AppLanguage>(
                  value: settings.language,
                  decoration: const InputDecoration(),
                  items: [
                    for (final language in AppLanguage.values)
                      DropdownMenuItem(
                        value: language,
                        child: Text(language.label(l10n)),
                      ),
                  ],
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    ref
                        .read(settingsControllerProvider.notifier)
                        .updateLanguage(value);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SoftSectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.currencySetting, style: theme.textTheme.titleLarge),
                const SizedBox(height: 16),
                DropdownButtonFormField<AppCurrency>(
                  value: settings.currency,
                  decoration: const InputDecoration(),
                  items: [
                    for (final currency in AppCurrency.values)
                      DropdownMenuItem(
                        value: currency,
                        child: Text(currency.label(l10n)),
                      ),
                  ],
                  onChanged: (value) async {
                    if (value == null) {
                      return;
                    }

                    await ref
                        .read(expensesControllerProvider.notifier)
                        .updateCurrency(value);
                    await ref
                        .read(settingsControllerProvider.notifier)
                        .updateCurrency(value);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SoftSectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.appInfo, style: theme.textTheme.titleLarge),
                const SizedBox(height: 12),
                Text(l10n.appInfoMessage, style: theme.textTheme.bodyLarge),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SoftSectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.privacyNote, style: theme.textTheme.titleLarge),
                const SizedBox(height: 12),
                Text(l10n.privacyMessage, style: theme.textTheme.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
