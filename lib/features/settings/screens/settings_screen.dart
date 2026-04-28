import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_days/core/localization/generated/app_localizations.dart';
import 'package:money_days/core/theme/app_colors.dart';

import '../../../core/widgets/app_page.dart';
import '../../../core/widgets/page_intro.dart';
import '../../../core/widgets/soft_section_card.dart';
import '../../expenses/models/app_currency.dart';
import '../controllers/settings_controller.dart';
import '../models/app_language.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsControllerProvider);

    return AppPage(
      bottomSafeArea: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 128),
        children: [
          PageIntro(
            eyebrow: settings.language.label(l10n),
            title: l10n.settingsTitle,
            subtitle: l10n.settingsSubtitle,
          ),
          const SizedBox(height: 16),
          _SettingsPanel(
            title: l10n.languageSetting,
            child: DropdownButtonFormField<AppLanguage>(
              value: settings.language,
              decoration: const InputDecoration(),
              items: [
                for (final language in AppLanguage.values)
                  DropdownMenuItem(
                    value: language,
                    child: Text(language.label(l10n)),
                  ),
              ],
              onChanged: (value) async {
                if (value == null) {
                  return;
                }

                await ref
                    .read(settingsControllerProvider.notifier)
                    .updateLanguage(value);
              },
            ),
          ),
          const SizedBox(height: 16),
          _SettingsPanel(
            title: l10n.currencySetting,
            supportingText: l10n.currencyConversionNote,
            child: DropdownButtonFormField<AppCurrency>(
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
                    .read(settingsControllerProvider.notifier)
                    .updateCurrency(value);
              },
            ),
          ),
          const SizedBox(height: 16),
          SoftSectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.privacyNote,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 10),
                Text(
                  l10n.privacyMessage,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 18),
                  child: Divider(height: 1, color: AppColors.border),
                ),
                Text(
                  l10n.appInfo,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 10),
                Text(
                  l10n.appInfoMessage,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsPanel extends StatelessWidget {
  const _SettingsPanel({
    required this.title,
    required this.child,
    this.supportingText,
  });

  final String title;
  final Widget child;
  final String? supportingText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SoftSectionCard(
      color: AppColors.surfaceRaised,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleLarge),
          if (supportingText != null) ...[
            const SizedBox(height: 8),
            Text(
              supportingText!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}
