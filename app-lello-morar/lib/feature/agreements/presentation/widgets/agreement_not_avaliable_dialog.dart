import 'package:another_flushbar/flushbar.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AgreementNotAvaliableDialog extends StatelessWidget {
  final String? message;

  const AgreementNotAvaliableDialog({
    Key? key,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      child: Container(
        //padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Center(
                    child: SvgPicture.asset("assets/ic_billet_alert.svg"),
                  ),
                  SizedBox(height: Dimens.spacing),
                  Text(getString(context, "agreement_not_avaliable_failure"),
                      textAlign: TextAlign.center,
                      style: LelloTextStyles.subtitle(theme)!.copyWith(
                          color: LelloTheme.palleteOf(theme).textLightest())),
                  InkWell(
                    onTap: () {
                      Clipboard.setData(ClipboardData(
                              text: FlavorConfig.config.supportEmail))
                          .then((value) {
                        return Flushbar(
                          duration: Duration(seconds: 1),
                          message: getString(context, "email_copied"),
                        )..show(context);
                      });
                    },
                    child: Text(FlavorConfig.config.supportEmail,
                        textAlign: TextAlign.center,
                        style: LelloTextStyles.subtitle(theme)!.copyWith(
                            color: LelloTheme.palleteOf(theme).textLightest(),
                            decoration: TextDecoration.underline,
                            decorationColor:
                                LelloTheme.palleteOf(theme).textLightest())),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text(
                        getString(context, "later").toUpperCase(),
                        style: LelloTextStyles.subBody(theme)!.copyWith(
                          color: LelloTheme.palleteOf(theme).text(),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
