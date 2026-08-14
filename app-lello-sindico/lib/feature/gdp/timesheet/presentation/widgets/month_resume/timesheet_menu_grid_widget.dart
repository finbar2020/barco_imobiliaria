import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_occurrence_type_enum.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_periods.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet_month_resume/timesheet_menu_state.dart';
import 'package:lello/feature/gdp/timesheet/presentation/page/timesheet_list_details_page.dart';
import 'package:lello/feature/gdp/timesheet/presentation/widgets/month_resume/timesheet_menu_grid_button.dart';

class TimesheetMenuGridWidget extends StatelessWidget {
  final TimesheetMonthResumeLoadedState state;
  final List<TimesheetPeriods> dateList;
  const TimesheetMenuGridWidget({
    super.key,
    required this.state,
    required this.dateList,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(getString(context, "gdp_timesheet_month_resume"),
            style: LelloTextStyles.subtitleBold(theme)),
        SizedBox(height: Dimens.spacingSmall),
        GridView.count(
          shrinkWrap: true,
          childAspectRatio: 1.6,
          crossAxisCount: 2,
          mainAxisSpacing: Dimens.spacing,
          crossAxisSpacing: Dimens.spacing,
          physics: const NeverScrollableScrollPhysics(),
          children: <Widget>[
            TimesheetMenuGridButton(
                value: state.entity.vacations.toString(),
                title: getString(context, "gdp_timesheet_type_vacation"),
                onPressed: () {
                  _navigator(context, TimesheetOccurrenceTypeEnum.vacation);
                }),
            TimesheetMenuGridButton(
                value: state.entity.delays.toString(),
                title: getString(context, "gdp_timesheet_grid_delay"),
                onPressed: () {
                  _navigator(context, TimesheetOccurrenceTypeEnum.delay);
                }),
            TimesheetMenuGridButton(
                value: state.entity.fouls.toString(),
                title: getString(context, "gdp_timesheet_grid_foul"),
                onPressed: () {
                  _navigator(context, TimesheetOccurrenceTypeEnum.fouls);
                }),
            TimesheetMenuGridButton(
                value: convertExtraHours(state),
                title: getString(context, "gdp_timesheet_grid_extra_hours"),
                onPressed: () {
                  _navigator(context, TimesheetOccurrenceTypeEnum.extraHour);
                }),
          ],
        ),
      ],
    );
  }

  String convertExtraHours(TimesheetMonthResumeLoadedState state) {
    return (state.entity.extraHours ~/ 60).toString();
  }

  _navigator(BuildContext context, TimesheetOccurrenceTypeEnum type) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TimesheetListDetailsPage(
          date: state.date,
          type: type,
          dateList: dateList,
        ),
      ),
    );
  }
}
