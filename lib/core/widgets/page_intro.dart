import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'tone_pill.dart';

class PageIntro extends StatelessWidget {
  const PageIntro({
    super.key,
    required this.title,
    required this.subtitle,
    this.eyebrow,
    this.trailing,
  });

  final String title;
  final String subtitle;
  final String? eyebrow;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (eyebrow != null) ...[
                TonePill(label: eyebrow!),
                const SizedBox(height: 16),
              ],
              Text(title, style: theme.textTheme.headlineLarge),
              const SizedBox(height: 10),
              Text(
                subtitle,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        if (trailing != null) ...[const SizedBox(width: 12), trailing!],
      ],
    );
  }
}
