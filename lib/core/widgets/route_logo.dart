import 'package:flutter/material.dart';

import '../constants/app_assets.dart';

class RouteLogo extends StatelessWidget {
  const RouteLogo({super.key, this.width = 180});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppAssets.routeLogo,
      width: width,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
    );
  }
}
