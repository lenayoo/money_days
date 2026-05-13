import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:money_days/core/localization/generated/app_localizations.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_formatters.dart';
import '../../../core/widgets/soft_section_card.dart';
import '../../budgets/models/monthly_budget.dart';
import '../../expenses/models/app_currency.dart';
import '../../expenses/models/expense_category.dart';
import '../../expenses/models/expense_insights.dart';
import '../../expenses/models/transaction_type.dart';

Future<void> showMonthlySummaryShareSheet({
  required BuildContext context,
  required DateTime month,
  required TransactionType type,
  required AppCurrency currency,
  required double totalInBase,
  required MonthlyBudget? budget,
  required List<CategorySpending> breakdown,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder:
        (context) => _MonthlySummaryShareSheet(
          month: month,
          type: type,
          currency: currency,
          totalInBase: totalInBase,
          budget: budget,
          breakdown: breakdown,
        ),
  );
}

class _MonthlySummaryShareSheet extends StatefulWidget {
  const _MonthlySummaryShareSheet({
    required this.month,
    required this.type,
    required this.currency,
    required this.totalInBase,
    required this.budget,
    required this.breakdown,
  });

  final DateTime month;
  final TransactionType type;
  final AppCurrency currency;
  final double totalInBase;
  final MonthlyBudget? budget;
  final List<CategorySpending> breakdown;

  @override
  State<_MonthlySummaryShareSheet> createState() =>
      _MonthlySummaryShareSheetState();
}

class _MonthlySummaryShareSheetState extends State<_MonthlySummaryShareSheet> {
  final GlobalKey _shareCardKey = GlobalKey();
  bool _isSharing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      _shareCard(closeAfterShare: true);
    });
  }

  Future<void> _shareCard({
    bool closeAfterShare = false,
    bool retryIfBoundaryMissing = true,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final boundary =
        _shareCardKey.currentContext?.findRenderObject()
            as RenderRepaintBoundary?;
    if (boundary == null) {
      if (retryIfBoundaryMissing && mounted) {
        await Future<void>.delayed(const Duration(milliseconds: 60));
        if (!mounted) {
          return;
        }
        return _shareCard(
          closeAfterShare: closeAfterShare,
          retryIfBoundaryMissing: false,
        );
      }
      return;
    }

    setState(() {
      _isSharing = true;
    });

    try {
      await Future<void>.delayed(const Duration(milliseconds: 20));
      final image = await boundary.toImage(pixelRatio: 3);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final bytes = byteData?.buffer.asUint8List();

      if (bytes == null) {
        throw StateError('Share image bytes were empty.');
      }

      final monthLabel = AppFormatters.formatMonthLabel(widget.month, locale);
      final totalAmount = AppFormatters.formatCurrency(
        widget.currency.fromBaseAmount(widget.totalInBase),
        widget.currency,
        locale,
      );
      final sharePositionOrigin =
          boundary.localToGlobal(Offset.zero) & boundary.size;

      await Share.shareXFiles(
        [
          XFile.fromData(
            bytes,
            mimeType: 'image/png',
            name:
                'money_days_${widget.month.year}_${widget.month.month.toString().padLeft(2, '0')}.png',
          ),
        ],
        subject: 'Money Days',
        text: l10n.shareSummaryMessage(monthLabel, totalAmount),
        sharePositionOrigin: sharePositionOrigin,
      );

      if (mounted && closeAfterShare) {
        Navigator.of(context).maybePop();
      }
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.shareFailedMessage)),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSharing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        MediaQuery.viewInsetsOf(context).bottom + 16,
      ),
      child: SafeArea(
        top: false,
        child: SoftSectionCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.shareSummaryTitle, style: theme.textTheme.headlineSmall),
              const SizedBox(height: 6),
              Text(
                l10n.shareSummarySubtitle,
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 18),
              RepaintBoundary(
                key: _shareCardKey,
                child: _MonthlySummaryShareCard(
                  month: widget.month,
                  type: widget.type,
                  currency: widget.currency,
                  totalInBase: widget.totalInBase,
                  budget: widget.budget,
                  breakdown: widget.breakdown,
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _isSharing ? null : _shareCard,
                child: Text(
                  _isSharing
                      ? l10n.preparingShareCard
                      : l10n.shareSummaryButton,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MonthlySummaryShareCard extends StatelessWidget {
  const _MonthlySummaryShareCard({
    required this.month,
    required this.type,
    required this.currency,
    required this.totalInBase,
    required this.budget,
    required this.breakdown,
  });

  final DateTime month;
  final TransactionType type;
  final AppCurrency currency;
  final double totalInBase;
  final MonthlyBudget? budget;
  final List<CategorySpending> breakdown;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final theme = Theme.of(context);
    final monthLabel = AppFormatters.formatMonthLabel(month, locale);
    final totalAmount = AppFormatters.formatCurrency(
      currency.fromBaseAmount(totalInBase),
      currency,
      locale,
    );
    final topCategories = breakdown.take(3).toList(growable: false);

    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.appName,
              style: theme.textTheme.labelLarge?.copyWith(
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 18),
            Text(monthLabel, style: theme.textTheme.headlineMedium),
            const SizedBox(height: 10),
            Text(
              type == TransactionType.expense
                  ? l10n.monthlyExpense
                  : l10n.monthlyIncome,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 6),
            Text(
              totalAmount,
              style: theme.textTheme.displaySmall?.copyWith(
                color:
                    type == TransactionType.expense
                        ? AppColors.expense
                        : AppColors.income,
              ),
            ),
            if (type == TransactionType.expense && budget != null) ...[
              const SizedBox(height: 18),
              _ShareInfoRow(
                label: l10n.monthlyBudget,
                value: AppFormatters.formatCurrency(
                  budget!.amountForCurrency(currency),
                  currency,
                  locale,
                ),
              ),
              const SizedBox(height: 8),
              _ShareInfoRow(
                label: l10n.remainingBudget,
                value: _formatBudgetDifference(
                  budget: budget!,
                  expenseInBase: totalInBase,
                  currency: currency,
                  locale: locale,
                ),
              ),
            ],
            if (topCategories.isNotEmpty) ...[
              const SizedBox(height: 18),
              Text(
                type == TransactionType.expense
                    ? l10n.spendingByCategory
                    : l10n.incomeByCategory,
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 10),
              for (final item in topCategories) ...[
                _ShareInfoRow(
                  label: item.category.label(l10n),
                  value: AppFormatters.formatCurrency(
                    item.totalForCurrency(currency),
                    currency,
                    locale,
                  ),
                ),
                if (item != topCategories.last) const SizedBox(height: 8),
              ],
            ],
            const Spacer(),
            Text(
              l10n.shareCardCaption,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShareInfoRow extends StatelessWidget {
  const _ShareInfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(child: Text(label, style: theme.textTheme.bodyLarge)),
        const SizedBox(width: 12),
        Text(value, style: theme.textTheme.titleMedium),
      ],
    );
  }
}

String _formatBudgetDifference({
  required MonthlyBudget budget,
  required double expenseInBase,
  required AppCurrency currency,
  required Locale locale,
}) {
  final differenceInBase = budget.amountInBaseCurrency - expenseInBase;
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
