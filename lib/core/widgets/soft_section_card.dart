import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class SoftSectionCard extends StatelessWidget {
  const SoftSectionCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.color,
    this.accentColor,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final Color? accentColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = color ?? AppColors.surface;

    final content = Ink(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 26,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Stack(
        children: [
          if (accentColor != null)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 94,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      accentColor!.withValues(alpha: 0.18),
                      accentColor!.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
          Padding(padding: padding, child: child),
        ],
      ),
    );

    if (onTap == null) {
      return Material(color: Colors.transparent, child: content);
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: onTap,
        child: content,
      ),
    );
  }
}
