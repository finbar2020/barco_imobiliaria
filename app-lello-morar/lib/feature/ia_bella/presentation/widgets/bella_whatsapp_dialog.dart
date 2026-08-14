import 'package:flutter/material.dart';
import 'package:essentials/essentials.dart';

class BellaWhatsappDialog extends StatelessWidget {
  final Function() onTalkToUsPressed;
  final Function() onClosePressed;
  const BellaWhatsappDialog({
    required this.onTalkToUsPressed,
    required this.onClosePressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      child: Container(
        padding: EdgeInsets.all(Dimens.spacingMedium),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              child: SvgPicture.asset(
                "assets/ic_success_green.svg",
              ),
            ),
            SizedBox(height: Dimens.spacingMedium),
            Text(
              "Agradecemos seu feedback!",
              style: theme.textTheme.titleLarge!
                  .copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: Dimens.spacingMedium),
            Text(
              "Caso seu problema não tenha sido resolvido, fale com a gente:",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
            SizedBox(height: Dimens.spacingMedium),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                PrimaryButton(
                  onPressed: onTalkToUsPressed,
                  text: "Fale com a gente",
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset("assets/ic_whatsapp_white.svg",
                            height: 24),
                        SizedBox(width: Dimens.spacing),
                        Text("Fale com a gente",
                            style: LelloTextStyles.bodyBold(theme)!
                                .copyWith(color: Colors.white)),
                      ]),
                  buttonColor: LelloTheme.palleteOf(theme).whatsappButton(),
                ),
                SizedBox(height: Dimens.spacingSmall),
                PrimaryButton(
                  onPressed: onClosePressed,
                  text: "Fechar",
                  buttonColor: LelloTheme.palleteOf(theme).primary(),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
