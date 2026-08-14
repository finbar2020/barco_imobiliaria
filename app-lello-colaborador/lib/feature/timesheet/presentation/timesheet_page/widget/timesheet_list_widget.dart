import 'package:colaborador/core/analytics/analytics_log_events.dart';
import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/core/navigation/application_route.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:colaborador/feature/timesheet/domain/entity/timesheet.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_detail_page/page/timesheet_detail_page.dart';
import 'package:essentials/analytics/events/analytics_events_employee.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class TimesheetListWidget extends StatelessWidget {
  final Timesheet timesheet;
  const TimesheetListWidget({
    Key? key,
    required this.timesheet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final SessionBloc sessionBloc =
        ApplicationContainer.instance().resolve<SessionBloc>();

    return timesheet.timesheetElements.isNotEmpty
        ? Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      getString(context, "timesheet_page_date"),
                      style: LelloTextStyles.subtitleBold(theme)?.copyWith(
                          color: LelloTheme.palleteOf(theme).hubText()),
                    ),
                  ),
                  SizedBox(width: Dimens.spacingSmall),
                  Expanded(
                    flex: 6,
                    child: Text(
                      getString(context, "timesheet_page_points"),
                      style: LelloTextStyles.subtitleBold(theme)?.copyWith(
                          color: LelloTheme.palleteOf(theme).hubText()),
                    ),
                  ),
                  SizedBox(width: Dimens.spacingSmall),
                  Expanded(
                    flex: 3,
                    child: Text(
                      getString(context, "timesheet_page_journey"),
                      style: LelloTextStyles.subtitleBold(theme)?.copyWith(
                          color: LelloTheme.palleteOf(theme).hubText()),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              SizedBox(height: Dimens.spacing),
              ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: timesheet.timesheetElements.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: Dimens.spacingSmall),
                    child: InkWell(
                      onTap: () {
                        if (timesheet.timesheetElements[index].hasTreatment) {
                          EmployeeAnalyticsLogEvents.logEvent(
                            event: AnalyticsEventsEmployee
                                .pontoDigitalDetalhesTratativasAcessar(),
                            referenceValue: sessionBloc
                                    .getSession?.condominium.reference
                                    .toString() ??
                                "",
                          );
                          Navigator.pushNamed(
                              context, ApplicationRoute.timesheetDetail,
                              arguments: TimesheetDetailPageArgs(
                                  period:
                                      timesheet.timesheetElements[index].date));
                        }
                      },
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              timesheet.timesheetElements[index].dateFormatted,
                              style: _getStyle(
                                  theme,
                                  timesheet
                                      .timesheetElements[index].hasTreatment),
                            ),
                          ),
                          SizedBox(width: Dimens.spacingSmall),
                          Expanded(
                            flex: 6,
                            child: Text(
                              timesheet.timesheetElements[index]
                                  .pointsFormatted(context),
                              style: _getStyle(
                                  theme,
                                  timesheet
                                      .timesheetElements[index].hasTreatment),
                            ),
                          ),
                          SizedBox(width: Dimens.spacingSmall),
                          Expanded(
                            flex: 2,
                            child: Text(
                              timesheet.timesheetElements[index].journey,
                              style: _getStyle(
                                  theme,
                                  timesheet
                                      .timesheetElements[index].hasTreatment),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                              flex: 1,
                              child: timesheet
                                      .timesheetElements[index].hasTreatment
                                  ? Icon(
                                      Icons.keyboard_arrow_right,
                                      size: 32.0,
                                      color: theme.primaryColor,
                                    )
                                  : Container()),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                getString(context, "timesheet_page_empty"),
                style: LelloTextStyles.subtitle(theme)
                    ?.copyWith(color: LelloTheme.palleteOf(theme).hubText()),
              ),
            ],
          );
  }

  TextStyle? _getStyle(ThemeData theme, bool hasTreatment) {
    return hasTreatment
        ? LelloTextStyles.subtitle(theme)?.copyWith(
            color: LelloTheme.palleteOf(theme).primary(),
            decoration: TextDecoration.underline)
        : LelloTextStyles.subtitle(theme)?.copyWith(
            color: LelloTheme.palleteOf(theme).hubText(),
          );
  }
}
