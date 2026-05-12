import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_date_utils.dart';
import '../../../core/utils/app_formatters.dart';
import '../../../core/widgets/soft_section_card.dart';
import '../models/app_currency.dart';
import '../models/expense_insights.dart';

class MonthCalendarCard extends StatelessWidget {
  const MonthCalendarCard({
    super.key,
    required this.month,
    required this.currency,
    required this.dailySummaries,
    required this.today,
    required this.selectedDate,
    required this.onDateSelected,
    this.title,
  });

  final DateTime month;
  final AppCurrency currency;
  final List<CalendarDaySummary> dailySummaries;
  final DateTime today;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final theme = Theme.of(context);
    final firstDay = DateTime(month.year, month.month, 1);
    final gridStart = firstDay.subtract(Duration(days: firstDay.weekday % 7));
    final dates = [
      for (var index = 0; index < 42; index++)
        DateTime(gridStart.year, gridStart.month, gridStart.day + index),
    ];
    final summariesByDay = {
      for (final summary in dailySummaries) summary.date.day: summary,
    };

    return SoftSectionCard(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(title!, style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),
          ],
          Row(
            children: [
              for (var index = 0; index < 7; index++)
                Expanded(
                  child: Text(
                    AppFormatters.formatWeekdayLabel(
                      DateTime(2026, 5, 10 + index),
                      locale,
                    ),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: dates.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 6,
              mainAxisSpacing: 14,
              childAspectRatio: 0.82,
            ),
            itemBuilder: (context, index) {
              final date = dates[index];
              final isCurrentMonth = date.month == month.month;
              final summary = isCurrentMonth ? summariesByDay[date.day] : null;

              return _CalendarDayCell(
                date: date,
                isCurrentMonth: isCurrentMonth,
                isToday: AppDateUtils.isSameDay(date, today),
                isSelected:
                    isCurrentMonth &&
                    AppDateUtils.isSameDay(date, selectedDate),
                currency: currency,
                summary: summary,
                onTap:
                    !isCurrentMonth ? null : () => onDateSelected(date),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CalendarDayCell extends StatelessWidget {
  const _CalendarDayCell({
    required this.date,
    required this.isCurrentMonth,
    required this.isToday,
    required this.isSelected,
    required this.currency,
    required this.summary,
    required this.onTap,
  });

  final DateTime date;
  final bool isCurrentMonth;
  final bool isToday;
  final bool isSelected;
  final AppCurrency currency;
  final CalendarDaySummary? summary;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final theme = Theme.of(context);
    final hasIncome = summary != null && summary!.incomeInBaseCurrency > 0;
    final hasExpense = summary != null && summary!.expenseInBaseCurrency > 0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: SizedBox(
          height: 56,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color:
                      isSelected
                          ? AppColors.surfaceMuted
                          : isToday
                          ? AppColors.backgroundDeep
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border:
                      isToday && !isSelected
                          ? Border.all(color: AppColors.border)
                          : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  '${date.day}',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color:
                        isCurrentMonth
                            ? AppColors.textPrimary
                            : AppColors.textTertiary,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              if (isSelected && hasExpense)
                Text(
                  '-${AppFormatters.formatCompactCurrency(summary!.expenseForCurrency(currency), currency, locale)}',
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.expense,
                    fontWeight: FontWeight.w600,
                  ),
                )
              else if (isSelected && hasIncome)
                Text(
                  '+${AppFormatters.formatCompactCurrency(summary!.incomeForCurrency(currency), currency, locale)}',
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.income,
                    fontWeight: FontWeight.w600,
                  ),
                )
              else if ((hasIncome || hasExpense) && isCurrentMonth)
                Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    color: hasExpense ? AppColors.expense : AppColors.income,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
