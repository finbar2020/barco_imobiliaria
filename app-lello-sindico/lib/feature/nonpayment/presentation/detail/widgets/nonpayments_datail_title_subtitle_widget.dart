import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class DetailTitleSubtitleWidget extends StatelessWidget {
  final String title;
  final String subTitle;
  final bool usingSpacingBottom;

  const DetailTitleSubtitleWidget({
    Key? key,
    required this.title,
    required this.subTitle,
    this.usingSpacingBottom = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          title,
          style: LelloTextStyles.bodyBold(theme),
        ),
        Text(
          subTitle,
          style: LelloTextStyles.body(theme),
        ),
        usingSpacingBottom == true
            ? SizedBox(height: Dimens.spacing)
            : Container(),
      ],
    );
  }
}
