import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class AutoSizeTextWidget extends StatelessWidget {
  const AutoSizeTextWidget({
    Key? key,
    required this.text,
    this.style,
    this.maxLines,
    this.overflow,
  }) : super(key: key);

  final String text;
  final TextStyle? style;
  final TextOverflow? overflow;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      text,
      style: style,
      maxLines: maxLines,
      overflow: overflow,
      overflowReplacement: overflow == null
          ? FittedBox(
              child: Text(
                text,
                style: style,
              ),
            )
          : null,
      textAlign: TextAlign.center,
    );
  }
}