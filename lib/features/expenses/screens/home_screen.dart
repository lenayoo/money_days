import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_days/core/localization/generated/app_localizations.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_clock.dart';
import '../../../core/utils/app_date_utils.dart';
import '../../../core/utils/app_formatters.dart';
import '../../../core/widgets/app_page.dart';
import '../../../core/widgets/page_intro.dart';
import '../../../core/widgets/soft_section_card.dart';
import '../../budgets/controllers/monthly_budgets_controller.dart';
import '../../budgets/models/monthly_budget.dart';
import '../../budgets/widgets/monthly_budget_overview_card.dart';
import '../../budgets/widgets/monthly_budget_sheet.dart';
import '../../settings/controllers/settings_controller.dart';
import '../models/app_currency.dart';
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
    final budgets = ref.watch(monthlyBudgetsControllerProvider);

    final today = AppClock.now();
    final monthBudget = budgets[AppDateUtils.monthKey(today)];
    final hasBudget =
        monthBudget != null && monthBudget.amountInBaseCurrency > 0;
    final monthTotalInBase = ExpenseInsights.totalInBaseForMonth(
      expenses,
      today,
    );
    final todayTotal = settings.currency.fromBaseAmount(
      ExpenseInsights.totalInBaseForDay(expenses, today),
    );
    final monthTotal = settings.currency.fromBaseAmount(monthTotalInBase);
    final recentExpenses = ExpenseInsights.recentExpenses(expenses);
    final monthBudgetAmount =
        !hasBudget
            ? l10n.budgetNotSet
            : AppFormatters.formatCurrency(
              monthBudget.amountForCurrency(settings.currency),
              settings.currency,
              locale,
            );
    final budgetProgress =
        !hasBudget ? null : monthTotalInBase / monthBudget.amountInBaseCurrency;
    final budgetProgressLabel =
        !hasBudget
            ? null
            : l10n.budgetProgressUsed((budgetProgress! * 100).round());
    final budgetStatusLabel = _buildBudgetStatusLabel(
      l10n: l10n,
      locale: locale,
      currency: settings.currency,
      totalInBaseCurrency: monthTotalInBase,
      budget: monthBudget,
    );

    Future<void> openBudgetSheet() async {
      final enteredAmount = await showMonthlyBudgetSheet(
        context: context,
        month: today,
        currency: settings.currency,
        initialAmount: monthBudget?.amountForCurrency(settings.currency),
      );

      if (enteredAmount == null) {
        return;
      }

      await ref
          .read(monthlyBudgetsControllerProvider.notifier)
          .setBudget(
            month: today,
            amount: enteredAmount,
            currency: settings.currency,
          );
    }

    return AppPage(
      bottomSafeArea: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 128),
        children: [
          PageIntro(
            eyebrow: AppFormatters.formatMonthLabel(today, locale),
            title: l10n.appName,
          ),
          const SizedBox(height: 24),
          SummaryCard(
            title: l10n.todaySpending,
            amount: AppFormatters.formatCurrency(
              todayTotal,
              settings.currency,
              locale,
            ),
            supportingText: AppFormatters.formatLongDate(today, locale),
            icon: Icons.wb_sunny_outlined,
          ),
          const SizedBox(height: 16),
          MonthlyBudgetOverviewCard(
            monthLabel: AppFormatters.formatMonthLabel(today, locale),
            totalLabel: l10n.monthSpending,
            totalAmount: AppFormatters.formatCurrency(
              monthTotal,
              settings.currency,
              locale,
            ),
            budgetLabel: l10n.monthlyBudget,
            budgetAmount: monthBudgetAmount,
            hasBudget: hasBudget,
            actionLabel: hasBudget ? l10n.editBudget : l10n.setThisMonthBudget,
            onActionPressed: openBudgetSheet,
            progress: budgetProgress,
            progressLabel: budgetProgressLabel,
            statusLabel: budgetStatusLabel,
            promptTitle: hasBudget ? null : l10n.setThisMonthBudget,
            promptSubtitle: hasBudget ? null : l10n.startThisMonthWithBudget,
          ),
          const SizedBox(height: 16),
          SoftSectionCard(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isNarrow = constraints.maxWidth < 440;

                final actionButton = FilledButton.icon(
                  onPressed: onAddExpense,
                  icon: const Icon(Icons.edit_note_rounded),
                  label: Text(l10n.addTodaySpending),
                );

                final copy = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.addTodaySpending,
                      style: theme.textTheme.titleLarge,
                    ),
                  ],
                );

                if (isNarrow) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [copy, const SizedBox(height: 18), actionButton],
                  );
                }

                return Row(
                  children: [
                    Expanded(child: copy),
                    const SizedBox(width: 16),
                    actionButton,
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          SoftSectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.recentExpenses, style: theme.textTheme.titleLarge),
                const SizedBox(height: 18),
                if (recentExpenses.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      l10n.emptyRecentExpenses,
                      style: theme.textTheme.bodyLarge,
                    ),
                  )
                else
                  for (
                    var index = 0;
                    index < recentExpenses.length;
                    index++
                  ) ...[
                    ExpenseListItem(
                      expense: recentExpenses[index],
                      displayCurrency: settings.currency,
                    ),
                    if (index != recentExpenses.length - 1)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 18),
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

String? _buildBudgetStatusLabel({
  required AppLocalizations l10n,
  required Locale locale,
  required AppCurrency currency,
  required double totalInBaseCurrency,
  required MonthlyBudget? budget,
}) {
  if (budget == null || budget.amountInBaseCurrency <= 0) {
    return null;
  }

  final differenceInBaseCurrency =
      budget.amountInBaseCurrency - totalInBaseCurrency;

  if (differenceInBaseCurrency > 0) {
    final remainingAmount = AppFormatters.formatCurrency(
      currency.fromBaseAmount(differenceInBaseCurrency),
      currency,
      locale,
    );
    return l10n.budgetRemaining(remainingAmount);
  }

  if (differenceInBaseCurrency < 0) {
    final exceededAmount = AppFormatters.formatCurrency(
      currency.fromBaseAmount(-differenceInBaseCurrency),
      currency,
      locale,
    );
    return l10n.budgetExceeded(exceededAmount);
  }

  return l10n.budgetReached;
}
