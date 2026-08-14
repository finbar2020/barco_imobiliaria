import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class CantChangeDialog extends StatelessWidget {
  final String message;
  const CantChangeDialog({required this.message, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () async => false,
      child: Dialog(
        child: Container(
          padding: EdgeInsets.all(Dimens.spacing),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: Dimens.spacing),
              Text("Atenção!",
                  textAlign: TextAlign.center,
                  style: LelloTextStyles.subtitleBold(theme)!
                      .copyWith(color: LelloTheme.palleteOf(theme).text())),
              SizedBox(height: Dimens.spacing),
              Text(message,
                  textAlign: TextAlign.center,
                  style: LelloTextStyles.subtitle(theme)),
              SizedBox(height: Dimens.spacing),
              RichText(
                textAlign: TextAlign.center,
                text: new TextSpan(
                  style: LelloTextStyles.subtitle(theme)!.copyWith(
                      color: LelloTheme.palleteOf(theme).textLightest()),
                  children: <TextSpan>[
                    TextSpan(
                      text: "Para mais informações, entre em contato com a ",
                    ),
                    TextSpan(
                        text: "Linha Direta Condômino ",
                        style: LelloTextStyles.subtitleBold(theme)!.copyWith(
                            color: LelloTheme.palleteOf(theme).textLightest())),
                    TextSpan(
                      text: "pelo ",
                    ),
                    TextSpan(
                        text: "Whatsapp",
                        style: LelloTextStyles.subtitleBold(theme)!.copyWith(
                            color: LelloTheme.palleteOf(theme).textLightest())),
                    TextSpan(
                      text:
                          ": ${FlavorConfig.config.supportMoradorWhatsAppNumber} ",
                    ),
                    TextSpan(
                        text: "ou ",
                        style: LelloTextStyles.subtitleBold(theme)!.copyWith(
                            color: LelloTheme.palleteOf(theme).textLightest())),
                    TextSpan(
                      text: "pelo ",
                    ),
                    TextSpan(
                        text: "telefone",
                        style: LelloTextStyles.subtitleBold(theme)!.copyWith(
                            color: LelloTheme.palleteOf(theme).textLightest())),
                    TextSpan(
                      text:
                          ": ${FlavorConfig.config.supportMoradorWhatsAppNumber}.",
                    ),
                  ],
                ),
              ),
              SizedBox(height: Dimens.spacingLarge),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
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
                      String message =
                          getString(context, "whats_app_default_message");
                      Launch.whatsApp(context,
                          FlavorConfig.config.supportMoradorWhatsAppNumber,
                          message: message);
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Row(children: [
                      SvgPicture.asset(
                        "assets/ic_whats_red.svg",
                        color: theme.primaryColor,
                      ),
                      SizedBox(width: Dimens.spacingSmall),
                      Text(
                        getString(context,
                                "registration_lello_warning_no_data_btn")
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
      ),
    );
  }
}
