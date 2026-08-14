import 'package:flutter/material.dart';

import '../../app_theme.dart';

class WarningStatusIcon extends StatelessWidget {
  final double size;
  final double iconSize;
  final Color? backgroundColor;
  final Color? iconColor;
  final IconData icon;
  final EdgeInsetsGeometry? margin;

  const WarningStatusIcon({
    super.key,
    this.size = 48,
    this.iconSize = 36,
    this.backgroundColor,
    this.iconColor,
    this.icon = Icons.priority_high_rounded,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = LelloTheme.palleteOf(theme);
    final resolvedIconColor = iconColor ?? Colors.white;

    return Container(
      width: size,
      height: size,
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor ?? palette.warning(),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: icon == Icons.priority_high_rounded
            ? _buildThinExclamation(resolvedIconColor)
            : Icon(
                icon,
                color: resolvedIconColor,
                size: iconSize,
              ),
      ),
    );
  }

  Widget _buildThinExclamation(Color color) {
    final stemWidth = iconSize * 0.14;
    final stemHeight = iconSize * 0.56;
    final dotSize = iconSize * 0.16;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: stemWidth,
          height: stemHeight,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(stemWidth),
          ),
        ),
        SizedBox(height: iconSize * 0.08),
        Container(
          width: dotSize,
          height: dotSize,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}