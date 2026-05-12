import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_days/core/localization/generated/app_localizations.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_formatters.dart';
import '../../../core/widgets/app_page.dart';
import '../../../core/widgets/round_icon_button.dart';
import '../../../core/widgets/soft_section_card.dart';
import '../../settings/controllers/settings_controller.dart';
import '../controllers/expenses_controller.dart';
import '../models/expense_insights.dart';
import '../widgets/transaction_list_item.dart';

class DayTransactionsScreen extends ConsumerWidget {
  const DayTransactionsScreen({super.key, required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context);
    final currency = ref.watch(settingsControllerProvider).currency;
    final transactions = ExpenseInsights.transactionsForDay(
      ref.watch(expensesControllerProvider),
      date,
    );

    return Scaffold(
      body: AppPage(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          children: [
            Row(
              children: [
                RoundIconButton(
                  icon: Icons.arrow_back_ios_new_rounded,
                  onPressed: () => Navigator.of(context).maybePop(),
                ),
                Expanded(
                  child: Text(
                    AppFormatters.formatMonthLabel(date, locale),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleLarge,
                  ),
                ),
                const SizedBox(width: 46),
              ],
            ),
            const SizedBox(height: 28),
            Text(
              AppFormatters.formatDayWithWeekday(date, locale),
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            if (transactions.isEmpty)
              SoftSectionCard(
                padding: const EdgeInsets.all(20),
                child: Text(
                  l10n.emptyDayTransactions,
                  style: theme.textTheme.bodyLarge,
                ),
              )
            else
              for (var index = 0; index < transactions.length; index++) ...[
                SoftSectionCard(
                  padding: const EdgeInsets.all(16),
                  color: AppColors.surfaceRaised,
                  child: TransactionListItem(
                    expense: transactions[index],
                    displayCurrency: currency,
                  ),
                ),
                if (index != transactions.length - 1) const SizedBox(height: 12),
              ],
          ],
        ),
      ),
    );
  }
}
