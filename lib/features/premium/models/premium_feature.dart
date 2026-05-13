import 'package:flutter/material.dart';
import 'package:money_days/core/localization/generated/app_localizations.dart';

enum PremiumFeature {
  monthlyBudget,
  pieChartAnalysis,
  spendingInsights,
  shareCards,
}

extension PremiumFeatureX on PremiumFeature {
  IconData get icon => switch (this) {
    PremiumFeature.monthlyBudget => Icons.savings_outlined,
    PremiumFeature.pieChartAnalysis => Icons.pie_chart_outline_rounded,
    PremiumFeature.spendingInsights => Icons.auto_graph_rounded,
    PremiumFeature.shareCards => Icons.ios_share_rounded,
  };

  String title(AppLocalizations l10n) => switch (this) {
    PremiumFeature.monthlyBudget => l10n.premiumFeatureBudgetTitle,
    PremiumFeature.pieChartAnalysis => l10n.premiumFeaturePieChartTitle,
    PremiumFeature.spendingInsights => l10n.premiumFeatureInsightsTitle,
    PremiumFeature.shareCards => l10n.premiumFeatureShareTitle,
  };

  String description(AppLocalizations l10n) => switch (this) {
    PremiumFeature.monthlyBudget => l10n.premiumFeatureBudgetDescription,
    PremiumFeature.pieChartAnalysis => l10n.premiumFeaturePieChartDescription,
    PremiumFeature.spendingInsights =>
      l10n.premiumFeatureInsightsDescription,
    PremiumFeature.shareCards => l10n.premiumFeatureShareDescription,
  };
}
