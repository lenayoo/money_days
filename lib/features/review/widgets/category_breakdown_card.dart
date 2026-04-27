import 'package:flutter/material.dart';
import 'package:money_days/core/localization/generated/app_localizations.dart';

import '../../../core/theme/app_colors.dart';
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

    return SoftSectionCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.surfaceMuted,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  spending.category.icon,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  spending.category.label(l10n),
                  style: theme.textTheme.titleMedium,
                ),
              ),
              Text(
                AppFormatters.formatCurrency(spending.total, currency, locale),
                style: theme.textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: spending.share,
              minHeight: 10,
              backgroundColor: AppColors.surfaceMuted,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '${(spending.share * 100).round()}%',
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
