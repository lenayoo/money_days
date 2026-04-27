import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AppPage extends StatelessWidget {
  const AppPage({
    super.key,
    required this.child,
    this.topSafeArea = true,
    this.bottomSafeArea = false,
    this.maxWidth = 760,
  });

  final Widget child;
  final bool topSafeArea;
  final bool bottomSafeArea;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.background, AppColors.backgroundDeep],
        ),
      ),
      child: Stack(
        children: [
          const _BackgroundOrbs(),
          SafeArea(
            top: topSafeArea,
            bottom: bottomSafeArea,
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BackgroundOrbs extends StatelessWidget {
  const _BackgroundOrbs();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -60,
            right: -20,
            child: _Orb(
              size: 220,
              color: AppColors.accentMuted.withValues(alpha: 0.32),
            ),
          ),
          Positioned(
            top: 180,
            left: -90,
            child: _Orb(
              size: 180,
              color: AppColors.surface.withValues(alpha: 0.8),
            ),
          ),
          Positioned(
            bottom: -48,
            right: 42,
            child: _Orb(
              size: 150,
              color: AppColors.surfaceMuted.withValues(alpha: 0.72),
            ),
          ),
        ],
      ),
    );
  }
}

class _Orb extends StatelessWidget {
  const _Orb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
