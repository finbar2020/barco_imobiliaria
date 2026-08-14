import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:in_app_review/in_app_review.dart';

import '../../../app_localization.dart';
import '../../../enum/app_origin_enum.dart';
import '../../app_theme.dart';
import '../../dimens.dart';
import '../text/lello_text_styles.dart';

class AppReviewDialogWidget extends StatefulWidget {
  final appOriginEnum;
  const AppReviewDialogWidget(
      {Key? key, required AppOriginEnum this.appOriginEnum})
      : super(key: key);

  @override
  State<AppReviewDialogWidget> createState() => _AppReviewDialogWidgetState();
}

class _AppReviewDialogWidgetState extends State<AppReviewDialogWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final InAppReview inAppReview = InAppReview.instance;
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: SvgPicture.asset("assets/ic_rate_app.svg"),
            ),
            SizedBox(height: Dimens.spacing),
            Text(
              getString(
                  context,
                  widget.appOriginEnum == AppOriginEnum.manager
                      ? "rate_dialog_title_sindico"
                      : "rate_dialog_title_morar"),
              textAlign: TextAlign.center,
              style: LelloTextStyles.subtitle(theme)!.copyWith(
                color: LelloTheme.palleteOf(theme).primary(),
              ),
            ),
            SizedBox(height: Dimens.spacing),
            Text(
              getString(context, "rate_dialog_subtitle"),
              textAlign: TextAlign.center,
              style: LelloTextStyles.subBody(theme),
            ),
            SizedBox(height: Dimens.spacingMedium),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: LelloTheme.palleteOf(theme).customColor(),
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: LelloTheme.palleteOf(theme).textOpaque(),
                      ),
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(
                  getString(context, "rate_dialog_button"),
                  style: LelloTextStyles.button(theme)!
                      .copyWith(color: LelloTheme.palleteOf(theme).text()),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  inAppReview.requestReview();
                },
              ),
            ),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: LelloTheme.palleteOf(theme).customColor(),
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: LelloTheme.palleteOf(theme).textOpaque(),
                      ),
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(
                  getString(context, "rate_dialog_second_button"),
                  style: LelloTextStyles.button(theme)!
                      .copyWith(color: LelloTheme.palleteOf(theme).primary()),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
