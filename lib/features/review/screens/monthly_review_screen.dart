import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_days/core/localization/generated/app_localizations.dart';
import 'package:money_days/core/theme/app_colors.dart';

import '../../../core/utils/app_date_utils.dart';
import '../../../core/utils/app_formatters.dart';
import '../../../core/widgets/app_page.dart';
import '../../../core/widgets/page_intro.dart';
import '../../../core/widgets/soft_section_card.dart';
import '../../../core/widgets/tone_pill.dart';
import '../../budgets/controllers/monthly_budgets_controller.dart';
import '../../budgets/widgets/monthly_budget_overview_card.dart';
import '../../budgets/widgets/monthly_budget_sheet.dart';
import '../../expenses/controllers/expenses_controller.dart';
import '../../expenses/models/app_currency.dart';
import '../../expenses/models/expense_category.dart';
import '../../expenses/models/expense_insights.dart';
import '../../expenses/widgets/expense_list_item.dart';
import '../../settings/controllers/settings_controller.dart';
import '../widgets/category_breakdown_card.dart';

class MonthlyReviewScreen extends ConsumerStatefulWidget {
  const MonthlyReviewScreen({super.key});

  @override
  ConsumerState<MonthlyReviewScreen> createState() =>
      _MonthlyReviewScreenState();
}

class _MonthlyReviewScreenState extends ConsumerState<MonthlyReviewScreen> {
  late DateTime _selectedMonth;

  @override
  void initState() {
    super.initState();
    _selectedMonth = AppDateUtils.startOfMonth(DateTime.now());
  }

  Future<void> _selectMonth(BuildContext context, List<DateTime> months) async {
    final selectedMonth = await showModalBottomSheet<DateTime>(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (context) => _MonthSelectionSheet(
            months: months,
            selectedMonth: _selectedMonth,
          ),
    );

    if (selectedMonth == null || !mounted) {
      return;
    }

    setState(() {
      _selectedMonth = selectedMonth;
    });
  }

  Future<void> _openBudgetSheet(BuildContext context) async {
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context);
    final settings = ref.watch(settingsControllerProvider);
    final expenses = ref.watch(expensesControllerProvider);
    final budgets = ref.watch(monthlyBudgetsControllerProvider);

    final availableMonths = ExpenseInsights.availableMonths(
      expenses,
      budgetMonths: budgets.values.map((budget) => budget.month),
      anchorMonth: DateTime.now(),
    );
    final selectedMonthBudget = budgets[AppDateUtils.monthKey(_selectedMonth)];
    final total = settings.currency.fromBaseAmount(
      ExpenseInsights.totalInBaseForMonth(expenses, _selectedMonth),
    );
    final breakdown = ExpenseInsights.categoryTotalsForMonth(
      expenses,
      _selectedMonth,
    );
    final monthlyExpenses = ExpenseInsights.expensesForMonth(
      expenses,
      _selectedMonth,
    );
    final topCategory = breakdown.isEmpty ? null : breakdown.first;
    final isCurrentMonth = AppDateUtils.isSameMonth(
      _selectedMonth,
      DateTime.now(),
    );
    final budgetAmount =
        selectedMonthBudget == null
            ? l10n.budgetNotSet
            : AppFormatters.formatCurrency(
              selectedMonthBudget.amountForCurrency(settings.currency),
              settings.currency,
              locale,
            );

