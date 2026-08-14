import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class SimpleTooltipWidget extends StatelessWidget {
  final String message;
  final String? title;
  final IconData icon;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? iconBackgroundColor;
  final Color? iconColor;
  final Color? textColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final TextStyle? titleStyle;
  final TextStyle? messageStyle;
  final double iconTopOffset;

  const SimpleTooltipWidget({
    super.key,
    required this.message,
    this.title,
    this.icon = Icons.info_outline,
    this.backgroundColor,
    this.borderColor,
    this.iconBackgroundColor,
    this.iconColor,
    this.textColor,
    this.padding,
    this.margin,
    this.borderRadius,
    this.titleStyle,
    this.messageStyle,
    this.iconTopOffset = 0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = LelloTheme.palleteOf(theme);
    final resolvedTextColor = textColor ?? palette.routineBlue();
    final defaultTitleStyle = LelloTextStyles.caption(theme)?.copyWith(
      color: resolvedTextColor,
      fontWeight: FontWeight.w700,
    );
    final defaultMessageStyle = LelloTextStyles.caption(theme)?.copyWith(
      color: resolvedTextColor,
      fontWeight: FontWeight.w500,
    );

    return Container(
      width: double.infinity,
      margin: margin,
      padding: padding ?? const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: backgroundColor ?? palette.routineBlue().withAlpha(20),
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        border: Border.all(
          color: borderColor ?? palette.routineBlue(),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: iconTopOffset),
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: iconBackgroundColor ?? palette.routineBlue(),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 10,
                color: iconColor ?? Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: title == null
                ? Text(
                    message,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: messageStyle ?? defaultMessageStyle,
                  )
                : Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: title,
                          style: titleStyle ?? defaultTitleStyle,
                        ),
                        TextSpan(
                          text: ' $message',
                          style: messageStyle ?? defaultMessageStyle,
                        ),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
          ),
        ],
      ),
    );
  }
}
