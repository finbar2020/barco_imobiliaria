import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class AgreementsScaleBar extends StatelessWidget {
  final Color color;
  final double value;

  const AgreementsScaleBar({
    Key? key,
    required this.color,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
                right: Dimens.spacingMedium,
                bottom: Dimens.spacingSmall,
                top: Dimens.spacingSmall),
            child: Container(
              decoration: BoxDecoration(
                  color: LelloTheme.palleteOf(theme).separator(),
                  borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(50), right: Radius.circular(50))),
              child: Row(
                children: [
                  Flexible(
                    flex: (value).toInt(),
                    child: Container(
                      height: 10,
                      decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(50),
                              right: Radius.circular(50))),
                    ),
                  ),
                  Flexible(
                    flex: (100 - value).toInt(),
                    child: Container(
                      height: 10,
                      decoration: BoxDecoration(
                          color: LelloTheme.palleteOf(theme).separator(),
                          borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(50),
                              right: Radius.circular(50))),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Text(
          "${(value).toStringAsFixed(0)}%",
          style: LelloTextStyles.body(theme)!.copyWith(
            color: color,
          ),
        ),
      ],
    );
  }
}