    return AppPage(
      bottomSafeArea: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 128),
        children: [
          PageIntro(
            eyebrow: AppFormatters.formatMonthLabel(_selectedMonth, locale),
            title: l10n.monthlyReviewTitle,
            subtitle: l10n.monthlyReviewSubtitle,
          ),
          const SizedBox(height: 16),
          _MonthSelectorCard(
            label: l10n.selectMonth,
            monthLabel: AppFormatters.formatMonthLabel(_selectedMonth, locale),
            onTap: () => _selectMonth(context, availableMonths),
          ),
          const SizedBox(height: 16),
          MonthlyBudgetOverviewCard(
            monthLabel: AppFormatters.formatMonthLabel(_selectedMonth, locale),
            totalLabel: l10n.monthlyTotal,
            totalAmount: AppFormatters.formatCurrency(
              total,
              settings.currency,
              locale,
            ),
            budgetLabel: l10n.monthlyBudget,
            budgetAmount: budgetAmount,
            hasBudget: selectedMonthBudget != null,
            actionLabel:
                selectedMonthBudget == null
                    ? l10n.setThisMonthBudget
                    : l10n.editBudget,
            onActionPressed: () => _openBudgetSheet(context),
            promptTitle:
                selectedMonthBudget == null && isCurrentMonth
                    ? l10n.setThisMonthBudget
                    : null,
            promptSubtitle:
                selectedMonthBudget == null && isCurrentMonth
                    ? l10n.startThisMonthWithBudget
                    : null,
          ),
          const SizedBox(height: 16),
          if (topCategory == null)
            SoftSectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceRaised,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(
                      Icons.pie_chart_outline_rounded,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(l10n.noReviewData, style: theme.textTheme.bodyLarge),
                ],
              ),
            )
          else ...[
            SoftSectionCard(
              color: topCategory.category.surfaceColor,
              accentColor: topCategory.category.color,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      TonePill(
                        label: topCategory.category.label(l10n),
                        icon: topCategory.category.icon,
                        backgroundColor: Colors.white.withValues(alpha: 0.74),
                        foregroundColor: AppColors.textPrimary,
                      ),
                      TonePill(
                        label: '${(topCategory.share * 100).round()}%',
                        backgroundColor: Colors.white.withValues(alpha: 0.74),
                        foregroundColor: AppColors.textPrimary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    l10n.topCategoryMessage(topCategory.category.label(l10n)),
                    style: theme.textTheme.titleLarge?.copyWith(height: 1.35),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Text(l10n.categoryBreakdown, style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),
            for (final item in breakdown) ...[
              CategoryBreakdownCard(
                spending: item,
                currency: settings.currency,
              ),
              if (item != breakdown.last) const SizedBox(height: 12),
            ],
          ],
          if (monthlyExpenses.isNotEmpty) ...[
            const SizedBox(height: 18),
            SoftSectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        l10n.expenseListTitle,
                        style: theme.textTheme.titleLarge,
                      ),
                      const Spacer(),
                      TonePill(label: '${monthlyExpenses.length}'),
                    ],
                  ),
                  const SizedBox(height: 18),
                  for (
                    var index = 0;
                    index < monthlyExpenses.length;
                    index++
                  ) ...[
                    ExpenseListItem(
                      expense: monthlyExpenses[index],
                      displayCurrency: settings.currency,
                    ),
                    if (index != monthlyExpenses.length - 1)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 18),
                        child: Divider(height: 1, color: AppColors.border),
                      ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _MonthSelectorCard extends StatelessWidget {
  const _MonthSelectorCard({
    required this.label,
    required this.monthLabel,
    required this.onTap,
  });

  final String label;
  final String monthLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SoftSectionCard(
      onTap: onTap,
      color: AppColors.surfaceRaised,
      accentColor: AppColors.accentMuted,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.88),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.event_note_rounded,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: theme.textTheme.titleMedium),
                const SizedBox(height: 6),
                Text(
                  monthLabel,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}

class _MonthSelectionSheet extends StatelessWidget {
  const _MonthSelectionSheet({
    required this.months,
    required this.selectedMonth,
  });

  final List<DateTime> months;
  final DateTime selectedMonth;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: SafeArea(
        top: false,
        child: SoftSectionCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.selectMonth, style: theme.textTheme.headlineSmall),
              const SizedBox(height: 16),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 360),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: months.length,
                  separatorBuilder:
                      (_, _) =>
                          const Divider(height: 1, color: AppColors.border),
                  itemBuilder: (context, index) {
                    final month = months[index];
                    final isSelected = AppDateUtils.isSameMonth(
                      month,
                      selectedMonth,
                    );

                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      onTap: () => Navigator.of(context).pop(month),
                      title: Text(
                        AppFormatters.formatMonthLabel(month, locale),
                      ),
                      trailing:
                          isSelected
                              ? const Icon(
                                Icons.check_rounded,
                                color: AppColors.accentStrong,
                              )
                              : null,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
