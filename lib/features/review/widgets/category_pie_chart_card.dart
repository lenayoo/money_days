import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:money_days/core/localization/generated/app_localizations.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_formatters.dart';
import '../../../core/widgets/soft_section_card.dart';
import '../../expenses/models/app_currency.dart';
import '../../expenses/models/expense_category.dart';
import '../../expenses/models/expense_insights.dart';

class CategoryPieChartCard extends StatelessWidget {
  const CategoryPieChartCard({
    super.key,
    required this.title,
    required this.emptyLabel,
    required this.breakdown,
    required this.currency,
    this.amountColor = AppColors.expense,
  });

  final String title;
  final String emptyLabel;
  final List<CategorySpending> breakdown;
  final AppCurrency currency;
  final Color amountColor;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return SoftSectionCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleLarge),
          const SizedBox(height: 20),
          if (breakdown.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Text(emptyLabel, style: theme.textTheme.bodyLarge),
            )
          else ...[
            Center(
              child: SizedBox(
                width: 210,
                height: 210,
                child: CustomPaint(
                  painter: _CategoryPieChartPainter(breakdown: breakdown),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 8,
              children: [
                for (final item in breakdown)
                  _LegendPill(
                    category: item.category,
                    label: item.category.label(l10n),
                    share: item.share,
                  ),
              ],
            ),
            const SizedBox(height: 18),
            for (var index = 0; index < breakdown.length; index++) ...[
                      _CategorySummaryTile(
                        spending: breakdown[index],
                        currency: currency,
                        amountColor: amountColor,
                      ),
              if (index != breakdown.length - 1) const SizedBox(height: 12),
            ],
          ],
        ],
      ),
    );
  }
}

class _LegendPill extends StatelessWidget {
  const _LegendPill({
    required this.category,
    required this.label,
    required this.share,
  });

  final ExpenseCategory category;
  final String label;
  final double share;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: category.chartColor,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '$label ${_formatShare(share)}',
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _CategorySummaryTile extends StatelessWidget {
  const _CategorySummaryTile({
    required this.spending,
    required this.currency,
    required this.amountColor,
  });

  final CategorySpending spending;
  final AppCurrency currency;
  final Color amountColor;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final theme = Theme.of(context);
    final category = spending.category;

    return SoftSectionCard(
      padding: const EdgeInsets.all(14),
      color: AppColors.surfaceRaised,
      accentColor: category.chartColor,
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: category.surfaceColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(category.icon, color: category.color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        category.label(l10n),
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: category.chartColor.withValues(alpha: 0.28),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        _formatShare(spending.share),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.recordCount(spending.count),
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            AppFormatters.formatCurrency(
              spending.totalForCurrency(currency),
              currency,
              locale,
            ),
            style: theme.textTheme.titleMedium?.copyWith(color: amountColor),
          ),
        ],
      ),
    );
  }
}

class _CategoryPieChartPainter extends CustomPainter {
  const _CategoryPieChartPainter({required this.breakdown});

  final List<CategorySpending> breakdown;

  @override
  void paint(Canvas canvas, Size size) {
    if (breakdown.isEmpty) {
      return;
    }

    final rect = Offset.zero & size;
    final chartRect = Rect.fromCircle(
      center: rect.center,
      radius: math.min(size.width, size.height) / 2,
    );
    var startAngle = -math.pi / 2;

    for (final item in breakdown) {
      final sweepAngle = (math.pi * 2) * item.share;
      canvas.drawArc(
        chartRect,
        startAngle,
        sweepAngle,
        true,
        Paint()..color = item.category.chartColor.withValues(alpha: 0.96),
      );
      startAngle += sweepAngle;
    }

    canvas.drawCircle(
      rect.center,
      chartRect.width * 0.18,
      Paint()..color = AppColors.surface,
    );
  }

  @override
  bool shouldRepaint(covariant _CategoryPieChartPainter oldDelegate) {
    return oldDelegate.breakdown != breakdown;
  }
}

String _formatShare(double share) {
  return '${(share * 100).toStringAsFixed(1)}%';
}
