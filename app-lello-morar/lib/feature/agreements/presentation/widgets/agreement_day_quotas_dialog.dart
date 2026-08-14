import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AgreementDayQuotasDialog extends StatelessWidget {
  final bool pendingAgreement;
  const AgreementDayQuotasDialog({
    Key? key,
    this.pendingAgreement = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: SvgPicture.asset("assets/ic_billet_alert.svg"),
                ),
                SizedBox(height: Dimens.spacing),
                Text("${getString(context, "chat_error_title")}!",
                    textAlign: TextAlign.center,
                    style: LelloTextStyles.subtitleBold(theme)!.copyWith(
                        color: LelloTheme.palleteOf(theme).textLightest())),
                SizedBox(height: Dimens.spacing),
                Text(
                    getString(
                        context,
                        pendingAgreement
                            ? "agreement_pending"
                            : "agreement_day_dialog_subtitle"),
                    textAlign: TextAlign.center,
                    style: LelloTextStyles.subtitle(theme)!.copyWith(
                        color: LelloTheme.palleteOf(theme).textLightest())),
                SizedBox(height: Dimens.spacingLarge),
              ],
            ),
          ),
          InkWell(
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            focusColor: Colors.transparent,
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              width: double.infinity,
              height: Dimens.spacingXLarge,
              child: Center(
                child: Text(
                  getString(context, "ok").toUpperCase(),
                  style: LelloTextStyles.subBody(theme)!.copyWith(
                    color: theme.primaryColor,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
