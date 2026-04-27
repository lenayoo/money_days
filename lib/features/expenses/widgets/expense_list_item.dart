import 'package:flutter/material.dart';
import 'package:money_days/core/localization/generated/app_localizations.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_formatters.dart';
import '../models/expense.dart';
import '../models/expense_category.dart';

class ExpenseListItem extends StatelessWidget {
  const ExpenseListItem({super.key, required this.expense});

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final theme = Theme.of(context);
    final memo = expense.memo;
    final category = expense.category;
    final amountText = AppFormatters.formatCurrency(
      expense.amount,
      expense.currency,
      locale,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: category.surfaceColor,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Icon(category.icon, color: category.color),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(category.label(l10n), style: theme.textTheme.titleMedium),
              const SizedBox(height: 6),
              Text(
                memo ?? AppFormatters.formatLongDate(expense.date, locale),
                style: theme.textTheme.bodyMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Text(
                AppFormatters.formatShortDate(expense.date, locale),
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.surfaceRaised,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.border),
          ),
          child: Text(
            amountText,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
