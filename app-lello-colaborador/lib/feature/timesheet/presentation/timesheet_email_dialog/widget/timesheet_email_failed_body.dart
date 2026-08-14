import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class TimesheetEmailFailedBody extends StatelessWidget {
  final String? email;
  final Function(String email) tryAgain;
  const TimesheetEmailFailedBody({
    Key? key,
    this.email,
    required this.tryAgain,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(Dimens.spacingMedium),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            "assets/ic_attention.svg",
            color: LelloTheme.palleteOf(theme).grey(),
            height: 64.0,
            width: 64.0,
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: Dimens.spacing),
            child: Text(
              getString(context, "timesheet_send_email_error_title"),
              style: LelloTextStyles.subtitleBold(theme)?.copyWith(
                color: LelloTheme.palleteOf(theme).hubText(),
              ),
            ),
          ),
          Text(
            getString(context, "timesheet_send_email_error_description"),
            style: LelloTextStyles.subtitle(theme)?.copyWith(
              color: LelloTheme.palleteOf(theme).hubText(),
            ),
          ),
          SizedBox(height: Dimens.spacing),
          InkWell(
            onTap: () {
              tryAgain(email ?? "");
            },
            child: Container(
              padding: EdgeInsets.all(Dimens.spacing),
              child: Text(
                getString(context, "timesheet_send_email_error_try_again")
                    .toUpperCase(),
                style: LelloTextStyles.body(theme)?.copyWith(
                  color: LelloTheme.palleteOf(theme).primary(),
                ),
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
                getString(context, "timesheet_send_email_error_try_later"),
                style: LelloTextStyles.body(theme)?.copyWith(
                  color: LelloTheme.palleteOf(theme).hubText(),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
