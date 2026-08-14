import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class TimesheetSignFillBody extends StatelessWidget {
  final Function() timesheetSign;
  const TimesheetSignFillBody({
    Key? key,
    required this.timesheetSign,
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
              getString(context, "timesheet_sign_title"),
              style: LelloTextStyles.subtitleBold(theme)?.copyWith(
                color: LelloTheme.palleteOf(theme).hubText(),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: Dimens.spacing),
            child: Text(
              getString(context, "timesheet_sign_description"),
              style: LelloTextStyles.subtitle(theme)?.copyWith(
                color: LelloTheme.palleteOf(theme).hubText(),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              timesheetSign();
            },
            child: Container(
              padding: EdgeInsets.all(Dimens.spacing),
              child: Text(
                getString(context, "timesheet_sign_ok").toUpperCase(),
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
                getString(context, "timesheet_sign_later").toUpperCase(),
                style: LelloTextStyles.body(theme)?.copyWith(
                  color: LelloTheme.palleteOf(theme).hubText(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
