import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_days/core/localization/generated/app_localizations.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_clock.dart';
import '../../../core/utils/app_date_utils.dart';
import '../../../core/utils/app_formatters.dart';
import '../../../core/widgets/app_page.dart';
import '../../../core/widgets/month_picker_sheet.dart';
import '../../../core/widgets/round_icon_button.dart';
import '../../budgets/controllers/monthly_budgets_controller.dart';
import '../../budgets/models/monthly_budget.dart';
import '../../budgets/widgets/monthly_budget_sheet.dart';
import '../../premium/controllers/premium_controller.dart';
import '../../premium/models/premium_feature.dart';
import '../../premium/widgets/premium_feature_lock_card.dart';
import '../../premium/widgets/premium_prompt_sheet.dart';
import '../../settings/controllers/settings_controller.dart';
import '../controllers/expenses_controller.dart';
import '../models/app_currency.dart';
import '../models/expense_insights.dart';
import '../widgets/month_calendar_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({
    super.key,
    required this.onAddTransaction,
    required this.onOpenReview,
    required this.onOpenSettings,
    required this.onOpenDay,
  });

  final VoidCallback onAddTransaction;
  final VoidCallback onOpenReview;
  final VoidCallback onOpenSettings;
  final ValueChanged<DateTime> onOpenDay;

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late DateTime _selectedMonth;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    final now = AppClock.now();
    _selectedMonth = AppDateUtils.startOfMonth(now);
    _selectedDate = AppDateUtils.dateOnly(now);
  }

  void _moveMonth(List<DateTime> months, int currentIndex, int delta) {
    final nextIndex = currentIndex + delta;
    if (nextIndex < 0 || nextIndex >= months.length) {
      return;
    }

    final nextMonth = months[nextIndex];
    setState(() {
      _selectedMonth = nextMonth;
      _selectedDate = DateTime(nextMonth.year, nextMonth.month, 1);
    });
  }

  Future<void> _selectMonth(BuildContext context, List<DateTime> months) async {
    final selectedMonth = await showMonthPickerSheet(
      context: context,
      months: months,
      selectedMonth: _selectedMonth,
    );

    if (selectedMonth == null || !mounted) {
      return;
    }

    setState(() {
      _selectedMonth = selectedMonth;
      _selectedDate = DateTime(selectedMonth.year, selectedMonth.month, 1);
    });
  }

  Future<void> _openBudgetSheet(BuildContext context) async {
    final premiumState = ref.read(premiumControllerProvider);
    if (!premiumState.isPremium) {
      await showPremiumPromptSheet(
        context: context,
        highlightedFeature: PremiumFeature.monthlyBudget,
      );
      return;
    }

    final settings = ref.read(settingsControllerProvider);
    final budgets = ref.read(monthlyBudgetsControllerProvider);
    final selectedBudget = budgets[AppDateUtils.monthKey(_selectedMonth)];

    final enteredAmount = await showMonthlyBudgetSheet(
      context: context,
      month: _selectedMonth,
      currency: settings.currency,
      initialAmount: selectedBudget?.amountForCurrency(settings.currency),
    );

    if (enteredAmount == null) {
      return;
    }

    await ref
        .read(monthlyBudgetsControllerProvider.notifier)
        .setBudget(
          month: _selectedMonth,
          amount: enteredAmount,
          currency: settings.currency,
        );
  }

  void _handleDayTap(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
    widget.onOpenDay(date);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final settings = ref.watch(settingsControllerProvider);
    final expenses = ref.watch(expensesControllerProvider);
    final budgets = ref.watch(monthlyBudgetsControllerProvider);
    final premiumState = ref.watch(premiumControllerProvider);
    final today = AppClock.now();
    final isPremium = premiumState.isPremium;

    final availableMonths = ExpenseInsights.availableMonths(
      expenses,
      budgetMonths: budgets.values.map((budget) => budget.month),
      anchorMonth: today,
    );
    final monthIndex = _selectedMonthIndex(availableMonths, _selectedMonth);
    final selectedBudget = budgets[AppDateUtils.monthKey(_selectedMonth)];
    final incomeInBase = ExpenseInsights.totalIncomeInBaseForMonth(
      expenses,
      _selectedMonth,
    );
    final expenseInBase = ExpenseInsights.totalExpenseInBaseForMonth(
      expenses,
      _selectedMonth,
    );
    final budgetStatus = _budgetStatus(
      budget: selectedBudget,
      expenseInBase: expenseInBase,
    );
    final dailySummaries = ExpenseInsights.dailyTotalsForMonth(
      expenses,
      _selectedMonth,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton(
        onPressed: widget.onAddTransaction,
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 2,
        shape: const CircleBorder(
          side: BorderSide(color: AppColors.border),
        ),
        child: const Icon(Icons.edit_outlined),
      ),
      body: AppPage(
        maxWidth: 520,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 108),
          children: [
            Row(
              children: [
                RoundIconButton(
                  icon: Icons.bar_chart_rounded,
                  onPressed: widget.onOpenReview,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _MonthTitleControl(
                    monthLabel: AppFormatters.formatMonthOnlyLabel(
                      _selectedMonth,
                      locale,
                    ),
                    canGoPrevious: monthIndex < availableMonths.length - 1,
                    canGoNext: monthIndex > 0,
                    onPrevious: () => _moveMonth(availableMonths, monthIndex, 1),
                    onNext: () => _moveMonth(availableMonths, monthIndex, -1),
                    onSelectMonth: () => _selectMonth(context, availableMonths),
                  ),
                ),
                const SizedBox(width: 14),
                RoundIconButton(
                  icon: Icons.tune_rounded,
                  onPressed: widget.onOpenSettings,
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (isPremium) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _MetricColumn(
                      topLabel: l10n.monthlyIncome,
                      topValue: AppFormatters.formatCurrency(
                        settings.currency.fromBaseAmount(incomeInBase),
                        settings.currency,
                        locale,
                      ),
                      topColor: AppColors.income,
                      bottomLabel: l10n.monthlyExpense,
                      bottomValue: AppFormatters.formatCurrency(
                        settings.currency.fromBaseAmount(expenseInBase),
                        settings.currency,
                        locale,
                      ),
                      bottomColor: AppColors.expense,
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: _MetricColumn(
                      topLabel: l10n.monthlyBudget,
                      topValue:
                          selectedBudget == null
                              ? l10n.budgetNotSet
                              : AppFormatters.formatCurrency(
                                selectedBudget.amountForCurrency(
                                  settings.currency,
                                ),
                                settings.currency,
                                locale,
                              ),
                      bottomLabel: l10n.remainingBudget,
                      bottomValue: _formatBudgetDifference(
                        currency: settings.currency,
                        locale: locale,
                        budget: selectedBudget,
                        differenceInBase: budgetStatus,
                        emptyText: l10n.budgetNotSet,
                      ),
                      bottomColor:
                          budgetStatus == null
                              ? AppColors.textPrimary
                              : budgetStatus < 0
                              ? AppColors.expense
                              : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => _openBudgetSheet(context),
                  child: Text(
                    selectedBudget == null
                        ? l10n.setThisMonthBudget
                        : l10n.editBudget,
                  ),
                ),
              ),
            ] else ...[
              _MetricColumn(
                topLabel: l10n.monthlyIncome,
                topValue: AppFormatters.formatCurrency(
                  settings.currency.fromBaseAmount(incomeInBase),
                  settings.currency,
                  locale,
                ),
                topColor: AppColors.income,
                bottomLabel: l10n.monthlyExpense,
                bottomValue: AppFormatters.formatCurrency(
                  settings.currency.fromBaseAmount(expenseInBase),
                  settings.currency,
                  locale,
                ),
                bottomColor: AppColors.expense,
              ),
              const SizedBox(height: 18),
              PremiumFeatureLockCard(
                feature: PremiumFeature.monthlyBudget,
                onOpenPremium:
                    () => showPremiumPromptSheet(
                      context: context,
                      highlightedFeature: PremiumFeature.monthlyBudget,
                    ),
              ),
            ],
            const SizedBox(height: 8),
            MonthCalendarCard(
              month: _selectedMonth,
              currency: settings.currency,
              dailySummaries: dailySummaries,
              today: today,
              selectedDate: _selectedDate,
              onDateSelected: _handleDayTap,
            ),
          ],
        ),
      ),
    );
  }
}

