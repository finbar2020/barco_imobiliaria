import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import '../text/lello_text_styles.dart';

class InvertedPrimaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final Widget? child;
  final String? text;
  final ThemeData? theme;
  final Color? buttonColor;
  final double height;
  final double? width;
  final BorderSide? border;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;

  const InvertedPrimaryButton({
    Key? key,
    required this.onPressed,
    this.onLongPress,
    this.child,
    this.theme,
    this.text,
    this.buttonColor,
    this.height = 54.0,
    this.width,
    this.border,
    this.textStyle,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonTextColor = buttonColor ?? theme.primaryColor;
    final buttonTextStyle = textStyle ??
        LelloTextStyles.button(theme)!.copyWith(color: buttonTextColor);

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: LelloTheme.palleteOf(theme).background(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: border ?? BorderSide(color: buttonTextColor),
        ),
        padding: padding ?? EdgeInsets.all(0),
      ),
      onPressed: onPressed,
      onLongPress: onLongPress,
      child: Container(
        height: height,
        width: width,
        child: Center(
          child: this.child ?? Text(this.text ?? "", style: buttonTextStyle),
        ),
      ),
    );
  }
}
