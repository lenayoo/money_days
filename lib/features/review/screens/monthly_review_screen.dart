import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_days/core/localization/generated/app_localizations.dart';

import '../../../core/utils/app_formatters.dart';
import '../../../core/widgets/soft_section_card.dart';
import '../../expenses/controllers/expenses_controller.dart';
import '../../expenses/models/expense_insights.dart';
import '../../expenses/models/expense_category.dart';
import '../../expenses/widgets/summary_card.dart';
import '../../settings/controllers/settings_controller.dart';
import '../widgets/category_breakdown_card.dart';

class MonthlyReviewScreen extends ConsumerWidget {
  const MonthlyReviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context);
    final settings = ref.watch(settingsControllerProvider);
    final expenses = ref.watch(expensesControllerProvider);

    final month = DateTime.now();
    final total = ExpenseInsights.totalForMonth(expenses, month);
    final breakdown = ExpenseInsights.categoryTotalsForMonth(expenses, month);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        children: [
          Text(l10n.monthlyReviewTitle, style: theme.textTheme.headlineLarge),
          const SizedBox(height: 8),
          Text(l10n.monthlyReviewSubtitle, style: theme.textTheme.bodyLarge),
          const SizedBox(height: 24),
          SummaryCard(
            title: l10n.monthlyTotal,
            amount: AppFormatters.formatCurrency(
              total,
              settings.currency,
              locale,
            ),
            supportingText: AppFormatters.formatMonthLabel(month, locale),
            icon: Icons.pie_chart_rounded,
          ),
          const SizedBox(height: 16),
          if (breakdown.isEmpty)
            SoftSectionCard(
              child: Text(l10n.noReviewData, style: theme.textTheme.bodyLarge),
            )
          else ...[
            SoftSectionCard(
              child: Text(
                l10n.topCategoryMessage(breakdown.first.category.label(l10n)),
                style: theme.textTheme.bodyLarge,
              ),
            ),
            const SizedBox(height: 16),
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
        ],
      ),
    );
  }
}
