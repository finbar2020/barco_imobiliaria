import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;

import 'package:lello/feature/space/reservation/presentation/bloc/reservation_change_rules/reservation_change_rules_state.dart';
import 'package:lello/feature/space/reservation/presentation/widget/reservation_week_selector_widget.dart';
import 'package:lello/feature/space/reservation/presentation/widget/reservation_weekend_selector_widget.dart';

class ReservationRuleDaysTimeWidget extends StatefulWidget {
  const ReservationRuleDaysTimeWidget({
    Key? key,
    required this.isWeek,
    required this.state,
  }) : super(key: key);

  // If is a week day, set true. If is a weekend day, set false.
  final bool isWeek;
  final ReservationChangeRulesLoadedState state;

  @override
  _ReservationRuleDaysTimeWidgetState createState() =>
      _ReservationRuleDaysTimeWidgetState();
}

class _ReservationRuleDaysTimeWidgetState
    extends State<ReservationRuleDaysTimeWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.isWeek
            ? _buildWeekSelector(widget.state, theme)
            : _buildWeekendSelector(widget.state, theme),
        SizedBox(height: Dimens.spacingMedium),
        _buildHourInfo(context, theme),
        _datePicker(widget.isWeek, theme),
      ],
    );
  }

  Column _buildWeekSelector(
    ReservationChangeRulesLoadedState state,
    ThemeData theme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          getString(context, "week_days"),
          style: LelloTextStyles.caption(theme)!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: Dimens.spacingSmall),
        ReservationWeekSelectorWidget(
          state: state,
        ),
      ],
    );
  }

  Column _buildWeekendSelector(
      ReservationChangeRulesLoadedState state, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          getString(context, "weekend_days"),
          style: LelloTextStyles.caption(theme)!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: Dimens.spacingSmall),
        ReservationWeekendSelectorWidget(
          state: state,
        ),
      ],
    );
  }

  Column _buildHourInfo(BuildContext context, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(getString(context, "time_allowed")),
        SizedBox(height: Dimens.spacingSmall),
        Row(
          children: [
            Expanded(
              child: Text(getString(context, "from"),
                  style: LelloTextStyles.bodyBold(theme)),
            ),
            SizedBox(height: Dimens.spacingSmall),
            Expanded(
              child: Text(getString(context, "to"),
                  style: LelloTextStyles.bodyBold(theme)),
            ),
          ],
        ),
      ],
    );
  }

  DateTime _getDate(String? dateString) {
    DateTime dateNow = DateTime.now();
    if (dateString == null) {
      return dateNow;
    } else {
      int hour = int.parse(dateString.substring(0, 2));
      int minute = int.parse(dateString.substring(3, 5));
      int second = (hour != 0 && minute != 0) ? 0 : 59;
      DateTime newDate = DateTime(
          dateNow.year, dateNow.month, dateNow.day, hour, minute, second);
      return newDate;
    }
  }

  Row _datePicker(bool isWeek, ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Container(
                padding: const EdgeInsets.all(20.0),
                child: Opacity(
                  opacity: (isWeek
                              ? widget.state.rules.weekHourStart
                              : widget.state.rules.weekendHourStart) !=
                          "00:00:00"
                      ? 1
                      : 0.5,
                  child: Text(
                    (isWeek
                        ? _getHourMinute(widget.state.rules.weekHourStart)
                        : _getHourMinute(widget.state.rules.weekendHourStart)),
                    style: LelloTextStyles.subtitle(theme)!
                        .copyWith(fontWeight: FontWeight.normal),
                  ),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  border: Border.all(color: theme.hintColor),
                ),
              ),
            ),
            onTap: () => DatePicker.showTimePicker(
              context,
              showSecondsColumn: false,
              currentTime: _getDate((isWeek
                  ? widget.state.rules.weekHourStart
                  : widget.state.rules.weekendHourStart)),
              theme: DatePickerTheme(
                doneStyle: TextStyle(
                  color: theme.primaryColor,
                  fontSize: 16.0,
                  fontWeight: FontWeight.normal,
                ),
              ),
              onConfirm: (time) {
                setState(() {
                  if (isWeek) {
                    if (widget.state.rules.weekHourEnd == "00:00:00" ||
                        !time.isAfter(
                            _getDate(widget.state.rules.weekHourEnd))) {
                      widget.state.rules.weekHourStart =
                          DateFormat('HH:mm:00').format(time);
                    } else {
                      Flushbar(
                        duration: Duration(seconds: 2),
                        message:
                            "Horário de início deve anteceder ao de término",
                      )..show(context);
                    }
                  } else {
                    if (widget.state.rules.weekendHourEnd == "00:00:00" ||
                        !time.isAfter(
                            _getDate(widget.state.rules.weekendHourEnd))) {
                      widget.state.rules.weekendHourStart =
                          DateFormat('HH:mm:00').format(time);
                    } else {
                      Flushbar(
                        duration: Duration(seconds: 2),
                        message:
                            "Horário de início deve anteceder ao de término",
                      )..show(context);
                    }
                  }
                });
              },
            ),
          ),
        ),
        SizedBox(width: Dimens.spacing),
        Expanded(
          child: InkWell(
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Container(
                padding: const EdgeInsets.all(20.0),
                child: Opacity(
                  opacity: (isWeek
                              ? widget.state.rules.weekHourEnd
                              : widget.state.rules.weekendHourEnd) !=
                          "00:00:00"
                      ? 1
                      : 0.5,
                  child: Text(
                    (isWeek
                        ? _getHourMinute(widget.state.rules.weekHourEnd)
                        : _getHourMinute(widget.state.rules.weekendHourEnd)),
                    style: LelloTextStyles.subtitle(theme)!
                        .copyWith(fontWeight: FontWeight.normal),
                  ),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  border: Border.all(color: theme.hintColor),
                ),
              ),
            ),
            onTap: () => DatePicker.showTimePicker(
              context,
              showSecondsColumn: false,
              currentTime: _getDate((isWeek
                  ? widget.state.rules.weekHourEnd
                  : widget.state.rules.weekendHourEnd)),
              theme: DatePickerTheme(
                doneStyle: TextStyle(
                    color: theme.primaryColor,
                    fontSize: 16.0,
                    fontWeight: FontWeight.normal),
              ),
              onConfirm: (time) {
                setState(() {
                  if (isWeek) {
                    if (DateFormat('HH:mm').format(time) == "00:00" &&
                        !_hasWeekAllowed()) {
                      widget.state.rules.weekHourEnd = "00:00:00";
                    } else if (time
                        .isAfter(_getDate(widget.state.rules.weekHourStart))) {
                      widget.state.rules.weekHourEnd =
                          DateFormat('HH:mm:00').format(time);
                    } else {
                      Flushbar(
                        duration: Duration(seconds: 2),
                        message:
                            "Horário de término deve ser posterior ao de início",
                      )..show(context);
                    }
                  } else {
                    if (DateFormat('HH:mm').format(time) == "00:00" &&
                        !_hasWeekendAllowed()) {
                      widget.state.rules.weekendHourEnd = "00:00:00";
                    } else if (time.isAfter(
                        _getDate(widget.state.rules.weekendHourStart))) {
                      widget.state.rules.weekendHourEnd =
                          DateFormat('HH:mm:00').format(time);
                    } else {
                      Flushbar(
                        duration: Duration(seconds: 2),
                        message:
                            "Horário de término deve ser posterior ao de início",
                      )..show(context);
                    }
                  }
                });
              },
            ),
          ),
        )
      ],
    );
  }

  bool _hasWeekAllowed() {
    if (widget.state.rules.allowedDaysList!.contains(1) ||
        widget.state.rules.allowedDaysList!.contains(2) ||
        widget.state.rules.allowedDaysList!.contains(3) ||
        widget.state.rules.allowedDaysList!.contains(4) ||
        widget.state.rules.allowedDaysList!.contains(5)) {
      return true;
    }
    return false;
  }

  bool _hasWeekendAllowed() {
    if (widget.state.rules.allowedDaysList!.contains(0) ||
        widget.state.rules.allowedDaysList!.contains(6)) {
      return true;
    }
    return false;
  }

  String _getHourMinute(String? time) {
    if (time == null) {
      return "00:00";
    } else if (time.length == 8) {
      return time.substring(0, 5);
    } else {
      return "00:00";
    }
  }
}
