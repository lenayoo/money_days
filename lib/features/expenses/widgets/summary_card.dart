import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/soft_section_card.dart';
import '../../../core/widgets/tone_pill.dart';

class SummaryCard extends StatelessWidget {
  const SummaryCard({
    super.key,
    required this.title,
    required this.amount,
    required this.supportingText,
    required this.icon,
    this.highlighted = false,
    this.accentColor,
  });

  final String title;
  final String amount;
  final String supportingText;
  final IconData icon;
  final bool highlighted;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardAccentColor = accentColor ?? AppColors.accentMuted;

    return SoftSectionCard(
      color: highlighted ? AppColors.surfaceRaised : AppColors.surface,
      accentColor: highlighted ? cardAccentColor : null,
      padding: EdgeInsets.all(highlighted ? 24 : 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: highlighted ? 48 : 42,
                height: highlighted ? 48 : 42,
                decoration: BoxDecoration(
                  color: AppColors.surface.withValues(alpha: 0.84),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: AppColors.textPrimary),
              ),
              const Spacer(),
              TonePill(label: supportingText),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            amount,
            style:
                highlighted
                    ? theme.textTheme.displaySmall
                    : theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: 10),
          Text(
            supportingText,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}
