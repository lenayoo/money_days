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
import '../../expenses/controllers/expenses_controller.dart';
import '../../expenses/models/app_currency.dart';
import '../../expenses/models/expense_insights.dart';
import '../../expenses/models/transaction_type.dart';
import '../../settings/controllers/settings_controller.dart';
import '../widgets/monthly_insights_card.dart';
import '../widgets/monthly_summary_share_sheet.dart';
import '../widgets/category_pie_chart_card.dart';

class MonthlyReviewScreen extends ConsumerStatefulWidget {
  const MonthlyReviewScreen({super.key});

  @override
  ConsumerState<MonthlyReviewScreen> createState() =>
      _MonthlyReviewScreenState();
}

class _MonthlyReviewScreenState extends ConsumerState<MonthlyReviewScreen> {
  late DateTime _selectedMonth;
  TransactionType _selectedType = TransactionType.expense;

  @override
  void initState() {
    super.initState();
    _selectedMonth = AppDateUtils.startOfMonth(AppClock.now());
  }

  void _moveMonth(List<DateTime> months, int currentIndex, int delta) {
    final nextIndex = currentIndex + delta;
    if (nextIndex < 0 || nextIndex >= months.length) {
      return;
    }

    setState(() {
      _selectedMonth = months[nextIndex];
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
    });
  }

  Future<void> _openShareSheet(
    BuildContext context, {
    required double totalInBase,
    required AppCurrency currency,
    required ExpenseInsightsData data,
  }) async {
    await showMonthlySummaryShareSheet(
      context: context,
      month: _selectedMonth,
      type: _selectedType,
      currency: currency,
      totalInBase: totalInBase,
      budget: data.selectedBudget,
      breakdown: data.breakdown,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final theme = Theme.of(context);
    final settings = ref.watch(settingsControllerProvider);
    final expenses = ref.watch(expensesControllerProvider);
    final budgets = ref.watch(monthlyBudgetsControllerProvider);
    final selectedBudget = budgets[AppDateUtils.monthKey(_selectedMonth)];
    final availableMonths = ExpenseInsights.availableMonths(
      expenses,
      budgetMonths: budgets.values.map((budget) => budget.month),
      anchorMonth: AppClock.now(),
    );
    final monthIndex = _selectedMonthIndex(availableMonths, _selectedMonth);
    final totalInBase =
        _selectedType == TransactionType.expense
            ? ExpenseInsights.totalExpenseInBaseForMonth(expenses, _selectedMonth)
            : ExpenseInsights.totalIncomeInBaseForMonth(expenses, _selectedMonth);
    final breakdown = ExpenseInsights.categoryTotalsForMonthByType(
      expenses,
      _selectedMonth,
      _selectedType,
    );
    final topCategory = ExpenseInsights.topCategoryForMonthByType(
      expenses,
      _selectedMonth,
      _selectedType,
    );
    final activeDays = ExpenseInsights.activeDaysForMonthByType(
      expenses,
      _selectedMonth,
      TransactionType.expense,
    );
    final averageInBase = ExpenseInsights.averageAmountInBaseForActiveDaysByType(
      expenses,
      _selectedMonth,
      TransactionType.expense,
    );
    final totalAmount = AppFormatters.formatCurrency(
      settings.currency.fromBaseAmount(totalInBase),
      settings.currency,
      locale,
    );
    final monthLabel = AppFormatters.formatMonthLabel(_selectedMonth, locale);
    final shareData = ExpenseInsightsData(
      selectedBudget: selectedBudget,
      breakdown: breakdown,
    );

    return Scaffold(
      body: AppPage(
        maxWidth: 520,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          children: [
            Row(
              children: [
                RoundIconButton(
                  icon: Icons.close_rounded,
                  onPressed: () => Navigator.of(context).maybePop(),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Text(
                    l10n.monthlyPeriodLabel,
                    style: theme.textTheme.labelLarge,
                  ),
                ),
                const SizedBox(width: 12),
                RoundIconButton(
                  icon: Icons.ios_share_rounded,
                  onPressed:
                      () => _openShareSheet(
                        context,
                        totalInBase: totalInBase,
                        currency: settings.currency,
                        data: shareData,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 26),
            Center(
              child: SegmentedButton<TransactionType>(
                segments: [
                  ButtonSegment(
                    value: TransactionType.expense,
                    label: Text(l10n.transactionTypeExpense),
                  ),
                  ButtonSegment(
                    value: TransactionType.income,
                    label: Text(l10n.transactionTypeIncome),
                  ),
                ],
                selected: {_selectedType},
                onSelectionChanged: (selection) {
                  setState(() {
                    _selectedType = selection.first;
                  });
                },
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed:
                      monthIndex < availableMonths.length - 1
                          ? () => _moveMonth(availableMonths, monthIndex, 1)
                          : null,
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.chevron_left_rounded),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => _selectMonth(context, availableMonths),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Text(
                      monthLabel,
                      style: theme.textTheme.headlineSmall,
                    ),
                  ),
                ),
                IconButton(
                  onPressed:
                      monthIndex > 0
                          ? () => _moveMonth(availableMonths, monthIndex, -1)
                          : null,
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.chevron_right_rounded),
                ),
              ],
            ),
            const SizedBox(height: 28),
            Text(
              _selectedType == TransactionType.expense
                  ? l10n.monthlyExpense
                  : l10n.monthlyIncome,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 6),
            Text(
              totalAmount,
              textAlign: TextAlign.center,
              style: theme.textTheme.displaySmall?.copyWith(
                color:
                    _selectedType == TransactionType.expense
                        ? AppColors.expense
                        : AppColors.income,
              ),
            ),
            if (_selectedType == TransactionType.expense &&
                selectedBudget != null)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  _budgetHelperText(
                    l10n: l10n,
                    locale: locale,
                    budgetInBase: selectedBudget.amountInBaseCurrency,
                    expenseInBase: totalInBase,
                    currency: settings.currency,
                  ),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            const SizedBox(height: 22),
            CategoryPieChartCard(
              title:
                  _selectedType == TransactionType.expense
                      ? l10n.spendingByCategory
                      : l10n.incomeByCategory,
              emptyLabel: l10n.noCategoryData,
              breakdown: breakdown,
              currency: settings.currency,
              amountColor:
                  _selectedType == TransactionType.expense
                      ? AppColors.expense
                      : AppColors.income,
            ),
            if (_selectedType == TransactionType.expense) ...[
              const SizedBox(height: 14),
              MonthlyInsightsCard(
                topCategory: topCategory,
                activeDays: activeDays,
                averageInBase: averageInBase,
                currency: settings.currency,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class ExpenseInsightsData {
  const ExpenseInsightsData({
    required this.selectedBudget,
    required this.breakdown,
  });

  final MonthlyBudget? selectedBudget;
  final List<CategorySpending> breakdown;
}

int _selectedMonthIndex(List<DateTime> months, DateTime selectedMonth) {
  final index = months.indexWhere(
    (month) =>
        month.year == selectedMonth.year && month.month == selectedMonth.month,
  );
  return index == -1 ? 0 : index;
}

String _budgetHelperText({
  required AppLocalizations l10n,
  required Locale locale,
  required double budgetInBase,
  required double expenseInBase,
  required AppCurrency currency,
}) {
  final difference = budgetInBase - expenseInBase;
  final amount = AppFormatters.formatCurrency(
    currency.fromBaseAmount(difference.abs()),
    currency,
    locale,
  );

  if (difference >= 0) {
    return l10n.budgetRemaining(amount);
  }

  return l10n.budgetExceeded(amount);
}
