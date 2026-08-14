import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ScheduleVacationFailurePageArgs {
  Failure faliure;
  ScheduleVacationFailurePageArgs({required this.faliure});
}

class ScheduleVacationFailurePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var arguments = ModalRoute.of(context)!.settings.arguments
        as ScheduleVacationFailurePageArgs;

    var faliure = arguments.faliure;
    String? message;

    if (faliure is KnownFailure) message = faliure.error?.detail?.toString();

    final theme = Theme.of(context);
    return Theme(
      data: theme,
      child: Scaffold(
        backgroundColor: LelloTheme.palleteOf(theme).warning(),
        body: Padding(
          padding: EdgeInsets.all(Dimens.spacingLarge),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset("assets/ic_warning.svg",
                    width: 92, height: 92),
                SizedBox(height: Dimens.spacingLarge),
                Text(
                    getString(
                        context, "gdp_vacation_registration_failed_title"),
                    textAlign: TextAlign.center,
                    style: LelloTextStyles.headline(theme)!
                        .copyWith(color: Colors.white)),
                SizedBox(height: Dimens.spacingXSmall),
                Text(
                    message ??
                        getString(context,
                            "gdp_vacation_registration_failed_subtitle"),
                    textAlign: TextAlign.center,
                    style: LelloTextStyles.subtitle(theme)!
                        .copyWith(color: Colors.white)),
                SizedBox(height: Dimens.spacingMedium),
                Theme(
                  data: theme.copyWith(
                    textTheme: theme.textTheme.copyWith(
                        labelLarge: theme.textTheme.labelLarge
                            ?.copyWith(color: Colors.black)),
                  ),
                  child: PrimaryButton(
                      buttonColor: Colors.white,
                      text: getString(context, "back"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
