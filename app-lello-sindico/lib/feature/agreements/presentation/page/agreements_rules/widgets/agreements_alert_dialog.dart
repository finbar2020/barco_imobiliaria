import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AgreementsAlertDialog extends StatelessWidget {
  const AgreementsAlertDialog({
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
              child: SvgPicture.asset(
                "assets/ic_attention.svg",
                color: LelloTheme.palleteOf(theme).textLightest(),
                height: 32.0,
                width: 32.0,
              ),
            ),
            SizedBox(height: Dimens.spacing),
            Text("${getString(context, "agreements_rules_dialog_title")}!",
                textAlign: TextAlign.center,
                style: LelloTextStyles.subtitleBold(theme)!.copyWith(
                    color: LelloTheme.palleteOf(theme).textLightest())),
            SizedBox(height: Dimens.spacing),
            Text("${getString(context, "agreements_rules_dialog_text")}",
                textAlign: TextAlign.center,
                style: LelloTextStyles.body(theme)!.copyWith(
                    color: LelloTheme.palleteOf(theme).textLightest())),
            SizedBox(height: Dimens.spacingLarge),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Text(
                (getString(context, "agreements_rules_dialog_confirmation"))
                    .toUpperCase(),
                style: LelloTextStyles.subBody(theme)!.copyWith(
                  color: theme.primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
