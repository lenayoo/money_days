import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_days/core/localization/generated/app_localizations.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/soft_section_card.dart';
import '../controllers/premium_controller.dart';
import '../models/premium_feature.dart';

Future<void> showPremiumPromptSheet({
  required BuildContext context,
  PremiumFeature? highlightedFeature,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder:
        (context) => PremiumPromptSheet(
          highlightedFeature: highlightedFeature,
        ),
  );
}

class PremiumPromptSheet extends ConsumerWidget {
  const PremiumPromptSheet({super.key, this.highlightedFeature});

  final PremiumFeature? highlightedFeature;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final premiumState = ref.watch(premiumControllerProvider);
    final isBusy =
        premiumState.isLoading ||
        premiumState.isPurchasePending ||
        premiumState.isRestoring;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        MediaQuery.viewInsetsOf(context).bottom + 16,
      ),
      child: SafeArea(
        top: false,
        child: SoftSectionCard(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.premiumTitle,
                      style: theme.textTheme.headlineSmall,
                    ),
                  ),
                  _PremiumStatusPill(isPremium: premiumState.isPremium),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                premiumState.isPremium
                    ? l10n.premiumActiveSubtitle
                    : highlightedFeature?.description(l10n) ??
                        l10n.premiumSubtitle,
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfaceMuted,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Text(
                      l10n.premiumOneTimePurchase,
                      style: theme.textTheme.titleMedium,
                    ),
                    const Spacer(),
                    Text(
                      premiumState.priceLabel,
                      style: theme.textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              for (final feature in PremiumFeature.values) ...[
                _FeatureRow(
                  feature: feature,
                  highlighted: feature == highlightedFeature,
                ),
                if (feature != PremiumFeature.values.last)
                  const SizedBox(height: 12),
              ],
              const SizedBox(height: 20),
              if (premiumState.isPremium) ...[
                Text(
                  l10n.premiumReadyOnDevice,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 14),
                FilledButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  child: Text(l10n.doneButton),
                ),
              ] else ...[
                FilledButton(
                  onPressed:
                      isBusy
                          ? null
                          : () async {
                            final result =
                                await ref
                                    .read(premiumControllerProvider.notifier)
                                    .buyPremium();
                            if (!context.mounted) {
                              return;
                            }
                            _showPremiumActionMessage(
                              context,
                              l10n,
                              result,
                            );
                          },
                  child: Text(
                    premiumState.isPurchasePending
                        ? l10n.premiumOpeningStore
                        : l10n.premiumUnlockButton,
                  ),
                ),
                const SizedBox(height: 10),
                OutlinedButton(
                  onPressed:
                      isBusy
                          ? null
                          : () async {
                            final result =
                                await ref
                                    .read(premiumControllerProvider.notifier)
                                    .restorePurchases();
                            if (!context.mounted) {
                              return;
                            }
                            _showPremiumActionMessage(
                              context,
                              l10n,
                              result,
                              startedMessage: l10n.premiumRestoreStartedMessage,
                            );
                          },
                  child: Text(
                    premiumState.isRestoring
                        ? l10n.premiumRestoring
                        : l10n.premiumRestoreButton,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class PremiumSettingsCard extends ConsumerWidget {
  const PremiumSettingsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final premiumState = ref.watch(premiumControllerProvider);

    return SoftSectionCard(
      onTap: () => showPremiumPromptSheet(context: context),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.premiumTitle,
                  style: theme.textTheme.titleLarge,
                ),
              ),
              _PremiumStatusPill(isPremium: premiumState.isPremium),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            premiumState.isPremium
                ? l10n.premiumReadyOnDevice
                : l10n.premiumSubtitle,
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 12),
          Text(
            premiumState.isPremium
                ? l10n.premiumActiveLabel
                : '${premiumState.priceLabel} · ${l10n.premiumOneTimePurchase}',
            style: theme.textTheme.labelLarge?.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({required this.feature, required this.highlighted});

  final PremiumFeature feature;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: highlighted ? AppColors.surfaceAccent : AppColors.surfaceRaised,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: highlighted ? AppColors.borderStrong : AppColors.border,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(feature.icon, size: 18, color: AppColors.textPrimary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(feature.title(l10n), style: theme.textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(
                  feature.description(l10n),
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PremiumStatusPill extends StatelessWidget {
  const _PremiumStatusPill({required this.isPremium});

  final bool isPremium;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isPremium ? AppColors.surfaceAccent : AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        isPremium ? l10n.premiumActiveLabel : l10n.premiumBadge,
        style: theme.textTheme.labelMedium?.copyWith(
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}

void _showPremiumActionMessage(
  BuildContext context,
  AppLocalizations l10n,
  PremiumActionResult result, {
  String? startedMessage,
}) {
  final messenger = ScaffoldMessenger.of(context);

  switch (result) {
    case PremiumActionResult.started:
      if (startedMessage == null) {
        return;
      }
      messenger.showSnackBar(SnackBar(content: Text(startedMessage)));
      return;
    case PremiumActionResult.alreadyActive:
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.premiumAlreadyActiveMessage)),
      );
      return;
    case PremiumActionResult.storeUnavailable:
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.premiumStoreUnavailableMessage)),
      );
      return;
    case PremiumActionResult.productUnavailable:
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.premiumProductUnavailableMessage)),
      );
      return;
    case PremiumActionResult.failed:
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.premiumActionFailedMessage)),
      );
      return;
  }
}
