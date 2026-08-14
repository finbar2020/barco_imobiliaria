import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/navigation/application_route.dart';

class TimesheetDetailListSuccessPage extends StatelessWidget {
  const TimesheetDetailListSuccessPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
      data: theme,
      child: Scaffold(
        backgroundColor: LelloTheme.palleteOf(theme).success(),
        body: Padding(
          padding: EdgeInsets.all(Dimens.spacingLarge),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset("assets/ic_success.svg",
                    width: 92, height: 92),
                SizedBox(height: Dimens.spacingLarge),
                Text(getString(context, "gdp_timesheet_detail_delay_success"),
                    textAlign: TextAlign.center,
                    style: LelloTextStyles.headline(theme)!
                        .copyWith(color: Colors.white)),
                SizedBox(height: Dimens.spacingLarge),
                Text(
                    "O processamento dessa informação não é instantâneo, portanto levará algum tempo até que a informação seja exibida nas marcações do funcionário.",
                    textAlign: TextAlign.center,
                    style: LelloTextStyles.body(theme)!
                        .copyWith(color: Colors.white)),
                SizedBox(height: Dimens.spacingLarge),
                Theme(
                  data: theme.copyWith(
                    textTheme: theme.textTheme.copyWith(
                        labelLarge: theme.textTheme.labelLarge
                            ?.copyWith(color: Colors.black)),
                  ),
                  child: PrimaryButton(
                    buttonColor: Colors.white,
                    text: getString(context, "conclude"),
                    onPressed: () {
                      Navigator.of(context).popUntil(
                        ModalRoute.withName(ApplicationRoute.gdpTimesheetMenu),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
