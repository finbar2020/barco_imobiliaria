import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lello/core/app_review/app_review.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/feature/resin/domain/entity/resin_params.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_type.dart';
import 'package:lello/feature/resin/presentation/resin_history_advance/page/resin_history_advance_page.dart';
import 'package:lello/feature/resin/presentation/resin_history_refund/page/resin_history_refund_page.dart';
import 'package:lello/feature/resin/presentation/resin_new_advance/page/resin_new_advance_page.dart';
import 'package:lello/feature/resin/presentation/resin_new_refund/page/resin_new_refund_page.dart';

class ResinCreateRefundSuccessWidget extends StatelessWidget {
  final ResinParams params;
  final ResinRefund? refund;
  const ResinCreateRefundSuccessWidget({
    Key? key,
    required this.params,
    this.refund,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      backgroundColor: LelloTheme.palleteOf(theme).success(),
      body: Padding(
        padding: EdgeInsets.all(Dimens.spacingXLarge),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset("assets/ic_success.svg", width: 92, height: 92),
              SizedBox(height: Dimens.spacingMedium),
              Text(
                refund?.type == ResinRefundType.advance
                    ? getString(context, "resin_create_advance_success_title")
                    : getString(context, "resin_create_refund_success_title"),
                textAlign: TextAlign.center,
                style: LelloTextStyles.title(theme)?.copyWith(
                    color: LelloTheme.palleteOf(theme).customColor()),
              ),
              SizedBox(height: Dimens.spacingLarge),
              Text(
                refund?.type == ResinRefundType.advance
                    ? getString(
                        context, "resin_create_advance_success_subtitle")
                    : getString(
                        context, "resin_create_refund_success_subtitle"),
                textAlign: TextAlign.center,
                style: LelloTextStyles.subtitle(theme)?.copyWith(
                    color: LelloTheme.palleteOf(theme).customColor()),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: Dimens.spacingMedium, vertical: Dimens.spacingLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 54.0,
              child: PrimaryButton(
                buttonColor: LelloTheme.palleteOf(theme).customColor(),
                child: Text(
                  getString(context, "ok"),
                  style: LelloTextStyles.button(theme)
                      ?.copyWith(color: LelloTheme.palleteOf(theme).text()),
                ),
                onPressed: () {
                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    AppReview.call(context: context);
                    if (refund?.type == ResinRefundType.advance) {
                      Navigator.popAndPushNamed(
                        context,
                        ApplicationRoute.resinAdvanceHistory,
                        arguments: ResinHistoryAdvancePageArgs(params),
                      );
                    } else if (refund?.type == ResinRefundType.refund) {
                      Navigator.popAndPushNamed(
                        context,
                        ApplicationRoute.resinRefundHistory,
                        arguments: ResinHistoryRefundPageArgs(params),
                      );
                    } else {
                      Navigator.pop(context);
                    }
                  });
                },
              ),
            ),
            SizedBox(height: Dimens.spacingMedium),
            Container(
              height: 54.0,
              child: SecondaryButton(
                child: Text(
                  refund?.type == ResinRefundType.advance
                      ? getString(
                          context, "resin_create_advance_success_request_new")
                      : getString(
                          context, "resin_create_refund_success_request_new"),
                  style: LelloTextStyles.button(theme)?.copyWith(
                      color: LelloTheme.palleteOf(theme).buttonText()),
                ),
                onPressed: () {
                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    AppReview.call(context: context);
                    refund?.type == ResinRefundType.advance
                        ? Navigator.popAndPushNamed(
                            context, ApplicationRoute.resinAdvanceNew,
                            arguments:
                                ResinNewAdvancePageArgs(resinParams: params))
                        : Navigator.popAndPushNamed(
                            context, ApplicationRoute.resinRefundNew,
                            arguments:
                                ResinNewRefundPageArgs(resinParams: params));
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
