import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/soft_section_card.dart';
import '../../../core/widgets/tone_pill.dart';

class MonthlyBudgetOverviewCard extends StatelessWidget {
  const MonthlyBudgetOverviewCard({
    super.key,
    required this.monthLabel,
    required this.totalLabel,
    required this.totalAmount,
    required this.budgetLabel,
    required this.budgetAmount,
    required this.hasBudget,
    required this.actionLabel,
    required this.onActionPressed,
    this.promptTitle,
    this.promptSubtitle,
  });

  final String monthLabel;
  final String totalLabel;
  final String totalAmount;
  final String budgetLabel;
  final String budgetAmount;
  final bool hasBudget;
  final String actionLabel;
  final VoidCallback onActionPressed;
  final String? promptTitle;
  final String? promptSubtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SoftSectionCard(
      color: AppColors.surfaceRaised,
      accentColor: AppColors.accentMuted,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.surface.withValues(alpha: 0.88),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.calendar_month_rounded,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              TonePill(label: monthLabel),
            ],
          ),
          const SizedBox(height: 22),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _MetricColumn(
                  label: totalLabel,
                  value: totalAmount,
                  emphasized: true,
                ),
              ),
              const SizedBox(width: 18),
              Container(width: 1, height: 76, color: AppColors.border),
              const SizedBox(width: 18),
              Expanded(
                child: _MetricColumn(
                  label: budgetLabel,
                  value: budgetAmount,
                  emphasized: hasBudget,
                ),
              ),
            ],
          ),
          if (promptTitle != null) ...[
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface.withValues(alpha: 0.84),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(promptTitle!, style: theme.textTheme.titleMedium),
                  if (promptSubtitle != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      promptSubtitle!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: onActionPressed,
            icon: const Icon(Icons.edit_note_rounded),
            label: Text(actionLabel),
          ),
        ],
      ),
    );
  }
}

class _MetricColumn extends StatelessWidget {
  const _MetricColumn({
    required this.label,
    required this.value,
    required this.emphasized,
  });

  final String label;
  final String value;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          value,
          style:
              emphasized
                  ? theme.textTheme.headlineSmall
                  : theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
        ),
      ],
    );
  }
}
