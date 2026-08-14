import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet_month_resume/timesheet_menu_state.dart';

class TimesheetMenuExtraHourWidget extends StatelessWidget {
  final TimesheetMenuState state;
  const TimesheetMenuExtraHourWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    int extraHoursHundred =
        (state as TimesheetMonthResumeLoadedState).entity.extraHoursHundred;
    int otherExtraHours =
        (state as TimesheetMonthResumeLoadedState).entity.otherExtraHours;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Tooltip(
          triggerMode: TooltipTriggerMode.tap,
          showDuration: const Duration(seconds: 4),
          message: getString(context, "gdp_timesheet_extra_hour_detail_info"),
          child: Row(
            children: [
              Text(getString(context, "gdp_timesheet_grid_extra_hours"),
                  style: LelloTextStyles.subtitleBold(theme)),
              const Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Icon(Icons.info_outline),
              ),
            ],
          ),
        ),
        SizedBox(height: Dimens.spacing),
        Padding(
          padding: const EdgeInsets.only(
              left: 20, right: 20, bottom: 20.0, top: 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (extraHoursHundred != 0)
                Text(getString(context, "gdp_timesheet_extra_hour_100"),
                    style: LelloTextStyles.subtitleBold(theme)),
              if (extraHoursHundred != 0) SizedBox(height: Dimens.spacingSmall),
              extraHoursInformative(theme, extraHoursHundred, context),
              SizedBox(height: Dimens.spacing),
              if (otherExtraHours != 0)
                Text(getString(context, "gdp_timesheet_extra_hour_other"),
                    style: LelloTextStyles.subtitleBold(theme)),
              if (otherExtraHours != 0) SizedBox(height: Dimens.spacingSmall),
              extraHoursInformative(theme, otherExtraHours, context),
            ],
          ),
        ),
      ],
    );
  }

  String convertExtraHours(int minutes) {
    var absoluteMinutes = minutes.abs();
    int hours = absoluteMinutes ~/ 60;
    int remainingMinutes = absoluteMinutes % 60;
    return "${hours}h${remainingMinutes}min".replaceAll("-", "");
  }

  Widget extraHoursInformative(
      ThemeData theme, int minutes, BuildContext context) {
    if (minutes == 0) {
      return Container();
    }
    bool positive = minutes > 0;
    return Row(
      children: [
        SvgPicture.asset(positive
            ? "assets/ic_graphic_hours_red.svg"
            : "assets/ic_graphic_hours_green.svg"),
        SizedBox(width: Dimens.spacingSmall),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(convertExtraHours(minutes),
                style: LelloTextStyles.subtitle(theme)!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: positive
                        ? const Color(0xFFCB2640)
                        : const Color(0xFF42B883))),
            Row(
              children: [
                Text(
                    positive
                        ? getString(context, "gdp_timesheet_extra_hour_more")
                        : getString(context, "gdp_timesheet_extra_hour_less"),
                    style: LelloTextStyles.subBody(theme)!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: positive
                            ? const Color(0xFFCB2640)
                            : const Color(0xFF42B883))),
                Text(getString(context, "gdp_timesheet_extra_hour_month"),
                    style: LelloTextStyles.subBody(theme)!.copyWith(
                        color: positive
                            ? const Color(0xFFCB2640)
                            : const Color(0xFF42B883))),
              ],
            )
          ],
        ),
      ],
    );
  }
}
