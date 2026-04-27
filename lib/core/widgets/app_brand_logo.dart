import 'package:flutter/material.dart';

import '../constants/asset_paths.dart';

class AppBrandLogo extends StatelessWidget {
  const AppBrandLogo({super.key, this.width = 176, this.semanticLabel});

  final double width;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AssetPaths.appIcon,
      width: width,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.medium,
      semanticLabel: semanticLabel,
    );
  }
}
