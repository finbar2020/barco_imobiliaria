import 'package:colaborador/feature/timesheet/domain/entity/timesheet.dart';
import 'package:colaborador/feature/timesheet/domain/entity/timesheet_periods.dart';
import 'package:colaborador/feature/timesheet/domain/entity/timesheet_status_enum.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_page/bloc/timesheet_bloc.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class TimesheetIntro extends StatefulWidget {
  final DateTime date;
  final Function(DateTime? newDate) onDateSelected;
  final Function(int index, List<TimesheetPeriods> timesheetPeriods) setPeriods;
  final TimesheetStatusEnum? timesheetStatus;
  final Timesheet? timesheet;
  final DateTime? periodStartDate;
  final DateTime? periodEndDate;
  const TimesheetIntro({
    Key? key,
    required this.date,
    required this.onDateSelected,
    required this.periodStartDate,
    required this.periodEndDate,
    required this.setPeriods,
    this.timesheet,
    this.timesheetStatus,
  }) : super(key: key);

  @override
  State<TimesheetIntro> createState() => _TimesheetIntroState();
}

class _TimesheetIntroState extends State<TimesheetIntro> {
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    TimesheetBloc timesheetBloc = BlocProvider.of(context);
    ThemeData theme = Theme.of(context);
    selectedDate ??= widget.date;
    return Column(
      children: [
        Text(
          getString(context, "timesheet_page_title"),
          style: LelloTextStyles.subtitle(theme)
              ?.copyWith(color: LelloTheme.palleteOf(theme).hubText()),
        ),
        SizedBox(height: Dimens.spacingMedium),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: DropdownButtonFormField<DateTime>(
                items: _getDropdownItems(timesheetBloc.availableDates),
                onChanged: (DateTime? value) {
                  widget.onDateSelected(value);
                  widget.setPeriods(
                      timesheetBloc.availableDates.indexOf(value!),
                      timesheetBloc.timesheetPeriods);
                },
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                value: selectedDate,
                icon: const Icon(Icons.keyboard_arrow_down),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(width: Dimens.spacingMedium),
            _buildTimesheetStatusIcon(theme),
          ],
        ),
        SizedBox(height: Dimens.spacing),
        Row(
          children: [
            Flexible(
              child: _buidComponent(
                title: getString(context, "timesheet_info_period_start"),
                subtitle: widget.periodStartDate != null
                    ? DateFormat("dd/MM/yyyy").format(widget.periodStartDate!)
                    : "",
                theme: theme,
              ),
            ),
            SizedBox(width: Dimens.spacingXLarge),
            Flexible(
              child: _buidComponent(
                title: getString(context, "timesheet_info_period_end"),
                subtitle: widget.periodEndDate != null
                    ? DateFormat("dd/MM/yyyy").format(widget.periodEndDate!)
                    : "",
                theme: theme,
              ),
            ),
          ],
        ),
        SizedBox(height: Dimens.spacing),
        if (widget.timesheetStatus == TimesheetStatusEnum.notAllowed &&
            widget.timesheet?.dateLiberation != null)
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: theme.colorScheme.error,
                size: 20,
              ),
              SizedBox(width: Dimens.spacing),
              Flexible(
                child: Text(
                  "${getString(context, "timesheet_info_liberation_date")} ${widget.timesheet?.dateLiberation?.toFormattedString()}",
                  style: theme.textTheme.bodyMedium!.merge(
                    TextStyle(
                      color: theme.colorScheme.error,
                    ),
                  ),
                ),
              )
            ],
          )
      ],
    );
  }

  List<DropdownMenuItem<DateTime>> _getDropdownItems(List<DateTime> dates) {
    List<DropdownMenuItem<DateTime>> list = dates
        .map(
          (date) => DropdownMenuItem<DateTime>(
            value: date,
            child: Text(
              _formatDate(date),
              overflow: TextOverflow.ellipsis,
              textScaleFactor: 1,
            ),
          ),
        )
        .toList();
    return list;
  }

  String _formatDate(DateTime date) {
    DateFormat dateFormat = DateFormat("MMMM - yyyy");
    String upperCase = dateFormat.format(date).substring(0, 1).toUpperCase();
    String lowerCase = dateFormat.format(date).substring(1).toLowerCase();
    return "$upperCase$lowerCase";
  }

  Widget _buildTimesheetStatusIcon(ThemeData theme) {
    if (widget.timesheetStatus == null) {
      return Container();
    }
    switch (widget.timesheetStatus!) {
      case TimesheetStatusEnum.notAssigned:
        return Column(
          children: [
            SvgPicture.asset("assets/ic_timesheet_not_assigned.svg"),
            Container(
              padding: EdgeInsets.only(top: Dimens.spacingSmall),
              child: Text(
                getString(context, "timesheet_page_not_assigned"),
                style: LelloTextStyles.body(theme)
                    ?.copyWith(color: LelloTheme.palleteOf(theme).warning()),
              ),
            )
          ],
        );
      case TimesheetStatusEnum.assigned:
        return Column(
          children: [
            SvgPicture.asset("assets/ic_timesheet_assigned.svg"),
            Container(
              padding: EdgeInsets.only(top: Dimens.spacingSmall),
              child: Text(
                getString(context, "timesheet_page_assigned"),
                style: LelloTextStyles.body(theme)
                    ?.copyWith(color: LelloTheme.palleteOf(theme).success()),
              ),
            )
          ],
        );
      case TimesheetStatusEnum.notAllowed:
        return Column(
          children: [
            SvgPicture.asset(
              "assets/ic_timesheet_assigned.svg",
              color: LelloTheme.palleteOf(theme).error(),
            ),
            Container(
              padding: EdgeInsets.only(top: Dimens.spacingSmall),
              child: Text(
                'Bloqueado',
                style: LelloTextStyles.body(theme)
                    ?.copyWith(color: LelloTheme.palleteOf(theme).error()),
              ),
            )
          ],
        );
    }
  }

  Widget _buidComponent(
      {required String title,
      required String subtitle,
      required ThemeData theme}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: Dimens.spacingSmall,
        ),
        Text(
          title,
          style: LelloTextStyles.subtitleBold(theme)!.copyWith(
            color: LelloTheme.palleteOf(theme).text(),
          ),
        ),
        SizedBox(
          height: Dimens.spacingXSmall,
        ),
        Text(
          subtitle,
          style: LelloTextStyles.subtitle(theme)!.copyWith(
            color: LelloTheme.palleteOf(theme).text(),
          ),
        ),
      ],
    );
  }
}