int _selectedMonthIndex(List<DateTime> months, DateTime selectedMonth) {
  final index = months.indexWhere(
    (month) =>
        month.year == selectedMonth.year && month.month == selectedMonth.month,
  );
  return index == -1 ? 0 : index;
}

double? _budgetStatus({
  required MonthlyBudget? budget,
  required double expenseInBase,
}) {
  if (budget == null || budget.amountInBaseCurrency <= 0) {
    return null;
  }

  return budget.amountInBaseCurrency - expenseInBase;
}

String _formatBudgetDifference({
  required AppCurrency currency,
  required Locale locale,
  required MonthlyBudget? budget,
  required double? differenceInBase,
  required String emptyText,
}) {
  if (budget == null || differenceInBase == null) {
    return emptyText;
  }

  final amount = AppFormatters.formatCurrency(
    currency.fromBaseAmount(differenceInBase.abs()),
    currency,
    locale,
  );

  if (differenceInBase < 0) {
    return '-$amount';
  }

  return amount;
}

class _MonthTitleControl extends StatelessWidget {
  const _MonthTitleControl({
    required this.monthLabel,
    required this.onSelectMonth,
    required this.onPrevious,
    required this.onNext,
    required this.canGoPrevious,
    required this.canGoNext,
  });

  final String monthLabel;
  final VoidCallback onSelectMonth;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final bool canGoPrevious;
  final bool canGoNext;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: canGoPrevious ? onPrevious : null,
          visualDensity: VisualDensity.compact,
          icon: const Icon(Icons.chevron_left_rounded),
        ),
        Flexible(
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onSelectMonth,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Text(
                monthLabel,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall,
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: canGoNext ? onNext : null,
          visualDensity: VisualDensity.compact,
          icon: const Icon(Icons.chevron_right_rounded),
        ),
      ],
    );
  }
}

class _MetricColumn extends StatelessWidget {
  const _MetricColumn({
    required this.topLabel,
    required this.topValue,
    required this.bottomLabel,
    required this.bottomValue,
    this.topColor = AppColors.textPrimary,
    this.bottomColor = AppColors.textPrimary,
  });

  final String topLabel;
  final String topValue;
  final String bottomLabel;
  final String bottomValue;
  final Color topColor;
  final Color bottomColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _MetricText(label: topLabel, value: topValue, valueColor: topColor),
        const SizedBox(height: 14),
        _MetricText(
          label: bottomLabel,
          value: bottomValue,
          valueColor: bottomColor,
        ),
      ],
    );
  }
}

class _MetricText extends StatelessWidget {
  const _MetricText({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(color: valueColor),
        ),
      ],
    );
  }
}
