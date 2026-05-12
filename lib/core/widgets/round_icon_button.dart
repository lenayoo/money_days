import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class RoundIconButton extends StatelessWidget {
  const RoundIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = 46,
    this.backgroundColor,
    this.foregroundColor,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final double size;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: IconButton(
        onPressed: onPressed,
        style: IconButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.surface,
          foregroundColor: foregroundColor ?? AppColors.textPrimary,
          disabledBackgroundColor: AppColors.surfaceMuted,
          disabledForegroundColor: AppColors.textTertiary,
          side: const BorderSide(color: AppColors.border),
          shape: const CircleBorder(),
        ),
        icon: Icon(icon, size: 20),
      ),
    );
  }
}
