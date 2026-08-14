import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TdbOnBoardingPage extends StatelessWidget {
  final String assetPath;
  final String description;
  const TdbOnBoardingPage(
      {Key? key, required this.assetPath, required this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: SvgPicture.asset(assetPath, width: 300, height: 300),
        ),
        SizedBox(height: Dimens.spacingMedium),
        Text(
          getString(context, description),
          textScaleFactor: 1.0,
          style: LelloTextStyles.titleBold(theme)
              ?.copyWith(color: LelloTheme.palleteOf(theme).text()),
        )
      ],
    );
  }
}
