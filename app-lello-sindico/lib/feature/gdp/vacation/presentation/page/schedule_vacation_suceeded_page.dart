import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:lello/core/app_review/app_review.dart';
import 'package:lello/core/navigation/application_route.dart';

class ScheduleVacationSucceededPage extends StatelessWidget {
  final dateFormat = DateFormat.yMd();

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
                SvgPicture.asset('assets/ic_success.svg',
                    width: 92, height: 92),
                SizedBox(height: Dimens.spacingLarge),
                Text(getString(context, 'gdp_vacation_schedule_success_title'),
                    textAlign: TextAlign.center,
                    style: LelloTextStyles.headline(theme)!
                        .copyWith(color: Colors.white)),
                SizedBox(height: Dimens.spacingLarge),
                Theme(
                  data: theme.copyWith(
                    textTheme: theme.textTheme.copyWith(
                        labelLarge: theme.textTheme.labelLarge
                            ?.copyWith(color: Colors.black)),
                  ),
                  child: PrimaryButton(
                    text: getString(context, 'close'),
                    onPressed: () {
                      _navigateToHome(context);
                      AppReview.call(context: context);
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

  void _navigateToHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
        context, ApplicationRoute.home, (route) => false);
  }
}
