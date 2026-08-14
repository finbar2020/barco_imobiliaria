import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class HomeRequestApprovedDialog extends StatelessWidget {
  const HomeRequestApprovedDialog({Key? key}) : super(key: key);

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
            Text("${getString(context, "attention")}!",
                textAlign: TextAlign.center,
                style: LelloTextStyles.subtitleBold(theme)
                    ?.copyWith(color: LelloTheme.palleteOf(theme).textLight())),
            SizedBox(height: Dimens.spacingLarge),
            Text(getString(context, "home_request_approved_dialog_subtitle"),
                textAlign: TextAlign.center,
                style: LelloTextStyles.subtitle(theme)
                    ?.copyWith(color: LelloTheme.palleteOf(theme).textLight())),
            SizedBox(height: Dimens.spacingLarge),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Text(
                getString(context, "ok"),
                style: LelloTextStyles.subBody(theme)?.copyWith(
                  color: LelloTheme.palleteOf(theme).primary(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
