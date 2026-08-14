import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class DialogPaymentAproovedWidget extends StatelessWidget {
  const DialogPaymentAproovedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(Dimens.spacingMedium),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/ic_attention.svg",
              color: LelloTheme.palleteOf(theme).grey(),
              height: 40.0,
              width: 40.0,
            ),
            SizedBox(height: Dimens.spacingMedium),
            Text(
              "${getString(context, 'attention')}!",
              style: LelloTextStyles.subtitleBold(theme)
                  ?.copyWith(color: LelloTheme.palleteOf(theme).textOpaque()),
            ),
            SizedBox(height: Dimens.spacingMedium),
            Text(
              getString(context, "payment_approved_dialog_title"),
              style: LelloTextStyles.subtitle(theme)
                  ?.copyWith(color: LelloTheme.palleteOf(theme).textOpaque()),
            ),
            SizedBox(height: Dimens.spacingMedium),
            Text(
              getString(context, "payment_approved_dialog_subtitle"),
              style: LelloTextStyles.subtitle(theme)
                  ?.copyWith(color: LelloTheme.palleteOf(theme).textOpaque()),
            ),
            SizedBox(height: Dimens.spacingMedium),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  getString(context, "ok"),
                  style: TextStyle(
                    color: theme.primaryColor,
                    fontSize: 16.0,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
