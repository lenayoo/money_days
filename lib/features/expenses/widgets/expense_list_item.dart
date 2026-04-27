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

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.surfaceMuted,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(expense.category.icon, color: AppColors.textPrimary),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                expense.category.label(l10n),
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                memo ?? AppFormatters.formatLongDate(expense.date, locale),
                style: theme.textTheme.bodyMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              AppFormatters.formatCurrency(
                expense.amount,
                expense.currency,
                locale,
              ),
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              AppFormatters.formatShortDate(expense.date, locale),
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ],
    );
  }
}
