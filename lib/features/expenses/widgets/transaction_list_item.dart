import 'package:flutter/material.dart';
import 'package:money_days/core/localization/generated/app_localizations.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_formatters.dart';
import '../models/app_currency.dart';
import '../models/expense.dart';
import '../models/expense_category.dart';
import '../models/payment_method.dart';
import '../models/transaction_type.dart';

class TransactionListItem extends StatelessWidget {
  const TransactionListItem({
    super.key,
    required this.expense,
    required this.displayCurrency,
  });

  final Expense expense;
  final AppCurrency displayCurrency;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final theme = Theme.of(context);
    final category = expense.category;
    final metaParts = <String>[
      expense.type.label(l10n),
      AppFormatters.formatShortDate(expense.date, locale),
      if (expense.paymentMethod != null) expense.paymentMethod!.label(l10n),
    ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color:
                expense.isIncome ? AppColors.incomeSoft : category.surfaceColor,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            category.icon,
            size: 18,
            color: expense.isIncome ? AppColors.income : category.color,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(category.label(l10n), style: theme.textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(
                expense.memo ?? metaParts.join(' · '),
                style: theme.textTheme.bodyMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (expense.memo != null) ...[
                const SizedBox(height: 4),
                Text(
                  metaParts.join(' · '),
                  style: theme.textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: 12),
        Text(
          AppFormatters.formatSignedCurrency(
            expense.amountForCurrency(displayCurrency),
            displayCurrency,
            locale,
            isIncome: expense.isIncome,
          ),
          style: theme.textTheme.titleMedium?.copyWith(
            color: expense.isIncome ? AppColors.income : AppColors.expense,
          ),
        ),
      ],
    );
  }
}
