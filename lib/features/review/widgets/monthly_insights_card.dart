import 'package:flutter/material.dart';
import 'package:money_days/core/localization/generated/app_localizations.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_formatters.dart';
import '../../../core/widgets/soft_section_card.dart';
import '../../expenses/models/app_currency.dart';
import '../../expenses/models/expense_category.dart';
import '../../expenses/models/expense_insights.dart';

class MonthlyInsightsCard extends StatelessWidget {
  const MonthlyInsightsCard({
    super.key,
    required this.topCategory,
    required this.activeDays,
    required this.averageInBase,
    required this.currency,
  });

  final CategorySpending? topCategory;
  final int activeDays;
  final double averageInBase;
  final AppCurrency currency;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final theme = Theme.of(context);

    return SoftSectionCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.spendingInsightsTitle, style: theme.textTheme.titleLarge),
          const SizedBox(height: 18),
          if (topCategory == null || activeDays == 0)
            Text(
              l10n.spendingInsightsEmpty,
              style: theme.textTheme.bodyLarge,
            )
          else ...[
            _InsightRow(
              label: l10n.spendingInsightTopCategory,
              value: topCategory!.category.label(l10n),
              supporting: AppFormatters.formatCurrency(
                topCategory!.totalForCurrency(currency),
                currency,
                locale,
              ),
            ),
            const SizedBox(height: 12),
            _InsightRow(
              label: l10n.spendingInsightDays,
              value: l10n.dayCount(activeDays),
            ),
            const SizedBox(height: 12),
            _InsightRow(
              label: l10n.spendingInsightDailyAverage,
              value: AppFormatters.formatCurrency(
                currency.fromBaseAmount(averageInBase),
                currency,
                locale,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _InsightRow extends StatelessWidget {
  const _InsightRow({
    required this.label,
    required this.value,
    this.supporting,
  });

  final String label;
  final String value;
  final String? supporting;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceRaised,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: theme.textTheme.bodyLarge),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(value, style: theme.textTheme.titleMedium),
              if (supporting != null) ...[
                const SizedBox(height: 4),
                Text(supporting!, style: theme.textTheme.bodySmall),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
