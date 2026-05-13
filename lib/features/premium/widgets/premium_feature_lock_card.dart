import 'package:flutter/material.dart';
import 'package:money_days/core/localization/generated/app_localizations.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/soft_section_card.dart';
import '../models/premium_feature.dart';

class PremiumFeatureLockCard extends StatelessWidget {
  const PremiumFeatureLockCard({
    super.key,
    required this.feature,
    required this.onOpenPremium,
  });

  final PremiumFeature feature;
  final VoidCallback onOpenPremium;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return SoftSectionCard(
      onTap: onOpenPremium,
      padding: const EdgeInsets.all(18),
      color: AppColors.surfaceRaised,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.surfaceMuted,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(feature.icon, color: AppColors.textPrimary, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceMuted,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    l10n.premiumBadge,
                    style: theme.textTheme.labelMedium,
                  ),
                ),
                const SizedBox(height: 10),
                Text(feature.title(l10n), style: theme.textTheme.titleLarge),
                const SizedBox(height: 6),
                Text(
                  feature.description(l10n),
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      l10n.seePremium,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.chevron_right_rounded, size: 18),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
