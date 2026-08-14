import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class VacationScheduledAlertDialog extends StatelessWidget {
  const VacationScheduledAlertDialog({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("${getString(context, "chat_error_title")}!",
                  textAlign: TextAlign.center,
                  style: LelloTextStyles.subtitleBold(theme)!
                      .copyWith(color: LelloTheme.palleteOf(theme).text())),
              SizedBox(height: Dimens.spacing),
              Text(getString(context, "gdp_vacation_scheduled_vacation_alert"),
                  textAlign: TextAlign.center,
                  style: LelloTextStyles.subtitle(theme)!
                      .copyWith(color: LelloTheme.palleteOf(theme).text())),
              SizedBox(height: Dimens.spacingMedium),
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
                getString(context, "close").toUpperCase(),
                style: LelloTextStyles.subBody(theme)!.copyWith(
                  color: theme.primaryColor,
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
