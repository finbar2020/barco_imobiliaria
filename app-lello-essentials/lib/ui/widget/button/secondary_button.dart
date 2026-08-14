import 'package:flutter/material.dart';

import '../../app_theme.dart';
import '../text/lello_text_styles.dart';

class SecondaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final Widget? child;
  final String? text;
  final Color? buttonBorderColor;
  final double? height;

  const SecondaryButton({
    Key? key,
    required this.onPressed,
    this.onLongPress,
    this.child,
    this.text,
    this.buttonBorderColor,
    this.height = 54.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        side: BorderSide(
            width: 1,
            color: buttonBorderColor ??
                LelloTheme.palleteOf(theme).secondaryButtonBorder()),
      ),
      child: Container(
        height: height,
        child: Center(
          child: this.child ??
              Text(this.text ?? "",
                  textAlign: TextAlign.center,
                  style: LelloTextStyles.button(theme)?.copyWith(
                      color: this.buttonBorderColor ??
                          theme.textTheme.bodyLarge!.color)),
        ),
      ),
      onPressed: onPressed,
      onLongPress: onLongPress,
    );
  }
}
