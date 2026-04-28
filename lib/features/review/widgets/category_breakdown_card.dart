import 'package:flutter/material.dart';
import 'package:money_days/core/localization/generated/app_localizations.dart';

import '../../../core/utils/app_formatters.dart';
import '../../../core/widgets/soft_section_card.dart';
import '../../expenses/models/app_currency.dart';
import '../../expenses/models/expense_category.dart';
import '../../expenses/models/expense_insights.dart';

class CategoryBreakdownCard extends StatelessWidget {
  const CategoryBreakdownCard({
    super.key,
    required this.spending,
    required this.currency,
  });

  final CategorySpending spending;
  final AppCurrency currency;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final theme = Theme.of(context);
    final category = spending.category;
    final amount = AppFormatters.formatCurrency(
      spending.totalForCurrency(currency),
      currency,
      locale,
    );

    return SoftSectionCard(
      padding: const EdgeInsets.all(18),
      accentColor: category.color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: category.surfaceColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(category.icon, color: category.color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  category.label(l10n),
                  style: theme.textTheme.titleMedium,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(amount, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    '${(spending.share * 100).round()}%',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: spending.share,
              minHeight: 10,
              backgroundColor: category.surfaceColor,
              valueColor: AlwaysStoppedAnimation<Color>(category.color),
            ),
          ),
        ],
      ),
    );
  }
}
