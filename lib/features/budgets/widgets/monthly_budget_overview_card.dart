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
    this.progress,
    this.progressLabel,
    this.statusLabel,
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
  final double? progress;
  final String? progressLabel;
  final String? statusLabel;
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
          TonePill(label: monthLabel),
          const SizedBox(height: 18),
          Text(
            totalLabel,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(totalAmount, style: theme.textTheme.headlineMedium),
          const SizedBox(height: 18),
          Row(
            children: [
              Text(
                budgetLabel,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              Text(
                budgetAmount,
                style:
                    hasBudget
                        ? theme.textTheme.titleLarge
                        : theme.textTheme.titleMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
              ),
            ],
          ),
          if (hasBudget && progress != null) ...[
            const SizedBox(height: 18),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: progress!.clamp(0.0, 1.0),
                minHeight: 10,
                backgroundColor: AppColors.surface,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.accentStrong,
                ),
              ),
            ),
            if (progressLabel != null) ...[
              const SizedBox(height: 12),
              Text(
                progressLabel!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
            if (statusLabel != null) ...[
              const SizedBox(height: 6),
              Text(statusLabel!, style: theme.textTheme.titleMedium),
            ],
          ] else if (promptTitle != null) ...[
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
          const SizedBox(height: 14),
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
