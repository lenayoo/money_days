import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_days/core/localization/generated/app_localizations.dart';
import 'package:money_days/core/theme/app_colors.dart';

import '../../../core/widgets/app_page.dart';
import '../../../core/widgets/round_icon_button.dart';
import '../../../core/widgets/soft_section_card.dart';
import '../../expenses/models/app_currency.dart';
import '../controllers/settings_controller.dart';
import '../models/app_language.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final settings = ref.watch(settingsControllerProvider);
    final systemLocale = PlatformDispatcher.instance.locale;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: AppPage(
        bottomSafeArea: false,
        maxWidth: 520,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          children: [
            Row(
              children: [
                RoundIconButton(
                  icon: Icons.close_rounded,
                  onPressed: () => Navigator.of(context).maybePop(),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(l10n.settingsTitle, style: theme.textTheme.headlineMedium),
            const SizedBox(height: 20),
            _SettingsPanel(
              title: l10n.languageSetting,
              child: DropdownButtonFormField<AppLanguage>(
                isExpanded: true,
                value: settings.language,
                items: [
                  for (final language in AppLanguage.values)
                    DropdownMenuItem(
                      value: language,
                      child: Text(language.label(l10n, systemLocale)),
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
            const SizedBox(height: 14),
            _SettingsPanel(
              title: l10n.currencySetting,
              supportingText: l10n.currencyBaseNote,
              child: DropdownButtonFormField<AppCurrency>(
                isExpanded: true,
                value: settings.currency,
                items: [
                  for (final currency in AppCurrency.values)
                    DropdownMenuItem(
                      value: currency,
                      child: Text(currency.label),
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
          ],
        ),
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
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleLarge),
          if (supportingText != null) ...[
            const SizedBox(height: 6),
            Text(
              supportingText!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}
