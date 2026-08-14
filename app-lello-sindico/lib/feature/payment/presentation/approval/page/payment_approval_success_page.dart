import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lello/core/app_review/app_review.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/feature/payment/domain/entity/payment_approval.dart';
import 'package:lello/feature/payment/domain/entity/payment_approval_type.dart';

class PaymentApprovalSuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    PaymentApproval approval =
        ModalRoute.of(context)!.settings.arguments as PaymentApproval;
    return Theme(
      data: theme,
      child: Scaffold(
        backgroundColor: LelloTheme.palleteOf(theme).success(),
        body: Padding(
          padding: EdgeInsets.all(Dimens.spacingLarge),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset("assets/ic_success.svg",
                    width: 92, height: 92),
                SizedBox(height: Dimens.spacingLarge),
                Text(getTitle(approval, context),
                    textAlign: TextAlign.center,
                    style: LelloTextStyles.headline(theme)!
                        .copyWith(color: Colors.white)),
                SizedBox(height: Dimens.spacingLarge),
                Theme(
                  data: theme.copyWith(
                    textTheme: theme.textTheme.copyWith(
                        labelLarge: theme.textTheme.labelLarge
                            ?.copyWith(color: Colors.black)),
                  ),
                  child: PrimaryButton(
                      buttonColor: Colors.white,
                      text: getString(context, "close"),
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, ApplicationRoute.home, (route) => false);
                        AppReview.call(context: context);
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String getTitle(PaymentApproval approval, BuildContext context) {
    String key = "success";

    switch (approval.type) {
      case PaymentApprovalType.approve:
        key = "payment_approval_approved";
        break;
      case PaymentApprovalType.suspend:
        key = "payment_approval_suspended";
        break;
      case PaymentApprovalType.cancel:
        key = "payment_approval_cancelled";
        break;
      case null:
        key = "success";
    }

    return getString(context, key);
  }
}
