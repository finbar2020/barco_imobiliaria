import 'package:flutter/material.dart';

import '../../app_theme.dart';
import '../../dimens.dart';

class AltSection extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const AltSection({Key? key, required this.child, this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
        padding: this.padding ?? EdgeInsets.all(Dimens.spacingMedium),
        decoration: BoxDecoration(
            color: LelloTheme.palleteOf(theme).separator(),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8.0),
              bottomRight: Radius.circular(8.0),
            )),
        child: this.child);
  }
}
