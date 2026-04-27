import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/soft_section_card.dart';

class SummaryCard extends StatelessWidget {
  const SummaryCard({
    super.key,
    required this.title,
    required this.amount,
    required this.supportingText,
    required this.icon,
  });

  final String title;
  final String amount;
  final String supportingText;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SoftSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.surfaceMuted,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 20),
          Text(title, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(amount, style: theme.textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(supportingText, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}
