import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class TimesheetEmailSuccessBody extends StatelessWidget {
  const TimesheetEmailSuccessBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(Dimens.spacingMedium),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            "assets/ic_success_gray.svg",
            height: 32.0,
            width: 32.0,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: Dimens.spacing),
            child: Text(
              getString(context, "timesheet_send_email_success"),
              textAlign: TextAlign.center,
              style: LelloTextStyles.subtitle(theme)?.copyWith(
                color: LelloTheme.palleteOf(theme).hubText(),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              padding: EdgeInsets.all(Dimens.spacing),
              child: Text(
                getString(context, "ok").toUpperCase(),
                style: LelloTextStyles.body(theme)?.copyWith(
                  color: LelloTheme.palleteOf(theme).primary(),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
