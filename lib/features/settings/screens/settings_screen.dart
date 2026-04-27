import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_days/core/localization/generated/app_localizations.dart';
import 'package:money_days/core/theme/app_colors.dart';

import '../../../core/localization/app_language.dart';
import '../../../core/widgets/app_page.dart';
import '../../../core/widgets/page_intro.dart';
import '../../../core/widgets/soft_section_card.dart';
import '../../expenses/models/app_currency.dart';
import '../controllers/settings_controller.dart';

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
            eyebrow: settings.currency.code,
            title: l10n.settingsTitle,
            subtitle: l10n.settingsSubtitle,
          ),
          const SizedBox(height: 24),
          _SettingsPanel(
            icon: Icons.translate_rounded,
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
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                ref
                    .read(settingsControllerProvider.notifier)
                    .updateLanguage(value);
              },
            ),
          ),
          const SizedBox(height: 16),
          _SettingsPanel(
            icon: Icons.payments_outlined,
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
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 720;

              final appInfoCard = _InfoPanel(
                icon: Icons.auto_awesome_outlined,
                title: l10n.appInfo,
                message: l10n.appInfoMessage,
              );
              final privacyCard = _InfoPanel(
                icon: Icons.shield_outlined,
                title: l10n.privacyNote,
                message: l10n.privacyMessage,
              );

              if (!isWide) {
                return Column(
                  children: [
                    appInfoCard,
                    const SizedBox(height: 16),
                    privacyCard,
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(child: appInfoCard),
                  const SizedBox(width: 16),
                  Expanded(child: privacyCard),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SettingsPanel extends StatelessWidget {
  const _SettingsPanel({
    required this.icon,
    required this.title,
    required this.child,
    this.supportingText,
  });

  final IconData icon;
  final String title;
  final Widget child;
  final String? supportingText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SoftSectionCard(
      color: AppColors.surfaceRaised,
      accentColor: AppColors.accentMuted,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.88),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 18),
          Text(title, style: theme.textTheme.titleLarge),
          const SizedBox(height: 16),
          child,
          if (supportingText != null) ...[
            const SizedBox(height: 12),
            Text(
              supportingText!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoPanel extends StatelessWidget {
  const _InfoPanel({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SoftSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.surfaceRaised,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 18),
          Text(title, style: theme.textTheme.titleLarge),
          const SizedBox(height: 10),
          Text(message, style: theme.textTheme.bodyLarge),
        ],
      ),
    );
  }
}
