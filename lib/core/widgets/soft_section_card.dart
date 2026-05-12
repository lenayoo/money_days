import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class SoftSectionCard extends StatelessWidget {
  const SoftSectionCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.color,
    this.accentColor,
    this.borderColor,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final Color? accentColor;
  final Color? borderColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = color ?? AppColors.surface;
    final resolvedBorderColor =
        borderColor ??
        (accentColor == null
            ? AppColors.border
            : accentColor!.withValues(alpha: 0.12));

    final content = Ink(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: resolvedBorderColor),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(padding: padding, child: child),
    );

    if (onTap == null) {
      return Material(color: Colors.transparent, child: content);
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: content,
      ),
    );
  }
}
