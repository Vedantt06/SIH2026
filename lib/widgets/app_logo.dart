import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';

class AppLogo extends StatelessWidget {
  final double size;

  const AppLogo({
    super.key,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppTheme.primary,
        borderRadius: BorderRadius.circular(size * 0.28),
      ),
      child: Icon(
        Icons.pets,
        color: Colors.white,
        size: size * 0.52,
      ),
    );
  }
}