import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:essentials/essentials.dart';

class InfoTooltipWidget extends StatelessWidget {
  final String message;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? iconColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;

  const InfoTooltipWidget({
    super.key,
    required this.message,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.iconColor,
    this.padding,
    this.margin,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = LelloTheme.palleteOf(theme);

    return Container(
      margin: margin ?? const EdgeInsets.symmetric(vertical: 4.0),
      padding: padding ??
          const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: backgroundColor ?? palette.buttonSystem().withOpacity(0.1),
        borderRadius: borderRadius ?? BorderRadius.circular(6.0),
        border: Border.all(
          color: palette.buttonSystem().withOpacity(0.3),
          width: 1.0,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            "assets/ic_info_blue.svg",
            width: 16,
            height: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: textColor ?? palette.buttonSystem(),
                fontSize: 12,
                fontWeight: FontWeight.w400,
                height: 1.3,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// Variações pré-definidas para diferentes tipos de mensagem
class InfoTooltip extends InfoTooltipWidget {
  const InfoTooltip({
    super.key,
    required super.message,
    super.padding,
    super.margin,
    super.borderRadius,
  }) : super(
          icon: Icons.info_outline,
        );
}

class WarningTooltip extends StatelessWidget {
  final String message;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;

  const WarningTooltip({
    super.key,
    required this.message,
    this.padding,
    this.margin,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = LelloTheme.palleteOf(theme);

    return InfoTooltipWidget(
      message: message,
      icon: Icons.warning_amber_outlined,
      backgroundColor: palette.warning().withOpacity(0.1),
      textColor: palette.warning(),
      iconColor: palette.warning(),
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
    );
  }
}

class SuccessTooltip extends StatelessWidget {
  final String message;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;

  const SuccessTooltip({
    super.key,
    required this.message,
    this.padding,
    this.margin,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = LelloTheme.palleteOf(theme);

    return InfoTooltipWidget(
      message: message,
      icon: Icons.check_circle_outline,
      backgroundColor: palette.success().withOpacity(0.1),
      textColor: palette.success(),
      iconColor: palette.success(),
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
    );
  }
}

class ErrorTooltip extends StatelessWidget {
  final String message;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;

  const ErrorTooltip({
    super.key,
    required this.message,
    this.padding,
    this.margin,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = LelloTheme.palleteOf(theme);

    return InfoTooltipWidget(
      message: message,
      icon: Icons.error_outline,
      backgroundColor: palette.primary().withOpacity(0.1),
      textColor: palette.primary(),
      iconColor: palette.primary(),
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
    );
  }
}
