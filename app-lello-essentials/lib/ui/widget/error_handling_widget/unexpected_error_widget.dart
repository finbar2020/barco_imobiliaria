import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app_localization.dart';
import '../../dimens.dart';
import '../text/lello_text_styles.dart';

class UnexpectedErrorWidget extends StatelessWidget {
  const UnexpectedErrorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(Dimens.spacingLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/ic_unexpected_error.svg",
              height: 200,
            ),
            SizedBox(height: Dimens.spacingMedium),
            Text(getString(context, "unexpected_error_title"),
                style: LelloTextStyles.headline(theme)),
            Text(getString(context, "unexpected_error_subtitle"),
                textAlign: TextAlign.center,
                style: LelloTextStyles.headline(theme)),
            SizedBox(height: Dimens.spacing),
            Text(getString(context, "unexpected_error_description"),
                textAlign: TextAlign.center,
                style: LelloTextStyles.titleSmallBold(theme)),
          ],
        ),
      ),
    );
  }
}
