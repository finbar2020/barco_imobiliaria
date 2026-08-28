import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app_localization.dart';
import '../../../methods/launch_url/launch.dart';
import '../../app_theme.dart';
import '../../dimens.dart';
import '../text/lello_text_styles.dart';

class WhatsAppDialog {
  static redirect(
      {required BuildContext context,
      required dynamic phoneNumber,
      required dynamic title,
      required dynamic text,
      bool isGeneric = false,
      String companyName = "",
      dynamic message}) {
    showDialog(
      context: context,
      builder: (context) => RedirectionWhatsappDialog(
          phoneNumber: phoneNumber,
          title: title,
          text: text,
          isGeneric: isGeneric,
          companyName: companyName,
          whatsAppMessage: message),
    );
  }
}

class RedirectionWhatsappDialog extends StatelessWidget {
  final phoneNumber;
  final title;
  final text;
  final whatsAppMessage;
  final isGeneric;
  final String companyName;
  const RedirectionWhatsappDialog(
      {Key? key,
      required this.phoneNumber,
      required this.title,
      required this.text,
      required this.isGeneric,
      this.companyName = "",
      this.whatsAppMessage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // `whatsAppMessage` é opcional: sem chave usa a chave vazia (mensagem "").
    String? message = getString(context, whatsAppMessage ?? "");
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(Dimens.spacingMedium),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: Dimens.spacing),
            Text("${getString(context, title)}!",
                textAlign: TextAlign.center,
                style: LelloTextStyles.subtitleBold(theme)!
                    .copyWith(color: LelloTheme.palleteOf(theme).text())),
            SizedBox(height: Dimens.spacing),
            Text(
                changeLelloForCompanyName(
                    context, "talk_to_lello_text_description"),
                textAlign: TextAlign.center,
                style: LelloTextStyles.subtitle(theme)!.copyWith(
                    color: LelloTheme.palleteOf(theme).textLightest())),
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
                SizedBox(width: Dimens.spacingSmall),
                InkWell(
                  onTap: () async {
                    Launch.whatsApp(context, phoneNumber, message: message);
                    Navigator.pop(context);
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

  String changeLelloForCompanyName(BuildContext context, String getText) {
    if (isGeneric && text == getText) {
      var textFormatted = getString(context, text);
      if (textFormatted.isNotEmpty && companyName.isNotEmpty) {
        return textFormatted.replaceAll("Lello", companyName);
      } else {
        return getString(context, text);
      }
    } else {
      return getString(context, text);
    }
  }
}
