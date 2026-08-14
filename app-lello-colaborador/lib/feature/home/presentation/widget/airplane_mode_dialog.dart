import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class AirplaneModeDialog {
  static show(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return _dialogBody(context);
        });
  }

  static Dialog _dialogBody(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Dialog(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Dimens.spacingMedium),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(Dimens.spacingMedium),
              child: Icon(
                Icons.airplanemode_active_outlined,
                size: 32.0,
                color: LelloTheme.palleteOf(theme).grey(),
              ),
            ),
            Text(
              getString(context, "airplane_mode_dialog_description"),
              style: LelloTextStyles.subtitle(theme)
                  ?.copyWith(color: LelloTheme.palleteOf(theme).hubText()),
            ),
            InkWell(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: EdgeInsets.all(Dimens.spacingMedium),
                child: Text(
                  getString(context, "back"),
                  style: LelloTextStyles.subtitleBold(theme)
                      ?.copyWith(color: theme.primaryColor),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
