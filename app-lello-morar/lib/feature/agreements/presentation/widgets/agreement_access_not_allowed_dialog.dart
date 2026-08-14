import 'package:another_flushbar/flushbar.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AgreementAccessNotAllowedDialog extends StatelessWidget {
  const AgreementAccessNotAllowedDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(24.0),
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
                style: LelloTextStyles.subtitle(theme)!.copyWith(
                    color: LelloTheme.palleteOf(theme).textLightest())),
            Text(getString(context, "agreement_access_not_allowed"),
                textAlign: TextAlign.center,
                style: LelloTextStyles.subtitle(theme)!.copyWith(
                    color: LelloTheme.palleteOf(theme).textLightest())),
            InkWell(
              onTap: () {
                Clipboard.setData(
                        ClipboardData(text: FlavorConfig.config.supportEmail))
                    .then((value) {
                  return Flushbar(
                    duration: Duration(seconds: 1),
                    message: getString(context, "email_copied"),
                  )..show(context);
                });
              },
              child: Text(
                FlavorConfig.config.supportEmail,
                textAlign: TextAlign.center,
                style: LelloTextStyles.subtitle(theme)!.copyWith(
                    color: LelloTheme.palleteOf(theme).textLightest(),
                    decoration: TextDecoration.underline,
                    decorationColor:
                        LelloTheme.palleteOf(theme).textLightest()),
              ),
            ),
            SizedBox(height: Dimens.spacingLarge),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    getString(context, "later").toUpperCase(),
                    style: LelloTextStyles.subBody(theme)!.copyWith(
                      color: LelloTheme.palleteOf(theme).text(),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    _openWhatsapp(context);
                  },
                  child: Row(children: [
                    SvgPicture.asset(
                      "assets/ic_whats_red.svg",
                      color: theme.primaryColor,
                    ),
                    SizedBox(width: Dimens.spacingSmall),
                    Text(
                      getString(
                              context, "registration_lello_warning_no_data_btn")
                          .toUpperCase(),
                      style: LelloTextStyles.subBody(theme)!.copyWith(
                        color: theme.primaryColor,
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openWhatsapp(BuildContext context) async {
    String message = "Oi, pode me ajudar?";
    Launch.whatsApp(context, FlavorConfig.config.supportMoradorWhatsAppNumber,
        message: message);
  }
}
