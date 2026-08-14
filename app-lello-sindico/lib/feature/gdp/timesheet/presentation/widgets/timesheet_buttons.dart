import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_periods.dart';
import 'package:lello/feature/gdp/timesheet/presentation/page/timesheet_certificate_page.dart';
import 'package:lello/feature/gdp/timesheet/presentation/page/timesheet_occurence_page.dart';
import 'package:lello/feature/gdp/timesheet/presentation/page/timesheet_page.dart';

class TimesheetButtons extends StatelessWidget {
  final DateTime date;
  final List<TimesheetPeriods> dateList;
  const TimesheetButtons({
    super.key,
    required this.date,
    required this.dateList,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Column(
      children: [
        PrimaryButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TimesheetOccurrencePage(
                  date: date,
                  dateList: dateList,
                ),
              ),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset("assets/ic_white_allert.svg"),
              SizedBox(width: Dimens.spacingXSmall),
              Text(getString(context, "gdp_timesheet_type_all_events"),
                  style: LelloTextStyles.subBody(theme)!.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        SizedBox(height: Dimens.spacing),
        SecondaryButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TimesheetCertificatePage(
                  date: date,
                  dateList: dateList,
                ),
              ),
            );
          },
          buttonBorderColor: theme.primaryColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset("assets/ic_notes.svg"),
              SizedBox(width: Dimens.spacingXSmall),
              Text(getString(context, "gdp_timesheet_type_all_certificates"),
                  style: LelloTextStyles.subBody(theme)!.copyWith(
                      color: theme.primaryColor, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        SizedBox(height: Dimens.spacing),
        SecondaryButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TimesheetPage(
                  date: date,
                  dateList: dateList,
                ),
              ),
            );
          },
          buttonBorderColor: theme.primaryColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset("assets/ic_notes_assign.svg"),
              SizedBox(width: Dimens.spacingXSmall),
              Text(getString(context, "gdp_timesheet_type_all_timesheet"),
                  style: LelloTextStyles.subBody(theme)!.copyWith(
                      color: theme.primaryColor, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }
}
