import 'package:flutter/material.dart';

import '../text/lello_text_styles.dart';

class TertiaryButton extends StatelessWidget {
  final VoidCallback onPressed;
  final VoidCallback? onLongPress;
  final Widget? child;
  final String? text;
  final TextStyle? style;

  const TertiaryButton(
      {Key? key,
      required this.onPressed,
      this.onLongPress,
      this.child,
      this.text,
      this.style})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextButton(
      child: this.child ??
          Text(this.text ?? "",
              // `style` completo mesclado ao estilo padrão (cor de link).
              style: LelloTextStyles.inverseButton(theme)?.merge(style)),
      onPressed: onPressed,
      onLongPress: onLongPress,
    );
  }
}
