import 'package:flutter/material.dart';

import '../../app_theme.dart';

class SuccessStatusIcon extends StatelessWidget {
  final double size;
  final double iconSize;
  final Color? backgroundColor;
  final Color? iconColor;
  final IconData icon;
  final EdgeInsetsGeometry? margin;

  const SuccessStatusIcon({
    super.key,
    this.size = 48,
    this.iconSize = 36,
    this.backgroundColor,
    this.iconColor,
    this.icon = Icons.check_rounded,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = LelloTheme.palleteOf(theme);

    return Container(
      width: size,
      height: size,
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor ?? palette.success(),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: iconColor ?? Colors.white,
        size: iconSize,
      ),
    );
  }
}
