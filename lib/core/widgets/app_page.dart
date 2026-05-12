import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AppPage extends StatelessWidget {
  const AppPage({
    super.key,
    required this.child,
    this.topSafeArea = true,
    this.bottomSafeArea = false,
    this.maxWidth = 920,
  });

  final Widget child;
  final bool topSafeArea;
  final bool bottomSafeArea;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.background,
      child: SafeArea(
        top: topSafeArea,
        bottom: bottomSafeArea,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: child,
          ),
        ),
      ),
    );
  }
}
