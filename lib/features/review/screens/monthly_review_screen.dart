import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_days/core/localization/generated/app_localizations.dart';
import 'package:money_days/core/theme/app_colors.dart';

import '../../../core/utils/app_formatters.dart';
import '../../../core/widgets/app_page.dart';
import '../../../core/widgets/page_intro.dart';
import '../../../core/widgets/soft_section_card.dart';
import '../../../core/widgets/tone_pill.dart';
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
    final topCategory = breakdown.isEmpty ? null : breakdown.first;

    return AppPage(
      bottomSafeArea: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 128),
        children: [
          PageIntro(
            eyebrow: AppFormatters.formatMonthLabel(month, locale),
            title: l10n.monthlyReviewTitle,
            subtitle: l10n.monthlyReviewSubtitle,
          ),
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
            highlighted: true,
            accentColor: AppColors.accentMuted,
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
        ],
      ),
    );
  }
}
