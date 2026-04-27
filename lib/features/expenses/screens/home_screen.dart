import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_days/core/localization/generated/app_localizations.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_formatters.dart';
import '../../../core/widgets/soft_section_card.dart';
import '../../settings/controllers/settings_controller.dart';
import '../controllers/expenses_controller.dart';
import '../models/expense_insights.dart';
import '../widgets/expense_list_item.dart';
import '../widgets/summary_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key, required this.onAddExpense});

  final VoidCallback onAddExpense;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context);
    final settings = ref.watch(settingsControllerProvider);
    final expenses = ref.watch(expensesControllerProvider);

    final today = DateTime.now();
    final todayTotal = ExpenseInsights.totalForDay(expenses, today);
    final monthTotal = ExpenseInsights.totalForMonth(expenses, today);
    final recentExpenses = ExpenseInsights.recentExpenses(expenses);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        children: [
          Text(l10n.appName, style: theme.textTheme.headlineLarge),
          const SizedBox(height: 8),
          Text(l10n.homeSubtitle, style: theme.textTheme.bodyLarge),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              final cardWidth =
                  constraints.maxWidth >= 720
                      ? (constraints.maxWidth - 16) / 2
                      : constraints.maxWidth;

              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  SizedBox(
                    width: cardWidth,
                    child: SummaryCard(
                      title: l10n.todaySpending,
                      amount: AppFormatters.formatCurrency(
                        todayTotal,
                        settings.currency,
                        locale,
                      ),
                      supportingText: AppFormatters.formatLongDate(
                        today,
                        locale,
                      ),
                      icon: Icons.today_rounded,
                    ),
                  ),
                  SizedBox(
                    width: cardWidth,
                    child: SummaryCard(
                      title: l10n.monthSpending,
                      amount: AppFormatters.formatCurrency(
                        monthTotal,
                        settings.currency,
                        locale,
                      ),
                      supportingText: AppFormatters.formatMonthLabel(
                        today,
                        locale,
                      ),
                      icon: Icons.calendar_month_rounded,
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          SoftSectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.addExpenseSubtitle,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                Text(l10n.addTodaySpending, style: theme.textTheme.titleLarge),
                const SizedBox(height: 18),
                FilledButton.icon(
                  onPressed: onAddExpense,
                  icon: const Icon(Icons.add_rounded),
                  label: Text(l10n.addTodaySpending),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SoftSectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.recentExpenses, style: theme.textTheme.titleLarge),
                const SizedBox(height: 16),
                if (recentExpenses.isEmpty)
                  Text(
                    l10n.emptyRecentExpenses,
                    style: theme.textTheme.bodyLarge,
                  )
                else
                  for (
                    var index = 0;
                    index < recentExpenses.length;
                    index++
                  ) ...[
                    ExpenseListItem(expense: recentExpenses[index]),
                    if (index != recentExpenses.length - 1)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Divider(height: 1, color: AppColors.border),
                      ),
                  ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
